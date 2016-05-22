module SLang
  module CLang
    class Context
      attr_accessor :type
      attr_accessor :scopes
      attr_accessor :functions

      def initialize
        @type = CType.new
        @scopes = [Scope.new(main)]
        @functions = {}
      end

      def void
        base(:void, :Void)
      end

      def int
        base(:int, :Int)
      end

      def raw_string
        base('char *', :RawString)
      end

      def base(ctype, name)
        type.base(ctype, name)
      end

      def struct(members, name = nil)
        type.struct members, name
      end

      def union(members, name = nil)
        type.union members, name
      end

      def merge(t1, t2)
        type.merge t1, t2
      end

      def main
        nil
      end

      def type_inference(node)
        node.accept TypeVisitor.new(self)
        self
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