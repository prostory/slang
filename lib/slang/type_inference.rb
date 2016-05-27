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
    attr_accessor :owner
    attr_accessor :mangled
    attr_accessor :instances

    def <<(instance)
      @instances ||= {}
      unless mangled
        if @mangled = @instances.size > 0
          @instances.each_value {|instance| instance.mangled = @mangled}
        end
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
      case node.value
      when Fixnum
        node.type = context.int
      when Float
        node.type = context.float
      end
      false
    end

    def visit_bool_literal(node)
      node.type = context.bool
    end

    def visit_string_literal(node)
      node.type = context.string
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
      if node.obj
        node.obj.accept self
      end

      types = node.args.each {|arg| arg.accept self}.map(&:type)

      types.unshift node.obj.type if node.obj

      unless untyped_fun = context.lookup_function(node.name, node.obj)
        error = "undefined function '#{node.name}' (#{types.join ', '})"
        error << " for #{node.obj.type.name}" if node.obj
        raise error
      end

      if node.args.length != untyped_fun.params.length
        raise "wrong number of arguments for '#{node.name}' (#{node.args.length} for #{untyped_fun.params.length})"
      end

      if untyped_fun.instance_of?(External) && types != untyped_fun.params.map(&:type)
        error = "undefined function '#{node.name}' (#{types.join ', '})"
        error << " for #{node.obj.type.name}" if node.obj
        raise error
      end

      typed_fun = untyped_fun[types]

      if untyped_fun.is_a?(Operator) && typed_fun == nil
        error = "undefined operator '#{node.name}' (#{types.join ', '})"
        error << " for #{node.obj.type.name}" if node.obj
        raise error
      end

      if untyped_fun.instance_of?(External) && typed_fun == nil
        typed_fun = untyped_fun.clone
        typed_fun.body.type = context.ctypes[typed_fun.return_type]
        untyped_fun << typed_fun
      end

      if typed_fun
        node.target_fun = typed_fun
        node.type = typed_fun.body.type
        return
      end

      typed_fun ||= untyped_fun.clone
      typed_fun.owner = node.obj.type if node.obj
      typed_fun.body.type = context.void

      context.new_scope(untyped_fun) do
        if node.obj
          self_var = Variable.new(:self)
          self_var.type = node.obj.type
          context.define_variable self_var
        end

        untyped_fun.params.each_with_index do |_, i|
          typed_fun.params[i].type = node.args[i].type
          context.define_variable typed_fun.params[i]
        end

        typed_fun.params.unshift self_var if self_var

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

    def end_visit_operator(node)
      node.body.type = context.ctypes[node.return_type]
      op = context.lookup_function node.name
      if op
        op << node
      else
        context.add_function node
        node << node.clone
      end
    end

    def end_visit_if(node)
      if node.else.any?
        node.type = context.merge(node.then.type, node.else.type)
      else
        node.type = node.then.type
      end
    end

    def end_visit_return(node)
      node.type = node.values[0].type
    end
  end
end