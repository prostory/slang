module SLang
  module CLang
    class CFunction
      attr_accessor :context
      attr_accessor :functions

      def initialize(context)
        @context = context
        @functions = {}
      end

      def <<(fun)
        @functions[fun.name] = fun
      end

      def [](name)
        @functions[name]
      end

      def declear_functions
        functions.values.each { |fun| declear_function fun unless fun.name == 'main' }
      end

      def define_functions
        functions.values.each { |fun| define_function fun }
      end

      def declear_function(node)
        node.instances.each {|_, fun| declear_function_instance fun} if node.instances
      end

      def declear_function_instance(node)
        stream << "extern #{node.body.type} #{node.mangled_name}("
        define_paramters(node)
        stream << ");\n"
      end

      def define_function(node)
        node.instances.each {|_, fun| define_function_instance fun} if node.instances
      end

      def define_function_instance(node)
        stream << "#{node.body.type} #{node.mangled_name}("
        define_paramters(node)
        stream << ")\n{\n"
        with_indent do
          node.body.accept visitor
        end
        indent
        stream << "}\n"
      end

      def define_paramters(node)
        if node.params.length > 0
          node.params.each_with_index do |param, i|
            stream << ', ' if i > 0
            param.accept visitor
          end
        else
          stream << context.void.to_s
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