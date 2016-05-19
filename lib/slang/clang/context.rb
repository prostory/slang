module SLang
  module CLang
    class Context
      attr_accessor :type

      def initialize
        @type = CType.new
      end

      def void
        type.base(:void, :Void)
      end

      def int
        type.base(:int, :Int)
      end

      def string
        type.base('char *', :String)
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

      def unmerge(t1, t2)
        type.unmerge t1, t2
      end
    end
  end
end