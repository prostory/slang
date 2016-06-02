module SLang
  class Function
    attr_accessor :redefined
  end

  module CLang
    class CFunction
      attr_accessor :context
      attr_accessor :functions
      attr_accessor :externals

      def initialize(context)
        @context = context
        @functions = {}
        @externals = {}
      end

      def <<(fun)
        if fun.is_a? External
          externals[fun.name] = fun
        else
          functions[fun.name] = fun
        end
      end

      def [](name)
        functions[name] || externals[name]
      end

      def declear_functions
        externals.values.each { |fun| declear_function fun unless fun.is_a? Operator}
        functions.values.each { |fun| declear_function fun unless fun.name == :main }
      end

      def define_functions
        functions.values.each { |fun| define_function fun }
      end

      def declear_function(node)
        node.instances.values.each do |fun|
          if !fun.redefined
            if fun.instances
              fun.instances.values.each {|instance| declear_function_instance instance}
            else
              declear_function_instance fun
            end
          end
        end if node.instances
      end

      def declear_function_instance(node)
        stream << "extern #{node.body.type} #{node.mangled_name}("
        define_paramters(node)
        stream << ");\n"
      end

      def define_function(node)
        node.instances.each do |_, fun|
          if !fun.redefined
            if fun.instances
              fun.instances.values.each {|instance| define_function_instance instance}
            else
              define_function_instance fun
            end
          end
        end if node.instances
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