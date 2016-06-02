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
        @type.members[name]
      end

      def <<(var)
        if var.is_a? Member
          @type.members[var.name] = var
        else
          @vars[var.name] = var
        end
      end
    end
  end
end