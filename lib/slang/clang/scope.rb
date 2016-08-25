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
      
      def lookup_const(name)
        @type.lookup_const name
      end
      
      def define_const(const)
        @type.define_const const
      end
      
      def define_class(const)
        @type.define_class const
      end

      def <<(var)
        case var
        when Member, ClassVar
          @type << var
        else
          var.sequence = @vars[var.name].sequence + 1 if @vars[var.name]
          @vars[var.name] = var
        end
        if @func && var.instance_of?(Variable)
          @func.add_variable var
        end
      end
    end
  end
end
