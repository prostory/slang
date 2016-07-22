module SLang
  class ASTNode
    def has_code?
      true
    end

    def has_terminator?
      true
    end
  end

  class Module
    def has_code?
      false
    end
  end

  class Include
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
      # if owner && params.first && params.first.type == owner
      #   param_types = params[1..-1].map(&:type)
      # else
      #   param_types = params.map(&:type)
      # end
      # return_type = body.type if mangled_return_type
      # name = self.class.mangled_name(owner, simple_name)
      # name << "#{sequence}" if sequence > 0
      # name << self.class.mangled_params(param_types, mangled, return_type)
      if name == :main
        name.to_s
      else
        "#{simple_name}#{id}"
      end

    end
    #
    # def self.mangled_name(owner, name)
    #   if owner
    #     "#{owner}_#{name}"
    #   else
    #     "#{name}"
    #   end
    # end
    #
    # def self.mangled_params(param_types, mangled, return_type = nil)
    #   if (param_types.any? && mangled) || return_type
    #     s = "_#{param_types.join '_'}"
    #     s << "_#{return_type}" if return_type
    #     s
    #   else
    #     ''
    #   end
    # end
  end

  class External
    def mangled_name
      output_name
    end
  end

  class Lambda
    def mangled_name
      "#{name}#{sequence}"
    end
  end

  class If
    def has_terminator?
      false
    end
  end

  class While
    def has_terminator?
      false
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
        stream << (node.value ? 'True' : 'False')
      end

      def visit_string_literal(node)
        stream << node.value.to_s
      end

      def visit_array_literal(node)
        false
      end

      def visit_class_def(node)
        true
      end

      def visit_expressions(node)
        node.children.each do |exp|
          next if exp.type.is_a? LambdaType
          indent if exp.has_code?
          exp.accept self
          if exp.has_code?
            stream << ';' if exp.has_terminator?
            stream << "\n"
          end
        end
        false
      end

      def visit_call(node)
        if node.target_fun.is_a? Operator
          op = node.target_fun.mangled_name.to_s

          if op == '!'
            stream << op
          end

          stream << '('
          if node.obj
            node.obj.accept self
          end
          if op == '++'
            stream << op
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
        node.obj.accept self if node.obj
        node.args.each_with_index do |arg, i|
          unless arg.type.is_a?(LambdaType)
            stream << ', ' if i > 0 || node.obj
            arg.accept self
          end
        end
        stream << ')'
        false
      end

      def visit_variable(node)
        unless node.defined
          stream << "#{node.type.define_variable(node.name)};\n"
          indent
        end

        stream << "#{node.name}"
        stream << ".#{Type.union_type.member(node.type)}" if node.optional
        false
      end

      def visit_parameter(node)
        if node.var_list?
          stream << "#{node.type.reference}"
          return false
        end

        stream << "#{node.type.reference}"
        stream << " #{node.name}" if node.name
        false
      end

      def visit_const(node)
        stream << "&#{Type.types[node.name].class_type.instance_name}"
        false
      end

      def visit_member(node)
        stream << "self->#{node.name}"
        stream << ".#{Type.union_type.member(node.type)}" if node.optional
        false
      end

      def visit_class_var(node)
        visit_member(node)
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
          stream << "}\n"
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
        if node.value.type.is_a? UnionType
          node.value.accept self
          stream << ".#{Type.union_type.member(node.type)}"
          return
        end
        stream << "(#{node.type.reference})"
        node.value.accept self
      end

      def visit_typeof(node)
        stream << '"'
        stream << "#{node.value.type.template}"
        stream << '"'
        false
      end

      def visit_sizeof(node)
        stream << "sizeof(#{node.value.type})"
        false
      end

      def visit_array_new(node)
        stream << "calloc(sizeof(#{node.type.elements_type.base_type}), "
        node.size.accept self
        stream << ')'
        false
      end

      def visit_array_set(node)
        elements_type = node.target.type.elements_type
        stream << "((#{node.target.type.reference})"
        node.target.accept self
        stream << ')['
        node.index.accept self
        stream << ']'
        stream << ".#{elements_type.member(node.value.type)}" if elements_type.is_a? UnionType
        stream << ' = '
        node.value.accept self
        stream << ''
        false
      end

      def visit_array_get(node)
        stream << "((#{node.target.type.reference})"
        node.target.accept self
        stream << ')['
        node.index.accept self
        stream << ']'
        false
      end

      def define_types
        Type.types.each_value do |type|
          stream << "#{type.define}"
          stream << "#{type.class_type.define}"
        end
      end

      def declare_functions
        FunctionInstance.combine_same_instances
        FunctionInstance.instances.each {|fun| declare_function fun unless fun.name == :main || fun.is_a?(Operator)}
      end

      def define_functions
        FunctionInstance.instances.each {|fun| define_function fun unless fun.is_a?(External)}
      end

      def declare_function(node)
        stream << "extern #{node.body.type.reference} #{node.mangled_name}("
        define_parameters(node)
        stream << ");\n"
      end

      def define_function(node)
        stream << "#{node.body.type.reference} #{node.mangled_name}("
        define_parameters(node)
        stream << ")\n{\n"
        with_indent do
          node.body.accept self
        end
        indent
        stream << "}\n"
      end

      def define_parameters(node)
        if node.params.length > 0
          node.params.each_with_index do |param, i|
            unless param.type.is_a?(LambdaType)
              stream << ', ' if i > 0
              if node.is_a?(External) && param.var_list?
                stream << '...'
              else
                param.accept self
              end
            end
          end
        else
          stream << Type.void.to_s
        end
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
