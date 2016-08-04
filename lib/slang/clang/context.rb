module SLang
  module CLang
    class Context
      attr_accessor :scopes
      attr_accessor :type
      attr_accessor :codegen

      def initialize
        Type.init_base_types

        @scopes = [Scope.new(main, Type.kernel)]
        @type = TypeVisitor.new(self)
        @codegen = CodeGenVisitor.new(self)
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

        codegen.define_types
        codegen.declare_functions
        codegen.define_functions

        codegen.to_s
      end

      def add_function(fun)
        if fun.scope
          Type.types[fun.scope.name].add_function fun
        else
          Type.kernel.add_function fun
        end
        fun
      end

      def lookup_function(name, signature, obj)
        obj.type.lookup_function(name, signature)
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
