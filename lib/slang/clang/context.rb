module SLang
  module CLang
    class Context
      attr_accessor :scopes
      attr_accessor :type
      attr_accessor :codegen

      def initialize
        @ctype = CType.new(self)
        @cfunc = CFunction.new(self)
        @scopes = [Scope.new(main)]
        @type = TypeVisitor.new(self)
        @codegen = CodeGenVisitor.new(self)

        base_type(:void, :Void)
        base_type(:int, :Int)
        base_type('char *', :RawString)
      end

      def void
        ctypes[:Void]
      end

      def int
        ctypes[:Int]
      end

      def raw_string
        ctypes[:RawString]
      end

      def base_type(type, name)
        @ctype.base(type, name)
      end

      def struct(members, name = nil)
        @ctype.struct members, name
      end

      def union(members, name = nil)
        @ctype.union members, name
      end

      def merge(t1, t2)
        @ctype.merge t1, t2
      end

      def ctypes
        @ctype.types
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

        @ctype.define_types
        @cfunc.declear_functions
        @cfunc.define_functions

        codegen.to_s
      end

      def add_function(fun)
        @cfunc << fun
      end

      def lookup_function(name)
        @cfunc[name]
      end

      def define_variable(var)
        scope << var
      end

      def lookup_variable(name)
        scope.lookup name
      end

      def new_scope(obj)
        @scopes.push(Scope.new obj)
        yield
        @scopes.pop
      end

      def scope
        @scopes.last
      end
    end
  end
end