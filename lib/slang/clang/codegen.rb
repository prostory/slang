module SLang
  class ASTNode
    def terminator
      ""
    end
  end

  class Call
    def terminator
      ";"
    end
  end

  class Variable
    def terminator
      ";"
    end
  end

  class Return
    def terminator
      ";"
    end
  end

  class Function
    def mangled_name
      self.class.mangled_name(owner, name) <<
        self.class.mangled_params(params.map(&:type), mangled)
    end

    def self.mangled_name(owner, name)
      if owner
        "#{owner.name}$$#{name}"
      else
        "#{name}"
      end
    end

    def self.mangled_params(param_types, mangled)
      if param_types.any? && mangled
        "$#{param_types.map(&:name).join '_'}"
      else
        ''
      end
    end
  end

  module CLang
    class CodeGenVisitor < Visitor
      attr_accessor :context
      attr_accessor :stream

      def initialize(context, stream = '')
        @indent = 0
        @context = context
        @stream = stream
      end

      def visit_number_literal(node)
        stream << node.value.to_s
      end

      def visit_string_literal(node)
        stream << '"'
        stream << node.value.to_s
        stream << '"'
      end

      def visit_class_def(node)
        false
      end

      def visit_expressions(node)
        node.children.each do |exp|
          unless exp.is_a? Function
            indent
            exp.accept self
            stream << exp.terminator
            stream << "\n"
          end
        end
        false
      end

      def visit_call(node)
        stream << node.target_fun.mangled_name.to_s

        stream << '('
        if node.obj
          node.obj.accept self
        end
        node.args.each_with_index do |arg, i|
          stream << ', ' if i > 0 || node.obj
          arg.accept self
        end
        stream << ')'
        false
      end

      def visit_argument(node)
        stream << "#{node.name}"
        false
      end

      def visit_variable(node)
        stream << "#{node.type} #{node.name}"
        false
      end

      def visit_paramter(node)
        stream << "#{node.type}"
        stream << " #{node.name}" if node.name
        false
      end

      def visit_function(node)
        false
      end

      def visit_lambda(node)
        false
      end

      def visit_if(node)
        stream << 'if ('
        node.cond.accept self
        stream << ")\n"
        indent
        stream << "{\n"
        with_indent {node.then.accept self}
        unless node.else.children.empty?
          indent
          stream << "\n"
          indent
          stream << "else\n"
          indent
          stream << "{\n"
          with_indent {node.else.accept self}
        end
        indent
        stream << '}'
        false
      end

      def visit_while(node)
        stream << 'while ('
        node.cond.accept self
        stream << ")\n"
        indent
        stream << "{\n"
        with_indent {node.body.accept self}
        indent
        stream << '}'
        false
      end

      def visit_return(node)
        stream << 'return '
        node.values[0].accept self
        false
      end

      def with_indent
        @indent += 1
        yield
        @indent -= 1
      end

      def indent
        stream << ('    ' * @indent)
      end

      def to_s
        stream.strip
      end
    end
  end
end