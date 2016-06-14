module SLang
  module CLang
    class Context
      attr_accessor :scopes
      attr_accessor :type
      attr_accessor :codegen

      def initialize
        @cfunc = CFunction.new(self)
        @scopes = [Scope.new(main, nil)]
        @type = TypeVisitor.new(self)
        @codegen = CodeGenVisitor.new(self)

        Type.init_base_types
      end

      def main
        nil
      end

      def type_inference(node)
        node.accept type
        self
      end

      def gen_code(node)
        type_inference node

        codegen.declare_type_functions
        @cfunc.declare_functions
        codegen.define_type_functions
        @cfunc.define_functions

        codegen.to_s
      end

      def add_function(fun)
        if class_def = fun.receiver
          Type.types[class_def.name].add_function fun
        else
          @cfunc << fun
        end
        fun
      end

      def lookup_function(name, args, obj = nil)
        if obj && obj.type
          fun = obj.type.lookup_function(name, args)
          return fun if fun
        end
        template = @cfunc[name]
        return template.lookup(args) if template
      end

      def define_variable(var)
        scope << var
      end

      def lookup_variable(name)
        scope.lookup_variable name
      end

      def lookup_member(name)
        scope.lookup_member name
      end

      def new_scope(obj, type)
        @scopes.push(Scope.new obj, type)
        yield
        @scopes.pop
      end

      def scope
        @scopes.last
      end
    end
  end
end
