module SLang
	class ASTNode
		def to_s
			raise "Invalid call"
		end

		def end
			to_s
		end
	end

	class NumberLiteral < ASTNode
		attr_accessor :value

		def initialize(value)
			@value = value
		end

		def to_s
			value.to_s
		end
	end

	class StringLiteral < ASTNode
		attr_accessor :value

		def initialize(value)
			@value = value
		end

		def to_s
			"\"#{value}\""
		end
	end

	class Do < ASTNode
		attr_accessor :body

		def initialize(body = [])
			@body = body
		end

		def to_s
			"\t{\n#{body.map{|expr| "\t\t#{expr.end}"}.join}\n\t}\n" if !body.empty?
		end
	end

	class Call < ASTNode
		attr_accessor :name
		attr_accessor :params

		def initialize(name, params = [])
			@name = name
			@params = params
		end

		def to_s
			"#{name}(#{params.join(', ')})"
		end

		def end
			"#{to_s};\n"
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

	class Function < ASTNode
		attr_accessor :name
		attr_accessor :args
		attr_accessor :body
		attr_accessor :return_type

		def initialize(name, args, body, return_type = :void)
			@name = name
			@args = args.map {|type, name| Argument.new(type, name) } || []
			@body = body
			@return_type = return_type
		end

		def main?
			name == :main
		end

		def to_s
			"#{return_type} #{name}(#{args.empty? ? :void : args.join(', ')})\n{\n#{body.end}}\n"
		end
	end

	class If < ASTNode
		attr_accessor :cond
		attr_accessor :then
		attr_accessor :else

		def initialize(cond, a_then, a_else)
			init(cond, a_then, a_else)
		end

		def init(cond, a_then, a_else)
			@cond = cond
			@then = a_then
			@else = a_else
		end

		def to_s
			"if (#{@cond}) {\n#{@then};\n}" << (@else ? " else {\n#{@else};}\n" : "\n")
		end
	end

	class Lambda < Function
	end
end