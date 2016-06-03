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

      def lookup_class_var(name)
        puts "#{@type.class_type.name}, #{name}"
        @type.class_type.members[name]
      end

      def <<(var)
        case var
        when Member
          @type.members[var.name] = var
        when ClassVar
          @type.class_type.members[var.name] = var
        else
          @vars[var.name] = var
        end
      end
    end
  end
end