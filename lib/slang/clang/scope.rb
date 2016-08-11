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

      def lookup_instance_var(name)
        @type.lookup_instance_var name
      end

      def lookup_class_var(name)
        @type.lookup_class_var name
      end

      def <<(var)
        case var
        when Member, ClassVar
          @type << var
        else
          @vars[var.name] = var
        end
        if @func && var.instance_of?(Variable)
          @func.add_variable var
        end
      end
    end
  end
end