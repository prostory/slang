module SLang
  module CLang
    class Context
      attr_accessor :scopes
      attr_accessor :type
      attr_accessor :codegen

      def initialize
        Type.init_base_types

        @scopes = [Scope.new(main, Type.main)]
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
        if fun.owner
          fun.owner.type.object_type.add_function fun
        else
          main_top.add_function fun
        end
        fun
      end

      def lookup_function(name, signature, obj)
        obj.type.lookup_function(name, signature) || main_top.lookup_function(name, signature)
      end

      def define_variable(var)
        scope << var
      end

      def lookup_variable(name)
        scope.lookup_variable name
      end

      def lookup_instance_var(name)
        scope.lookup_instance_var name
      end

      def lookup_class_var(name)
        scope.lookup_class_var name
      end
      
      def lookup_const(name)
        scope.lookup_const(name) || main_top.lookup_const(name)
      end
      
      def define_const(const)
        scope.define_const const
      end
      
      def define_class(const)
        scope.define_class const
      end
      
      def main_top
        Type.main
      end

      def new_scope(obj, type)
        @scopes.push(Scope.new obj, type || main_top)
        yield
        @scopes.pop
      end

      def scope
        @scopes.last
      end
    end
  end
end
