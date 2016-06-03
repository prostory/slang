require_relative 'ast'

module SLang
	class Parser
		def self.parse(exp)
			Expressions.from parse_expression(exp)
		end

		def self.parse_expression(exp, target = nil)
			case exp[0]
			when Array
				parse_children(exp, target)
			when Symbol
				parse_command(exp, target)
			end
		end

		def self.parse_command(exp, target = nil)
			obj = case exp[0]
			when :do
				Do.new parse_expression(exp[1..-1])
			when :fun
				Function.new exp[1], parse_vars(exp[2]), parse_expression(exp[3]), exp[4], target
			when :lambda
				Lambda.new parse_vars(exp[1]), parse_expression(exp[2]), exp[4], target
			when :call
				if exp[1].is_a? Array
					func = parse_expression(exp[1])
					return Expressions.new([func, Call.new(func.name, parse_args(exp[3], target), parse_obj(exp[2], target))])
				end
				Call.new(exp[1], parse_args(exp[3], target), parse_obj(exp[2], target))
			when :if
				If.new(parse_expression(exp[1]), parse_expression(exp[2]), parse_expression(exp[3]))
			when :while
				While.new(parse_expression(exp[1]), parse_expression(exp[2]))
			when :ret
				Return.new(parse_args(exp[1..-1]))
			when :external
				return External.new(exp[1], exp[2], parse_params(exp[3]), exp[4], target) if exp[2].is_a? Symbol
				return External.new(exp[1], exp[1], parse_params(exp[2]), exp[3], target) if exp[2].is_a? Array
			when :class
				class_def = ClassDef.new(exp[1], exp[2])
				parse_methods(class_def, exp[3..-1])
				class_def
			when :operator
				return Operator.new(exp[1], exp[2], parse_params(exp[3]), exp[4], target) if exp[2].is_a? Symbol
				return Operator.new(exp[1], exp[1], parse_params(exp[2]), exp[3], target) if exp[2].is_a? Array
			when :set
				Assign.new(parse_var(exp[1], target), parse_obj(exp[2], target))
			when :list
				ArrayLiteral.new(parse_args(exp[1..-1], target))
			when :cast
				Cast.new(exp[1], parse_obj(exp[2], target))
			else
				Call.new exp[0], parse_args(exp[2], target), parse_obj(exp[1], target)
			end
			obj.source_code = exp
			obj
		end

		def self.parse_children(children, target = nil)
			children.map {|child| parse_expression(child, target)}
		end

		def self.parse_vars(vars)
			return vars.map {|var| Variable.new(var)} if vars.is_a? Array
			return vars.map {|name, type| Variable.new(name, type)} if vars.is_a? Hash
		end

		def self.parse_var(exp, target)
			case exp
			when Symbol
				if exp.to_s.match /^[A-Z]/
          Const.new(exp)
				elsif var = exp.to_s.match(/^@@([^@]+)/)
					ClassVar.new(var[1].to_sym, target)
				elsif var = exp.to_s.match(/^@([^@]+)/)
          Member.new(var[1].to_sym)
				else
					Variable.new(exp)
				end
			end
		end

		def self.parse_params(params)
			return params.map {|type| Parameter.new(type)} if params.is_a? Array
			return params.map {|name, type| Parameter.new(type, name)} if params.is_a? Hash
		end

		def self.parse_args(args, target = nil)
			return [] if args.nil?
			args.map do|arg|
				parse_obj arg, target
			end
		end

		def self.parse_obj(obj, target = nil)
			case obj
			when Array
				parse_expression(obj)
			when String
				StringLiteral.new(obj)
			when Fixnum, Float
				NumberLiteral.new(obj)
			when TrueClass, FalseClass
				BoolLiteral.new(obj)
			when Symbol
				parse_var(obj, target)
			end
		end

		def self.parse_methods(target, exps)
			exps.each { |exp| target << parse_expression(exp, target) } if exps
		end
	end
end