class Module
	def simple_name
		name.gsub /^.*::/, ''
	end
end

class String
	def underscore
		self.to_s.gsub(/::/, '/').
			gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
			gsub(/([a-z\d])([A-Z])/, '\1_\2').
			tr('-', '_').
			downcase
	end
end

module SLang
	class Visitor
	end

	class ASTNode
		def self.inherited(klass)
			name = klass.simple_name.underscore
			klass.class_eval %Q(
	        def accept(visitor)
	          if visitor.visit_#{name} self
	            accept_children visitor
	          end
	          visitor.end_visit_#{name} self
	        end
	      )
			Visitor.class_eval %Q(
	        def visit_#{name}(node)
	          true
	        end

	        def end_visit_#{name}(node)
	        end
	      )
		end

		def accept_children(visitor) end
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
			when Expressions, Do
				new obj.children
			else new [obj]
			end
		end

		def initialize(expressions = [])
			@children = expressions
		end

		def each(&block) children.each(&block)
		end

		def [](i) children[i]
		end

		def <<(exp) children << exp
		end

		def last
			children.last
		end

		def empty?
			children.empty?
		end

		def accept_children(visitor)
			children.map { |child| child.accept(visitor) }
		end

		def ==(other)
			other.class == self.class && other.children == children
		end

		def clone
			self.class.new children.map(&:clone)
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

		def clone
			self.class.new value
		end
	end

	class NumberLiteral < Literal
		def initialize(value)
			@value = value.to_i
		end
	end

	class StringLiteral < Literal
		def initialize(value) @value = value.to_s
		end
	end

	class Variable < ASTNode
		attr_accessor :name

		def initialize(name)
			@name = name
		end

		def ==(other)
			other.class == self.class && other.name == name
		end

		def clone
			self.class.new name
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

		def accept_children(visitor)
			args.map { |arg| arg.accept visitor }
		end

		def ==(other)
			other.class == self.class && other.name == name && other.args == args
		end

		def clone
			self.class.new name, args.map(&:clone)
		end
	end

	class Function < ASTNode
		attr_accessor :name
		attr_accessor :params
		attr_accessor :body

		def initialize(name, params = [], body = [])
			@name = name
			@params = params
			@body = Expressions.from body
		end

		def accept_children(visitor)
			params.map { |param| param.accept visitor }
			body.accept visitor
		end

		def ==(other)
			other.class == self.class && other.name == name && other.params == params &&
				other.body == body
		end

		def clone
			self.class.new name, params.map(&:clone), body.clone
		end
	end

	class Lambda < Function
		@@sequence = 0

		def initialize(params = [], body = [], is_clone = false)
			name = :"lambda__#{@@sequence}"
			super name, params, body
			@@sequence += 1 unless is_clone
		end

		def ==(other)
			other.class == self.class && other.params == params && other.body == body
		end

		def clone
			lambda = self.class.new params, body, true
			lambda.name = name
			lambda
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

		def accept_children(visitor)
			@cond.accept visitor @then.accept visitor @else.accept visitor if @else
		end

		def ==(other)
			other.class == self.class && other.cond == cond && other.then == self.then &&
				other.else == self.else
		end

		def clone
			self.class.new cond.clone, @then.clone, @else.clone
		end
	end

	class While < ASTNode
		attr_accessor :cond
		attr_accessor :body

		def initialize(cond, body)
			@cond = cond
			@body = Expressions.from body
		end

		def accept_children(visitor)
			cond.accept visitor body.accept visitor
		end

		def ==(other)
			other.class == self.class && other.cond == cond && other.body == self.body
		end

		def clone
			self.class.new cond.clone, body.clone
		end
	end

	class Return < ASTNode
		attr_accessor :values

		def initialize(values)
			@values = values
		end

		def accept_children(visitor)
			@values.each {|v| v.accept visitor}
		end

		def ==(other)
			other.class == self.class && other.values == values
		end

		def clone
			self.class.new values.map(&:clone)
		end
	end
end
