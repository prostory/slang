require_relative 'ast'
require_relative 'clang/context'

module SLang
  class ASTNode
    attr_accessor :type
    attr_accessor :optional
  end

  class Call
    attr_accessor :target_fun

    def target_fun=(fun)
      fun.add_call self
      @target_fun = fun
    end

    def signature
      @signature ||= Signature.new(args.map(&:type))
    end

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
      type && (type == :VarList || (type.is_a?(BaseType) && type.name == :VarList))
    end
  end

  class TypeVisitor < Visitor
    attr_accessor :context

    def initialize(context)
      @context = context;
    end

    def end_visit_expressions(node)
      if node.empty?
        node.type = Type.void
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
        node.type = Type.int
      when Float
        node.type = Type.float
      end
      false
    end

    def visit_bool_literal(node)
      node.type = Type.bool
      false
    end

    def visit_string_literal(node)
      node.type = Type.string
      false
    end

    def visit_array_literal(node)
      node.elements.each do |child|
        child.accept self
      end

      node.type = Type.array_type node.elements.map(&:type)
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
      node.type = node.var_list? ? Type.varlist : Type.types[node.type]
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
      var = context.lookup_member(node.name) or raise "Bug: class variable '#{node.name}' is not defined!"
      node.type = var.type
      node.optional = var.optional
      var << node
      false
    end


    def visit_const(node)
      node.type = Type.types[node.name].class_type or raise "uninitialized constant '#{node.name}'"
      false
    end

    def visit_class_def(node)
      superclass = Type.types[node.superclass] or raise "uninitialized constant '#{node.superclass}'" if node.superclass
      type = Type.object_type node.name, superclass
      context.new_scope(nil, type) do
        node.accept_children self
      end
      false
    end

    def visit_module(node)
      type = Type.module_type node.name
      context.new_scope(nil, type) do
        node.accept_children self
      end
      false
    end

    def visit_include(node)
      node.modules.each do |mod|
        type = Type.types[mod] or raise "uninitialized constant '#{mod}'" if mod
        context.scope.type.include_module type
      end
      false
    end

    def visit_call(node)
      if node.obj
        node.obj.accept self
      else
        node.obj = Variable.new(:self, context.scope.type) if context.scope.type
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

      var = context.lookup_variable(node.name)
      if var && var.type.is_a?(LambdaType) && node.name == var.name
        untyped_fun = var.type.lookup_function(node.signature)
      end

      untyped_fun = context.lookup_function(node.name, node.signature, node.obj) if untyped_fun.nil?

      if untyped_fun.nil?
        error = "undefined function '#{node.name}' (#{types.map(&:to_s).join ', '}), #{node.source_code}"
        error << " for #{node.obj.type.name}" if node.obj
        raise error
      end

      types.unshift node.obj.type if node.obj && untyped_fun.receiver
      node.obj = nil if untyped_fun.receiver.nil?

      typed_fun = untyped_fun[Signature.new(types)]

      if untyped_fun.is_a?(External)
        if typed_fun.nil?
          typed_fun = untyped_fun.clone
          typed_fun.params.unshift Parameter.new(nil, node.obj.type) if node.obj && untyped_fun.receiver
          typed_fun.body.type = untyped_fun.return_type
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
      instance.body.type = Type.void

      scope_type = call.obj ? call.obj.type : Type.kernel

      context.new_scope(function, scope_type) do
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

        if call.name == :__alloc__ && call.obj.type.is_a?(ClassType)
          new_type = call.obj.type.object_type.new_instance
        end

        instance.body.accept self

        instance.body.type = new_type if new_type

        unless instance.body.type.child_of? instance.return_type
          raise "can't cast #{instance.body.type} to #{instance.return_type}"
        end

        unless instance.body.type == Type.void
          unless instance.body.last.nil? || instance.body.last.is_a?(Return)
            ret = Return.new([instance.body.last])
            ret.type = instance.body.type
            instance.body.children.pop
            instance.body << ret
          end
        end
      end
      instance
    end

    def visit_function(node)
      node.params.each {|param| param.accept self }
      node.return_type = Type.types[node.return_type]
      context.add_function node
      if node.name == :main
        node.body.accept self
        node.body.type = node.return_type
        node << node
      end
      false
    end

    def visit_lambda(node)
      node.params.each {|param| param.accept self }
      node.return_type = Type.types[node.return_type]
      node.type = Type.lambda.new_instance
      Type.lambda.add_function node
      false
    end

    def visit_class_fun(node)
      node.params.each {|param| param.accept self }
      node.return_type = Type.types[node.return_type]
      context.add_function node
      false
    end

    def visit_external(node)
      node.params.each {|param| param.accept self }
      node.return_type = Type.types[node.return_type]
      context.add_function node
      false
    end

    def visit_operator(node)
      visit_external node
    end

    def end_visit_if(node)
      if node.else.any?
        node.type = Type.merge(node.then.type, node.else.type)
      else
        node.type = node.then.type
      end
    end

    def end_visit_while(node)
      node.type = Type.void
    end

    def end_visit_return(node)
      if node.values.empty?
        node.type = Type.void
      else
        node.type = node.values[0].type
      end
    end

    def visit_assign(node)
      node.value.accept self
      node.type = node.target.type = node.value.type

      case node.target
      when Member, ClassVar
        old_var = context.lookup_member(node.target.name)
      else
        old_var = context.lookup_variable(node.target.name)
      end

      if old_var
        unless old_var.type.base_type == node.type.base_type
          if !old_var.is_a?(ClassVar) || old_var.target == node.target.target
            unless old_var.type == Type.types[:UnionType]
              Type.union_type(old_var.type)
            end
            Type.union_type(node.value.type)
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
      node.value.accept self
      node.type = Type.types[node.target.name]
      if node.value.type.is_a? UnionType
        raise "can't case #{node.type} to #{node.value.type.despect}" unless node.value.type.include? node.type
      end
      false
    end

    def end_visit_typeof(node)
      node.type = Type.string
    end

    def end_visit_sizeof(node)
      if node.value.type.is_a?(ClassType)
        if node.value.type.object_type.is_a?(ObjectType)
          node.value.type = node.value.type.object_type.latest
        else
          node.value.type = node.value.type.object_type
        end
      elsif node.value.type.is_a? ObjectType
        node.value.type = node.value.type.latest
      end
      node.type = Type.int
    end

    def end_visit_array_new(node)
      raise "array size can not be #{node.size.type}" unless node.size.type == Type.int
      node.type = Type.array_type.new_instance
    end

    def end_visit_array_set(node)
      raise "can't set to the #{node.target.type}" unless node.target.type.is_a? ArrayType
      raise "array index can not be #{node.index.type}" unless node.index.type == Type.int
      node.type = node.value.type
      node.target.type << node.type
    end

    def end_visit_array_get(node)
      raise "can't set to the #{node.target.type}" unless node.target.type.is_a? ArrayType
      raise "array index can not be #{node.index.type}" unless node.index.type == Type.int
      node.type = node.target.type.elements_type
    end
  end
end