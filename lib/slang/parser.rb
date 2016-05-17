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
				when :do
					Do.new parse_expression(exp[1..-1])
				when :def
					Def.new exp[1], parse_params(exp[2]), parse_expression(exp[3])
				when :lambda
					Lambda.new parse_params(exp[1]), parse_expression(exp[2])
				when :call
					if exp[1].is_a? Array
						func = parse_expression(exp[1])
						return Expressions.new([func, Call.new(func.name, parse_params(exp[2]))])
					end
					Call.new(exp[1], parse_params(expr[2]))
				when :if
					If.new(parse_expression(exp[1]), parse_expression(exp[2]), parse_expression(exp[3]))
				when :while
					While.new(parse_expression(exp[1]), parse_expression(exp[2]))
				else
					Call.new exp[0], parse_args(exp[1..-1])
			end
		end

		def self.parse_children(children)
			children.map {|child| parse_expression(child)}
		end

		def self.parse_params(params)
			params.map {|param| Variable.new(param)}
		end

		def self.parse_args(args)
			args.map do|arg|
				case arg
					when Array
						parse_expression(arg)
					when ::String
						String.new(arg)
					when Fixnum
						Int.new(arg)
					when Symbol
						Argument.new(arg)
				end
			end
		end


	end
end