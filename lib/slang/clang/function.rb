module SLang
  class Function
    attr_accessor :redefined
    attr_accessor :sequence
  end

  class FunctionTemplate
    def initialize
      @functions = []
    end

    def <<(fun)
      @functions << fun
    end

    def empty?
      @functions.empty?
    end

    def lookup(arg_size)
      result = nil
      @functions.each do |fun|
        result = fun if fun.params.size == arg_size || fun.has_var_list?
      end
      result
    end

    def functions
      @functions.each_with_index do |fun, idx|
        fun.sequence = idx if idx > 0
      end
      @functions
    end
  end

  module CLang
    class CFunction
      attr_accessor :context
      attr_accessor :templates

      def initialize(context)
        @context = context
        @templates = {}
      end

      def <<(fun)
        template = templates[fun.name] || FunctionTemplate.new
        template << fun
        templates[fun.name] = template
      end

      def [](name)
        templates[name]
      end

      def declear_functions
        templates.values.each do |template|
          template.functions.each {|fun| declear_function fun unless fun.name == :main || fun.is_a?(Operator)}
        end
      end

      def define_functions
        templates.values.each do |template|
          template.functions.each {|fun| define_function fun unless fun.is_a? External}
        end
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
        stream << "extern #{node.body.type.ref} #{node.mangled_name}("
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
        stream << "#{node.body.type.ref} #{node.mangled_name}("
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
            if node.is_a?(External) && param.var_list?
              stream << '...'
            else
              param.accept visitor
            end
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
