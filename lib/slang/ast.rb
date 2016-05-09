module SLang
	class NumberLiteral
		attr_accessor :value

		def initialize(value)
			@value = value
		end

		def to_s
			value.to_s
		end
	end

	class StringLiteral
		attr_accessor :value

		def initialize(value)
			@value = value
		end

		def to_s
			"\"#{value}\""
		end
	end

	class Expression
		attr_accessor :command
		attr_accessor :params

		def initialize(expr)
			init(expr)
		end

		def init(expr)
			@command = expr[0].to_s
			@params = expr[1..-1]
		end

		def to_s
			"#{@command}(#{@params.join(', ').to_s});\n"
		end
	end

	class Block < Expression
		def to_s
			"\t{\n#{params.map{|p| "\t#{p}"}.join}\n\t}\n"
		end
	end

	class Argument
		attr_accessor :type
		attr_accessor :name

		def initialize(type, name)
			@type = type
			@name = name
		end

		def to_s
			"#{@type} #{@name}"
		end
	end

	class Function
		attr_accessor :name
		attr_accessor :args
		attr_accessor :body
		attr_accessor :return_type

		def initialize(name, args, body, return_type = :void)
			init(name, args, body, return_type)
		end

		def init(name, args, body, return_type)
			@name = name
			@args = args.map {|type, name| Argument.new(type, name) } || []
			@body = Context.expression(body)
			@return_type = return_type
		end

		def main?
			name == :main
		end

		def to_s
			"#{return_type} #{name}(#{args.empty? ? :void : args.join(', ')})\n{\n#{body}}\n"
		end
	end
end