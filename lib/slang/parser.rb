require_relative 'ast'

module SLang
	class Parser
		def self.parse(exp)
			Expressions.from parse_expression(exp)
		end

		def self.parse_expression(exp)
			case exp[0]
			when Array
				parse_children(exp)
			when Symbol
				parse_command(exp)
			end
		end

		def self.parse_command(exp)
			case exp[0]
			when :do
				Do.new parse_expression(exp[1..-1])
			when :fun
				Function.new exp[1], parse_vars(exp[2]), parse_expression(exp[3]), exp[4]
			when :lambda
				Lambda.new parse_vars(exp[1]), parse_expression(exp[2]), exp[4]
			when :call
				if exp[1].is_a? Array
					func = parse_expression(exp[1])
					return Expressions.new([func, Call.new(func.name, parse_vars(exp[2]))])
				end
				Call.new(exp[1], parse_vars(exp[2]))
			when :if
				If.new(parse_expression(exp[1]), parse_expression(exp[2]), parse_expression(exp[3]))
			when :while
				While.new(parse_expression(exp[1]), parse_expression(exp[2]))
			when :ret
				Return.new(parse_args(exp[1..-1]))
			when :external
				External.new(exp[1], parse_params(exp[2]), exp[3])
			else
				Call.new exp[0], parse_args(exp[1..-1])
			end
		end

		def self.parse_children(children)
			children.map {|child| parse_expression(child)}
		end

		def self.parse_vars(vars)
			return vars.map {|var| Variable.new(var)} if vars.is_a? Array
			return vars.map {|name, type| Variable.new(name, type)} if vars.is_a? Hash
		end

		def self.parse_params(params)
			return params.map {|type| Paramter.new(nil, type)} if params.is_a? Array
			return params.map {|name, type| Paramter.new(name, type)} if params.is_a? Hash
		end

		def self.parse_args(args)
			args.map do|arg|
				case arg
				when Array
					parse_expression(arg)
				when String
					StringLiteral.new(arg)
				when Fixnum
					NumberLiteral.new(arg)
				when Symbol
					Argument.new(arg)
				end
			end
		end
	end
end