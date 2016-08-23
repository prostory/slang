require_relative 'ast'
require_relative 'clang/context'

module SLang
  class ASTNode
    attr_accessor :type
    attr_accessor :unreached
    attr_accessor :optional_type

    def self.return(body, target = nil)
      unless body.last.nil?
        if target
          last = body.children.pop
          if target != last
            assign = last.assign(target)
            body << assign
          end
          body << target.clone.return
        else
          body << body.children.pop.return
        end
      end
      body
    end

    def self.assign(target, body)
      unless body.last.nil?
        body << body.children.pop.assign(target)
      end
      body
    end

    def return
      Return.new([self])
    end

    def assign(target)
      Assign.new(target.clone, self)
    end
  end

  class Expressions
    def return(target = nil)
      self.class.return self, target
    end

    def assign(target)
      self.class.assign target, self
    end
  end

  class Call
    attr_accessor :target_fun
    attr_accessor :unreachable

    def unreached?
      return true if unreachable
      return true if unreached
      return true if obj && obj.unreached
      return true if args.find {|arg| arg.unreached }
      return false
    end

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
    attr_accessor :instances
    attr_accessor :sequence

    def <<(instance)
      @instances ||= []
      @instances << instance
      instance.sequence = sequence
    end

    def sequence
      @sequence || 0
    end

    def init_optional_type
      @optional_type = @type
      @instances.each {|var| var.optional_type = var.type } if @instances
    end
    
    def optional?
      !type.union_type? && !optional_type.nil?
    end

    def var_list?
      type && (type == :VarList || type.is_a?(VarList))
    end
  end

  class ClassVar
    def <<(instance)
      super(instance)
      instance.target = target
    end
  end

  class If
    def return
      @then.return
      @else.return if @else
      self
    end

    def assign(target)
      @then.assign target
      @else.assign target if @else
      self
    end
  end

  class While
    def return
      self
    end

    def assign(target)
      self
    end
  end

  class Return
    def return
      self
    end

    def assign(target)
      if values.empty?
        self
      else
        values[0].assign(target)
      end
    end
  end

  class Module
    attr_accessor :define
  end

  class Const
    attr_accessor :defined
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

    def visit_nil_literal(node)
      node.type = Type.nil
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
      var = context.lookup_variable(node.name)
      if var.nil?
        call = Call.new(node.name)
        visit_call(call)
        node.parent.replace(node, call)
        return
      end
      node.type = var.type
      node.optional_type = node.type if var.optional?
      var << node
      false
    end

    def visit_parameter(node)
      node.type = node.var_list? ? Type.varlist : Type.types[node.type]
      false
    end

    def visit_member(node)
      var = context.lookup_instance_var(node.name)
      raise "Bug: instance variable '#{node.name}' for #{context.scope.type} is not defined!" if var.nil?
      node.type = var.type
      node.optional_type = node.type if var.optional?
      var << node
      false
    end

    def visit_class_var(node)
      var = context.lookup_class_var(node.name) or raise "Bug: class variable '#{node.name}' is not defined!"
      node.type = var.type
      node.optional_type = node.type if var.optional?
      var << node
      false
    end


    def visit_const(node)
      if node.name == :Main
        node.type = context.main_top
        return
      end
      const = lookup_const(node)
      raise "uninitialized constant '#{node.name}' in #{node.target ? node.target.type : context.scope.type}" if const.nil?
      node.type = const.type
      node.target = const.target
      false
    end

    def lookup_const(node)
      if node.target
        node.target.accept self
        node.target.type.lookup_const(node.name)
      else
        context.lookup_const(node.name)
      end
    end

    def visit_class_def(node)
      superclass = nil
      if node.superclass
        node.superclass.accept self
        superclass = node.superclass.type.object_type
      end
      name = node.name.name
      type = Type.object_type name, superclass
      const = lookup_const(node.name)
      if const.nil? || !const.defined
        define_class = Assign.new(node.name, Call.new(:new, [], Const.new(:Class)))
        define_class.type = type.class_type(define_class.target)
        Type.lookup(:Class).add_instance define_class.type
        context.define_class(define_class.target)
        node.define = define_class
        node.define.accept self
        node << Function.new(:type_id, [], [NumberLiteral.new(type.type_id)], :Integer, node.name)
        node << Function.new(:class, [], [Const.new(name)], :Any)
      end
      context.new_scope(nil, type) do
        node.accept_children self
      end
      false
    end

    def visit_module(node)
      type = Type.module_type node.name.name
      const = lookup_const(node.name)
      if const.nil? || !const.defined
        define_class = Assign.new(node.name, Call.new(:new, [], Const.new(:Class)))
        define_class.type = type.class_type(define_class.target)
        Type.lookup(:Class).add_instance define_class.type
        context.define_class(define_class.target)
        node.define = define_class
        node.define.accept self
      end
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
          node.args << var
          types << var.type
        end
      end

      if node.unreached?
        node.type = Type.any if node.type.nil?
        return
      end

      var = context.lookup_variable(node.name)
      if var && var.type.is_a?(LambdaType) && node.name == var.name
        untyped_fun = var.type.lookup_function(node.signature)
      end

      untyped_fun = context.lookup_function(node.name, node.signature, node.obj) if untyped_fun.nil?

      if untyped_fun.nil?
        error = "undefined function '#{node.name}'(#{types.map(&:despect).join ', '}), #{node.source_code}"
        error << " for #{node.obj.type.despect}" if node.obj
        raise error
      end
      if untyped_fun.receiver && untyped_fun.owner != untyped_fun.receiver
        untyped_fun.receiver.accept self
        node.obj = untyped_fun.receiver
      end

      types.unshift node.obj.type if node.obj && untyped_fun.receiver
      node.obj = nil if untyped_fun.receiver.nil?
      if context.scope.func
        untyped_fun.set_chain context.scope.func.chain
      else
        untyped_fun.set_chain []
      end

      if untyped_fun.closed_loop?
        untyped_fun.add_recursive_call node
        node.type = Type.any
        untyped_fun.chain.pop
        return
      end

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
        untyped_fun.chain.pop
        return
      end

      new_fun = typed_function(untyped_fun, node)

      if typed_fun && new_fun.body.type == typed_fun.body.type
        node.target_fun = typed_fun
        node.type = typed_fun.body.type
      else
        if untyped_fun.recursive_calls
          untyped_fun.recursive_calls.each do |call|
            call.target_fun = new_fun
            call.type = new_fun.body.type
            call.obj = nil if untyped_fun.receiver.nil?
          end

          if untyped_fun.recursive_calls.find {|call| call.unreached} != nil
            untyped_fun.recursive_calls.each do |call|
              call.unreached = false
            end

            new_fun = typed_instance(new_fun, untyped_fun, node)

            untyped_fun.recursive_calls.each do |call|
              call.target_fun = new_fun
              call.type = new_fun.body.type
              call.obj = nil if untyped_fun.receiver.nil?
            end
            untyped_fun.recursive_calls.clear
          end
        end

        untyped_fun << new_fun

        node.target_fun = new_fun
        node.type = new_fun.body.type
      end

      untyped_fun.chain.pop

      false
    end

    def typed_function(function, call)
      instance = function.clone
      typed_instance(instance, function, call)
    end

    def typed_instance(instance, function, call)
      instance.body.type = Type.void

      scope_type = call.obj ? call.obj.type : nil

      context.new_scope(function, scope_type) do
        function.clear_variables
        if call.obj
          self_var = Parameter.new(:self, call.obj.type)
          context.define_variable self_var
        end

        context.define_variable Variable.new(:result, Type.nil)

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
          if call.obj.type == Type.lookup_class(:Class)
            new_type = call.obj.type.object_type.latest
          else
            new_type = call.obj.type.object_type.new_instance
          end
        end

        instance.body.accept self

        instance.body.type = new_type if new_type

        unless instance.body.type.cast_of? instance.return_type
          raise "can't cast #{instance.body.type} to #{instance.return_type}"
        end
      end
      instance
    end

    def visit_function(node)
      node.owner.accept self if node.owner
      node.params.each {|param| param.accept self }
      node.body.return(Variable.new(:result))
      node.return_type = Type.lookup(node.return_type)
      context.add_function node
      if node.name == :main
        visit_call(Call.new(:main))
        node.body.type = node.return_type
      end
      false
    end

    def visit_lambda(node)
      node.owner.accept self if node.owner
      node.params.each {|param| param.accept self }
      node.body.return(Variable.new(:result))
      node.return_type = Type.lookup(node.return_type)
      node.type = Type.lambda.new_instance
      Type.lambda.add_function node
      false
    end

    def visit_external(node)
      node.owner.accept self if node.owner
      node.params.each {|param| param.accept self }
      node.return_type = Type.lookup(node.return_type)
      context.add_function node
      false
    end

    def visit_operator(node)
      visit_external node
    end

    def visit_if(node)
      node.cond.accept self
      with_branch do
        node.then.accept self
        node.else.accept self if node.else
      end

      if node.else.any?
        node.type = Type.merge(node.then.type, node.else.type)
      else
        node.type = node.then.type
      end
      false
    end

    def end_visit_while(node)
      node.type = Type.void
    end

    def visit_return(node)
      node.values.each { |value| value.accept self }
      if node.values.empty?
        node.type = Type.void
      else
        node.type = node.values[0].type
      end
      false
    end

    def visit_assign(node)   
      if node.value.is_a? If
        assign_if = node.value.assign(node.target)
        node.parent.replace(node, assign_if)
        assign_if.accept self
        return false
      end

      node.value.accept self

      if node.value.type == Type.void
        node.parent.replace(node, node.value)
        return false
      end

      node.type = node.target.type = node.value.type

      if node.target.is_a?(Const)
        if node.target.type.is_a?(ClassType)
          return false
        else
          context.define_const node.target
        end
        return false
      end

      case node.target
      when Member
        var = context.lookup_instance_var(node.target.name)
      when ClassVar
        var = context.lookup_class_var(node.target.name)
      else
        var = context.lookup_variable(node.target.name)
      end

      if var && (var.type.any_type? || var.type.nil_type? )
        var.type = node.type
      end

      if var.nil? || var.type != node.type
        if var
          if @branch || var.is_a?(Member) || var.is_a?(ClassVar)
            type = Type.merge(var.type, node.type)
            if type.union_type?
              var.init_optional_type unless var.type.union_type?
              node.target.optional_type = node.type
              if @branch
                var.type = type
              else
                context.define_variable node.target
              end
              var << node.target
            else
              if node.type.any_type?
                node.type = node.target.type = type
              end
            end
            return false
          end
          node.target.sequence = var.sequence + 1
        end
        context.define_variable node.target
      else
        var << node.target
      end

      false
    end

    def visit_cast(node)
      node.value.accept self
      node.type = Type.lookup(node.cast_type)
      unless node.value.type.cast_of? node.type
        raise "can't case #{node.value.type.despect} to #{node.type.despect}"
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

    def with_branch
      @branch = true
      yield
      @branch = false
    end
  end
end
