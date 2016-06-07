require_relative 'ast'
require_relative 'clang/context'

module SLang
  class ASTNode
    attr_accessor :type
    attr_accessor :optional
  end

  class Call
    attr_accessor :target_fun

    def has_var_list?
      args.any? && args.last.is_a?(Variable) && args.last.var_list?
    end
  end

  class Variable
    attr_accessor :defined
    attr_accessor :instances

    def <<(instance)
      @instances ||= []
      @instances << instance
    end

    def optional=(is_optional)
      unless optional == is_optional
        @optional = is_optional
        @instances.each {|instance| instance.optional = is_optional} if @instances
      end
    end

    def var_list?
      type && (type == :VarList || (type.is_a?(CLang::BaseType) && type.name == :VarList))
    end
  end

  class Function
    attr_accessor :owner
    attr_accessor :mangled
    attr_accessor :instances
    attr_accessor :mangled_return_type

    def <<(instance)
      @instances ||= {}
      unless mangled
        if @mangled = @instances.size > 0
          @instances.each_value {|instance| instance.mangled = @mangled}
        end
      end
      instance.mangled = @mangled
      fun = @instances[self.class.signature(instance)]
      if fun && fun.body.type != instance.body.type
        fun.instances ||= {}
        fun.instances[fun.body.type] = fun unless fun.instances[fun.body.type]
        fun.instances[instance.body.type] = instance
        fun.mangled_return_type = true
        instance.mangled_return_type = true
      else
        @instances[self.class.signature(instance)] = instance
      end
      instance.owner.methods << instance if instance.owner
    end

    def self.signature(fun)
      fun.params.map(&:type)
    end

    def [](arg_types)
      @instances && @instances[arg_types]
    end

    def has_var_list?
      params.any? && params.last.var_list?
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
      var = context.lookup_variable(node.name) or raise "Bug: variable '#{node.name}' is not defined!"
      node.type = var.type
      node.optional = var.optional
      node.defined = true
      var << node
      false
    end

    def visit_parameter(node)
      node.type = node.var_list? ? context.varlist : context.types[node.type]
      false
    end

    def visit_member(node)
      var = context.lookup_member(node.name) or raise "Bug: instance variable '#{node.name}' is not defined!"
      node.type = var.type
      node.optional = var.optional
      var << node
      false
    end

    def visit_class_var(node)
      var = context.lookup_class_var(node.name) or raise "Bug: class variable '#{node.name}' is not defined!"
      node.target = var.target
      node.type = var.type
      node.optional = var.optional
      var << node
      false
    end

    def visit_class_def(node)
      superclass = context.types[node.superclass] or raise "uninitialized constant '#{node.superclass}'" if node.superclass
      type = context.object_type node.name, superclass
      context.new_scope(nil, type) do
        node.accept_children self
      end
      false
    end

    def visit_call(node)
      node.obj ||= Variable.new(:self, context.scope.type) if context.scope

      if node.obj
        node.obj.accept self

        if node.obj.is_a? Const
          node.obj.type = context.types[node.obj.name].class_type or raise "uninitialized constant #{node.obj.name}"
        end

        if node.name == :type
          node.type = context.string
          return false
        end

        if node.obj.type.is_a?(CLang::ClassType)
          case node.name
          when :sizeof
            node.type = context.int
            return false
          end
        end
      end

      types = node.args.each {|arg| arg.accept self}.map(&:type)

      if node.has_var_list?
        node.args.pop
        types.last.vars.each do |var|
          var.defined = true
          node.args << var
          types << var.type
        end
      end

      unless untyped_fun = context.lookup_function(node.name, node.obj, node.args.size)
        error = "undefined function '#{node.name}' (#{types.map(&:despect).join ', '}), #{node.source_code}"
        error << " for #{node.obj.type.name}" if node.obj
        raise error
      end

      types.unshift node.obj.type if node.obj && untyped_fun.receiver
      node.obj = nil if untyped_fun.receiver.nil?

      typed_fun = untyped_fun[types]

      if untyped_fun.is_a?(External)
        unless typed_fun
          typed_fun = untyped_fun.clone
          typed_fun.params.unshift Parameter.new(nil, context.types[typed_fun.receiver.name]) if typed_fun.receiver
          typed_fun.body.type = context.types[typed_fun.return_type]
          untyped_fun << typed_fun
        end
        node.target_fun = typed_fun
        node.type = typed_fun.body.type
        return
      end

      new_fun = typed_function(untyped_fun, node)

      if typed_fun && new_fun.body.type == typed_fun.body.type
        node.target_fun = typed_fun
        node.type = typed_fun.body.type
      else
        untyped_fun << new_fun

        node.target_fun = new_fun
        node.type = new_fun.body.type
      end

      false
    end

    def typed_function(function, call)
      instance = function.clone
      instance.owner = call.obj.type if call.obj
      instance.body.type = context.void

      context.new_scope(function, call.obj && call.obj.type) do
        if call.obj
          self_var = Parameter.new(:self, call.obj.type)
          context.define_variable self_var
        end

        instance.params.each {|param| param.accept self}

        varlist = instance.params.pop if instance.has_var_list?

        call.args.each_with_index do |_, i|
          if i >= instance.params.length
            if varlist
              varlist.type << call.args[i].type
            end
          else
            instance.params[i].type = call.args[i].type
            context.define_variable instance.params[i]
          end
        end

        if varlist
          instance.params.push varlist unless varlist.type.empty?
          context.define_variable varlist
        end

        instance.params.unshift self_var if self_var

        instance.body.accept self

        unless instance.return_type == :unknown
          instance.body.type = context.types[instance.return_type]
        end

        unless instance.body.type == context.void
          unless instance.body.last.nil? || instance.body.last.is_a?(Return)
            ret = Return.new([instance.body.last])
            ret.accept self
            instance.body.children.pop
            instance.body << ret
          end
        end
      end
      instance
    end

    def visit_function(node)
      context.add_function node
      if node.name == :main
        node.body.accept self
        node.body.type = context.types[node.return_type]
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

    def visit_class_fun(node)
      context.add_function node
      false
    end

    def visit_operator(node)
      context.add_function node
      true
    end

    def end_visit_if(node)
      if node.else.any?
        node.type = context.merge(node.then.type, node.else.type)
      else
        node.type = node.then.type
      end
    end

    def end_visit_return(node)
      if node.values.empty?
        node.type = context.void
      else
        node.type = node.values[0].type
      end
    end

    def visit_assign(node)
      node.value.accept self
      node.type = node.target.type = node.value.type

      case node.target
      when Member
        old_var = context.lookup_member(node.target.name)
      when ClassVar
        old_var = context.lookup_class_var(node.target.name)
      else
        old_var = context.lookup_variable(node.target.name)
      end

      if old_var
        unless old_var.type.base_type == node.type.base_type
          if !old_var.is_a?(ClassVar) || old_var.target == node.target.target
            unless old_var.type == context.types[:UnionType]
              context.union_type(old_var.type)
            end
            context.union_type(node.value.type)
            old_var.optional = true
            node.target.optional = true
          end
        end
        unless node.target.is_a?(Member) || node.target.is_a?(ClassVar)
          node.target.defined = true
        end
      end
      context.define_variable node.target

      false
    end

    def visit_cast(node)
      node.target.accept self
      node.value.accept self
      node.type = node.value.type = node.target.obj.type.object_type
      false
    end
  end
end
