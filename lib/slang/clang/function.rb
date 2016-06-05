module SLang
  class Function
    attr_accessor :redefined
    attr_accessor :sequence
  end

  class FunctionTemplate
    attr_accessor :name

    def initialize
      @instances = []
    end

    def <<(fun)
      @name ||= fun.name
      @instances << fun
    end

    def instance
      @instances.last
    end

    def instances
      @instances.each_with_index do |fun, idx|
        fun.sequence = idx if idx > 0
      end
      @instances
    end
  end

  module CLang
    class CFunction
      attr_accessor :context
      attr_accessor :functions

      def initialize(context)
        @context = context
        @functions = {}
      end

      def <<(fun)
        template = functions[fun.name] || FunctionTemplate.new
        template << fun
        functions[fun.name] = template
      end

      def [](name)
        functions[name]
      end

      def declear_functions
        functions.values.each do |template|
          template.instances.each {|fun| declear_function fun unless fun.name == :main || fun.is_a?(Operator)}
        end
      end

      def define_functions
        functions.values.each { |template| template.instances.each {|fun| define_function fun unless fun.is_a? External} }
      end

      def declear_function(node)
        node.instances.values.each do |fun|
          if !fun.redefined
            if fun.instances
              fun.instances.values.each do |instance|
                instance.sequence = node.sequence
                declear_function_instance instance
              end
            else
              fun.sequence = node.sequence
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
              fun.instances.values.each do |instance|
                instance.sequence = node.sequence
                define_function_instance instance
              end
            else
              fun.sequence = node.sequence
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