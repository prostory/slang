module SLang
	class ASTNode

	end

	class Expressions < ASTNode
		include Enumerable

		attr_accessor :children

		def self.from(obj)
			case obj
				when nil
					new
				when Array
					new obj
				when Expressions
					obj
				when Do
					new obj.children
				else
					new [obj]
			end
		end

		def initialize(expressions = [])
			@children = expressions
		end

		def each(&block)
			@children.each(&block)
		end

		def [](i)
			@children[i]
		end

		def last
			@children.last
		end

		def ==(other)
			other.class == self.class && other.children == children
		end
	end

	class Do < Expressions
	end

	class Literal < ASTNode
		attr_accessor :value

		def initialize(value)
			@value = value
		end

		def ==(other)
			other.class == self.class && other.value == value
		end
	end

	class Int < Literal
		def initialize(value)
			@value = value.to_i
		end

		def ==(other)
			other.class == self.class && other.value.to_i == value.to_i
		end
	end

	class String < Literal
	end

	class Variable < ASTNode
		attr_accessor :name

		def initialize(name)
			@name = name
		end

		def ==(other)
			other.class == self.class && other.name == name
		end
	end

	class Argument < Variable
	end

	class Call < ASTNode
		attr_accessor :name
		attr_accessor :args

		def initialize(name, args = [])
			@name = name
			@args = args
		end

		def ==(other)
			other.class == self.class && other.name == name && other.args == args
		end
	end

	class Def < ASTNode
		attr_accessor :name
		attr_accessor :params
		attr_accessor :body

		def initialize(name, params = [], body = [])
			@name = name
			@params = params
			@body = Expressions.from body
		end

		def ==(other)
			other.class == self.class && other.name == name && other.params == params &&
				other.body == body
		end
	end

	class Lambda < Def
		@@sequence = 0

		def initialize(params = [], body = [])
			name = :"lambda__#{@@sequence}"
			super name, params, body
			@@sequence += 1
		end

		def ==(other)
			other.class == self.class && other.params == params && other.body == body
		end
	end

	class If < ASTNode
		attr_accessor :cond
		attr_accessor :then
		attr_accessor :else

		def initialize(cond, a_then, a_else = nil)
			@cond = cond
			@then = Expressions.from a_then
			@else = Expressions.from a_else
		end

		def ==(other)
			other.class == self.class && other.cond == cond && other.then == self.then &&
				other.else == self.else
		end
	end

	class While < ASTNode
		attr_accessor :cond
		attr_accessor :body

		def initialize(cond, body)
			@cond = cond
			@body = Expressions.from body
		end

		def ==(other)
			other.class == self.class && other.cond == cond && other.body == self.body
		end
	end
end