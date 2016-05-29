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
		attr_accessor :parent
		attr_accessor :source_code

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
			@children.each {|child| child.parent = self}
		end

		def each(&block)
			children.each(&block)
		end

		def [](i)
			children[i]
		end

		def <<(child)
			child.parent = self
			children << child
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
	end

	class BoolLiteral < Literal
	end

	class StringLiteral < Literal
	end

	class ArrayLiteral < Expressions
	end

	class ClassDef < ASTNode
		attr_accessor :name
		attr_accessor :body
		attr_accessor :superclass

		def initialize(name, superclass = nil, body = nil)
			@name = name
			@body = Expressions.from body
			@body.parent = self
			@superclass = superclass
		end

		def <<(fun)
			body << fun
		end

		def accept_children(visitor)
			body.accept visitor
		end

		def ==(other)
			other.class == self.class && other.name == name && other.body == body && other.superclass == superclass
		end

		def clone
			self.class.new name, body.clone, superclass
		end
	end

	class Variable < ASTNode
		attr_accessor :name
		attr_accessor :type

		def initialize(name, type = :unknown)
			@name = name
			@type = type
		end

		def ==(other)
			other.class == self.class && other.name == name && other.type == type
		end

		def clone
			self.class.new name, type
		end
	end

	class Parameter < Variable
    def initialize(type, name = nil)
      super name, type
    end

    def clone
      self.class.new type, name
    end
	end

	class Const < ASTNode
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

	class InstanceVar < ASTNode
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

	class Call < ASTNode
		attr_accessor :obj
		attr_accessor :name
		attr_accessor :args

		def initialize(name, args = [], obj = nil)
			@name = name
			@args = args
			@args.each {|arg| arg.parent = self}
			@obj = obj
		end

		def accept_children(visitor)
			args.map { |arg| arg.accept visitor }
		end

		def ==(other)
			other.class == self.class && other.name == name && other.args == args
		end

		def clone
			self.class.new name, args.map(&:clone), obj
		end
	end

	class Function < ASTNode
		attr_accessor :name
		attr_accessor :params
		attr_accessor :body
		attr_accessor :return_type
		attr_accessor :receiver

		def initialize(name, params = [], body = [], return_type = :unknown, receiver = nil)
			@name = name
			@params = params
			@params.each {|param| param.parent = self}
			@body = Expressions.from body
			@body.parent = self
			@return_type = return_type || :unknown
			@receiver = receiver
			@receiver.parent = self if receiver
		end

		def accept_children(visitor)
			params.map { |param| param.accept visitor }
			body.accept visitor
		end

		def ==(other)
			other.class == self.class && other.name == name && other.params == params &&
				other.body == body && other.return_type == return_type && other.receiver == receiver
		end

		def clone
			self.class.new name, params.map(&:clone), body.clone, return_type, receiver
		end
	end

	class Lambda < Function
		@@sequence = 0

		def initialize(params = [], body = [], return_type = :unknown, is_clone = false)
			name = :"lambda__#{@@sequence}"
			super name, params, body, return_type
			@@sequence += 1 unless is_clone
		end

		def ==(other)
			other.class == self.class && other.params == params && other.body == body &&
				other.return_type == return_type
		end

		def clone
			lambda = self.class.new params, body, return_type, true
			lambda.name = name
			lambda
		end
	end

	class External < Function
		def initialize(name, params = [], return_type = :unknown, receiver = nil)
			super name, params, [], return_type, receiver
		end

		def clone
			external = self.class.new name, params.map(&:clone), return_type, receiver
			external.body = body
			external
		end
	end

	class Operator < External
	end

	class If < ASTNode
		attr_accessor :cond
		attr_accessor :then
		attr_accessor :else

		def initialize(cond, a_then, a_else = nil)
			@cond = cond
			@cond.parent = self
			@then = Expressions.from a_then
			@then.parent = self
			@else = Expressions.from a_else
			@else.parent = self
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
			@cond.parent = self
			@body = Expressions.from body
			@body.parent = self
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
			@values.each {|value| value.parent = self}
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

	class Assign < ASTNode
		attr_accessor :target
		attr_accessor :value

		def initialize(target, value)
			@target = target
			@target.parent = self
			@value = value
			@value.parent = self
		end

		def accept_children(visitor)
			target.accept visitor
			value.accept visitor
		end

		def ==(other)
			other.class == self.class && other.target == target && other.value == value
		end

		def clone
			self.class.new target.clone, value.clone
		end
	end
end
