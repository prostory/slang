module SLang
  module CLang
    class Scope
      attr_accessor :vars
      attr_accessor :func

      def initialize(func)
        @vars = {}
        @func = func
      end

      def lookup(name)
        @vars[name] or raise "Bug: variable #{name} is not defined!"
      end

      def [](name)
        @vars[name]
      end

      def <<(var)
        @vars[var.name] = var.type
      end
    end
  end
end