module SLang
  class Function
    attr_accessor :redefined
  end

  module CLang
    class CFunction
      attr_accessor :context
      attr_accessor :prototypes

      def initialize(context)
        @context = context
        @prototypes = {}
      end

      def <<(fun)
        prototype = prototypes[fun.name] || FunctionPrototype.new
        prototype << fun
        fun.prototype = prototype
        prototypes[fun.name] = prototype
      end

      def [](name)
        prototypes[name]
      end

      def declare_functions
        prototypes.values.each do |pt|
          pt.instances.each {|fun| declare_function fun unless fun.name == :main || fun.is_a?(Operator)}
        end
      end

      def define_functions
        prototypes.values.each do |pt|
          pt.instances.each {|fun| define_function fun unless fun.is_a? External}
        end
      end

      def declare_function(fun)
        declare_function_instance fun unless fun.redefined
      end

      def declare_function_instance(node)
        stream << "extern #{node.body.type.reference} #{node.mangled_name}("
        define_parameters(node)
        stream << ");\n"
      end

      def define_function(fun)
        define_function_instance fun unless fun.redefined
      end

      def define_function_instance(node)
        stream << "#{node.body.type.reference} #{node.mangled_name}("
        define_parameters(node)
        stream << ")\n{\n"
        with_indent do
          node.body.accept visitor
        end
        indent
        stream << "}\n"
      end

      def define_parameters(node)
        if node.params.length > 0
          node.params.each_with_index do |param, i|
            stream << ', ' if i > 0
            if node.is_a?(External) && param.var_list?
              stream << '...'
            else
              param.accept visitor
            end
          end
        else
          stream << Type.void.to_s
        end
      end

      private
      def visitor
        context.codegen
      end

      def with_indent(&block)
        visitor.with_indent(&block)
      end

      def indent
        visitor.indent
      end

      def stream
        visitor.stream
      end
    end
  end
end
