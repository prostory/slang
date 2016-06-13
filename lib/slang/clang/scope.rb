module SLang
  module CLang
    class Scope
      attr_accessor :vars
      attr_accessor :func
      attr_accessor :type

      def initialize(func, type)
        @vars = {}
        @func = func
        @type = type
      end

      def lookup_variable(name)
        @vars[name]
      end

      def lookup_member(name)
        @type[name]
      end

      def <<(var)
        case var
        when Member, ClassVar
          @type << var
        else
          @vars[var.name] = var
        end
      end
    end
  end
end