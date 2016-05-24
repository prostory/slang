require_relative 'ast'
require_relative 'clang/context'

module SLang
  class ASTNode
    attr_accessor :type
  end

  class Call
    attr_accessor :target_fun
  end

  class Function
    attr_accessor :mangled
    attr_accessor :instances

    def <<(instance)
      @instances ||= {}
      if @mangled = @instances.size > 0
        @instances.each_value {|instance| instance.mangled = @mangled}
      end
      instance.mangled = @mangled
      @instances[instance.params.map(&:type)] = instance
    end

    def [](arg_types)
      @instances && @instances[arg_types]
    end
  end

  class TypeVisitor < Visitor
    attr_accessor :context

    def initialize(context)
      @context = context;
    end

    def end_visit_expressions(node)
      if node.empty?
        node.type = context.void
      else
        node.type = node.last.type
      end
    end

    def end_visit_do(node)
      end_visit_expressions(node)
    end

    def visit_number_literal(node)
      node.type = context.int
      false
    end

    def visit_string_literal(node)
      node.type = context.raw_string
      false
    end

    def visit_variable(node)
      node.type = context.lookup_variable node.name
      false
    end

    def visit_paramter(node)
      node.type = context.ctypes[node.type]
      false
    end

    def visit_argument(node)
      visit_variable node
    end

    def visit_call(node)
      types = node.args.each {|arg| arg.accept self}.map(&:type)

      unless untyped_fun = context.lookup_function(node.name)
        raise "undefined function #{node.name}(#{types.join ', '})"
      end

      if untyped_fun.is_a? External
        if types == untyped_fun.params.map(&:type)
          untyped_fun.body.type = context.ctypes[untyped_fun.return_type]
          untyped_fun << untyped_fun

          node.target_fun = untyped_fun
          node.type = untyped_fun.body.type
          return
        end

        raise "undefined function #{node.name}(#{types.join ', '})"
      end

      if node.args.length != untyped_fun.params.length
        raise "wrong number of arguments for '#{node.name}' (#{node.args.length} for #{untyped_fun.params.length})"
      end

      typed_fun = untyped_fun[types]
      if typed_fun && context.scopes.any? {|s| s.func == untyped_fun }
        node.target_fun = typed_fun
        node.type = typed_fun.body.type
        return
      end

      typed_fun ||= untyped_fun.clone
      typed_fun.body.type = context.void

      context.new_scope(untyped_fun) do
        untyped_fun.params.each_with_index do |_, i|
          typed_fun.params[i].type = node.args[i].type
          context.define_variable typed_fun.params[i]
        end

        untyped_fun << typed_fun
        typed_fun.body.accept self
        unless typed_fun.return_type == :unknown
          typed_fun.body.type = context.ctypes[typed_fun.return_type]
        end
      end

      node.target_fun = typed_fun
      node.type = typed_fun.body.type

      false
    end

    def visit_function(node)
      context.add_function node
      if node.name == :main
        node.body.accept self
        node.body.type = context.ctypes[node.return_type]
        node << node
      end
      false
    end

    def visit_lambda(node)
      visit_function node
    end

    def visit_external(node)
      context.add_function node
      true
    end

    def end_visit_if(node)
      if node.else.any?
        node.type = context.merge(node.then.type, node.else.type)
      else
        node.type = node.then.type
      end
      false
    end

    def end_visit_return(node)
      node.type = node.values[0].type
    end
  end
end