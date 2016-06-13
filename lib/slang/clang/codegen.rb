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
      name = self.class.mangled_name(owner, simple_name)
      name << "#{sequence}" if sequence > 0
      name << self.class.mangled_params(param_types, mangled, return_type)
    end

    def self.mangled_name(owner, name)
      if owner
        "#{owner}_#{name}"
      else
        "#{name}"
      end
    end

    def self.mangled_params(param_types, mangled, return_type = nil)
      if (param_types.any? && mangled) || return_type
        s = "_#{param_types.join '_'}"
        s << "_#{return_type}" if return_type
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
        stream << node.value ? 'True' : 'False'
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

        if node.obj
          if node.name == :type
            stream << '"'
            stream << "#{node.obj.type}"
            stream << '"'
            return false
          end

          if node.obj.type.is_a?(ClassType)
            case node.name
            when :sizeof
              stream << "sizeof(#{node.obj.type.object_type})"
              return false
            end
          end
        end

        stream << node.target_fun.mangled_name.to_s

        stream << '('
        node.obj.accept self if node.obj
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
            stream << "#{Type.union_type} #{node.name};\n"
            indent
          end
          stream << "#{node.name}.#{Type.union_type.member(node.type)}"
        else
          stream << "#{node.type.base_type} " unless node.defined
          stream << "#{node.name}"
        end
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
        stream << "(#{node.type.reference})"
        node.value.accept self
      end

      def define_types
        Type.types.each_value do |type|
          stream << "#{type.define}"
          stream << "#{type.class_type.define}"
        end

        Type.types.each_value do |type|
          declare_functions type.functions
          declare_functions type.class_type.functions
        end
      end

      def define_type_functions
        Type.types.each_value do |type|
          define_functions type.functions
          define_functions type.class_type.functions
        end
      end

      def declare_functions(functions)
        functions.each do |pt|
          pt.instances.each {|fun| declare_function fun unless fun.name == :main || fun.is_a?(Operator)}
        end
      end

      def define_functions(functions)
        functions.each do |pt|
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
          node.body.accept self
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
              param.accept self
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
