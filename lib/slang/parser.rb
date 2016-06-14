require_relative 'ast'

module SLang
  class Parser
    def self.parse(exp)
      Expressions.from Parser.new.parse_expression(exp)
    end

    def parse_expression(exp)
      case exp[0]
      when Array
        parse_children(exp)
      when Symbol
        parse_command(exp)
      end
    end

    def parse_command(exp)
      obj = case exp[0]
            when :do
              Do.new parse_expression(exp[1..-1])
            when :fun
              Function.new exp[1], parse_params(exp[2]), parse_expression(exp[3]), exp[4], @target
            when :lambda
              Lambda.new parse_params(exp[1]), parse_expression(exp[2]), exp[4], @target
            when :call
              if exp[1].is_a? Array
                func = parse_expression(exp[1])
                return Expressions.new([func, Call.new(func.name, parse_args(exp[3]), parse_obj(exp[2]))])
              end
              Call.new(exp[1], parse_args(exp[3]), parse_obj(exp[2]))
            when :if
              If.new(parse_expression(exp[1]), parse_expression(exp[2]), parse_expression(exp[3]))
            when :while
              While.new(parse_expression(exp[1]), parse_expression(exp[2]))
            when :ret
              Return.new(parse_args(exp[1..-1]))
            when :external
              return External.new(exp[1], exp[2], parse_params(exp[3]), exp[4], @target) if exp[2].is_a? Symbol
              return External.new(exp[1], exp[1], parse_params(exp[2]), exp[3], @target) if exp[2].is_a? Array
            when :class
              parse_class(exp[1..-1])
            when :module
              parse_module(exp[1..-1])
            when :include
              Include.new(exp[1..-1])
            when :operator
              return Operator.new(exp[1], exp[2], parse_params(exp[3]), exp[4], @target) if exp[2].is_a? Symbol
              return Operator.new(exp[1], exp[1], parse_params(exp[2]), exp[3], @target) if exp[2].is_a? Array
            when :set
              Assign.new(parse_var(exp[1]), parse_obj(exp[2]))
            when :list
              ArrayLiteral.new(parse_args(exp[1..-1]))
            when :cast
              Cast.new(parse_obj(exp[1]), parse_obj(exp[2]))
            when :static
              ClassFun.new(exp[1], parse_params(exp[2]), parse_expression(exp[3]), exp[4], @target)
            else
              Call.new exp[0], parse_args(exp[2]), parse_obj(exp[1])
            end
      obj.source_code = exp
      obj
    end

    def parse_children(children)
      children.map {|child| parse_expression(child)} if children
    end

    def parse_var(exp)
      case exp
      when Symbol
        if exp.to_s.match /^[A-Z]/
          Const.new(exp)
        elsif var = exp.to_s.match(/^@@([^@]+)/)
          ClassVar.new(var[1].to_sym, @target)
        elsif var = exp.to_s.match(/^@([^@]+)/)
          Member.new(var[1].to_sym)
        else
          Variable.new(exp)
        end
      end
    end

    def parse_params(params)
      return params.map do |exp|
        if exp.to_s.match /^[A-Z]/
          Parameter.new(nil, exp)
        else
          Parameter.new(exp, nil)
        end
      end if params.is_a? Array
      return params.map {|name, type| Parameter.new(name, type)} if params.is_a? Hash
    end

    def parse_args(args)
      return [] if args.nil?
      args.map do|arg|
        parse_obj arg
      end
    end

    def parse_obj(obj)
      case obj
      when Array
        parse_expression(obj)
      when String
        new_string(obj)
      when Fixnum, Float
        NumberLiteral.new(obj)
      when TrueClass, FalseClass
        BoolLiteral.new(obj)
      when Symbol
        parse_var(obj)
      end
    end

    def parse_class(exp)
      @target = class_def = ClassDef.new(exp[0], nil, exp[1])
      parse_class_body(exp[2..-1])
      @target = nil
      class_def
    end

    def parse_module(exp)
      @target = mod = Module.new(exp[0])
      parse_class_body(exp[1..-1])
      @target = nil
      mod
    end

    def parse_class_body(children)
      children.map {|child| @target << parse_expression(child)} if children
    end

    def new_string(str)
      Call.new(:new, [StringLiteral.new(str)], Const.new(:String))
    end
  end
end
