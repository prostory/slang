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

  class Assign
    def terminator
      ";"
    end
  end

  class Function
    def simple_name
      return @simple_name if @simple_name
      @simple_name = CLang::Specific.convert(name)
    end

    def mangled_name
      self.class.mangled_name(owner, simple_name) <<
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

  class External
    def mangled_name
      name
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

      def visit_bool_literal(node)
        stream << context.bool.members[node.value ? 1 : 0].to_s
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
          unless exp.is_a?(Function) || exp.is_a?(ClassDef)
            indent
            exp.accept self
            stream << exp.terminator
            stream << "\n"
          end
        end
        false
      end

      def visit_call(node)
        if node.target_fun.is_a? Operator
          op = node.target_fun.mangled_name.to_s
          stream << '('
          if node.obj
            node.obj.accept self
          end
          node.args.each_with_index do |arg, i|
            stream << " #{op} " if i > 0 || node.obj
            arg.accept self
          end
          stream << ')'
          return false
        end

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
        stream << "#{node.type} " if !node.defined
        stream << "#{node.name}"
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

      def visit_external(node)
        false
      end

      def visit_operator(node)
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

      def visit_assign(node)
        node.target.accept self
        stream << ' = '
        node.value.accept self
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