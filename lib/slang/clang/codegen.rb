module SLang
  class ASTNode
    def has_code?
      true
    end
  end

  class ClassDef
    def has_code?
      false
    end
  end

  class Function
    def has_code?
      false
    end

    def simple_name
      return @simple_name if @simple_name
      @simple_name = CLang::Specific.convert(name)
    end

    def mangled_name
      if owner && params.first && params.first.type == owner
        param_types = params[1..-1].map(&:type)
      else
        param_types = params.map(&:type)
      end
      return_type = body.type if mangled_return_type
      self.class.mangled_name(owner, simple_name, sequence) <<
        self.class.mangled_params(param_types, mangled, return_type)
    end

    def self.mangled_name(owner, name, sequence)
      if owner
        "#{owner}$$#{name}#{sequence}"
      else
        "#{name}#{sequence}"
      end
    end

    def self.mangled_params(param_types, mangled, return_type = nil)
      if (param_types.any? && mangled) || return_type
        s = "$#{param_types.join '_'}"
        s << "$#{return_type}" if return_type
        s
      else
        ''
      end
    end
  end

  class External
    def mangled_name
      output_name
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
        true
      end

      def visit_expressions(node)
        node.children.each do |exp|
            indent if exp.has_code?
            exp.accept self
            stream << ";\n" if exp.has_code?
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

        if node.obj.is_a?(Const) && node.name == :new
          stream << "calloc(sizeof(#{node.type.name}), 1)"
          return false
        end

        stream << node.target_fun.mangled_name.to_s

        stream << '('
        unless node.obj.is_a? Const
          node.obj.accept self
        end
        node.args.each_with_index do |arg, i|
          stream << ', ' if i > 0 || node.obj
          arg.accept self
        end
        stream << ')'
        false
      end

      def visit_variable(node)
        if node.optional
          unless node.defined
            stream << "#{context.union_type} #{node.name};\n"
            indent
          end
          stream << "#{node.name}.#{context.union_type.members[node.type]}"
        else
          stream << "#{node.type.base_type} " unless node.defined
          stream << "#{node.name}"
        end
        false
      end

      def visit_parameter(node)
        stream << "#{node.type.ref}"
        stream << " #{node.name}" if node.name
        false
      end

      def visit_const(node)
        stream << node.name.to_s
        false
      end

      def visit_member(node)
        stream << "self->#{node.name}"
        stream << ".#{context.union_type.members[node.type]}" if node.optional
        false
      end

      def visit_class_var(node)
        stream << "#{context.types[node.target.name].class_type}.#{node.name}"
        stream << ".#{context.union_type.members[node.type]}" if node.optional
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

      def visit_class_fun(node)
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

      def visit_cast(node)
        stream << "(#{node.type})"
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