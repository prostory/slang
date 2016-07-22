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

    def to_args(obj)
      case obj
      when nil
        []
      when Array
        obj
      else
        [obj]
      end
    end

		def accept_children(visitor)

		end

		def replace(old, new)

		end
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
      else
        new [obj]
			end
		end

		def initialize(expressions = [])
			@children = expressions
			@children.each {|child| child.parent = self}
		end

		def each(&block)
			children.each(&block)
    end

    def unshift(child)
      child.parent = self
      children.unshift child
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

		def replace(old, new)
			children.each_with_index do |child, idx|
				if old == child
					children[idx] = new
				end
			end
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

    def to_s
      "(#{children.join ' '})"
    end

		def clone
			expresstions = self.class.new children.map(&:clone)
			expresstions.source_code = source_code
			expresstions
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

    def to_s
      value.to_s
    end

		def clone
			self.class.new value
		end
	end

	class NumberLiteral < Literal
	end

	class BoolLiteral < Literal
	end

	class NilLiteral < ASTNode
	end

	class StringLiteral < Literal
	end

	class ArrayLiteral < ASTNode
		attr_accessor :elements

		def initialize(elements = [])
			@elements = elements
			@elements.each {|element| element.parent = self}
		end

		def accept_children(visitor)
			elements.map { |element| element.accept(visitor) }
		end

		def replace(old, new)
			elements.each_with_index do |child, idx|
				if old == child
					elements[idx] = new
				end
			end
		end

		def ==(other)
			other.class == self.class && other.elements == elements
		end

		def clone
			array = self.class.new elements.map(&:clone)
			array.source_code = source_code
			array
		end
	end

	class Module < ASTNode
		attr_accessor :name
		attr_accessor :body

		def initialize(name, body = nil)
			@name = name.to_sym
			@body = Expressions.from body
			@body.parent = self
		end

		def <<(fun)
			body << fun
		end

		def accept_children(visitor)
			body.accept visitor
		end

		def replace(old, new)
			@body = new if @body == old
		end

		def ==(other)
			other.class == self.class && other.name == name && other.body == body
    end

    def to_s
      "(module #{name} #{body})"
    end

		def clone
			self.class.new name, body.clone
		end
	end

	class Include < ASTNode
		attr_accessor :modules

		def initialize(modules = [])
			@modules = modules.map(&:to_sym)
		end

		def ==(other)
			other.class == self.class && other.modules == modules
		end

		def clone
			self.class.new modules
		end
	end

	class ClassDef < Module
		attr_accessor :superclass

		def initialize(name, body = nil, superclass = nil)
			super name, body
			@superclass = superclass.to_sym if superclass
		end

		def ==(other)
			super && other.superclass == superclass
		end

		def to_s
			"(class #{name} #{superclass} #{body})"
		end

		def clone
			self.class.new name, body.clone, superclass
		end
	end

	class Variable < ASTNode
		attr_accessor :name
		attr_accessor :type

		def initialize(name, type = :Any)
			@name = name.to_sym if name
			@type = type || :Any
		end

		def ==(other)
			other.class == self.class && other.name == name && other.type == type
    end

    def to_s
      name.to_s
    end

		def clone
			self.class.new name, type
		end
	end

	class Parameter < Variable
	end

	class Member < Variable
	end

	class ClassVar < Variable
	end

	class Const < ASTNode
		attr_accessor :name

		def initialize(name)
			@name = name.to_sym
		end

		def ==(other)
			other.class == self.class && other.name == name
    end

    def to_s
      name.to_s
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
			@name = name.to_sym
			@args = to_args(args)
			@args.each {|arg| arg.parent = self}
			@obj = obj
		end

		def accept_children(visitor)
			args.map { |arg| arg.accept visitor }
		end

		def replace(old, new)
			args.each_with_index do |child, idx|
				if old == child
					args[idx] = new
				end
			end
		end

		def ==(other)
			other.class == self.class && other.name == name && other.args == args && other.obj == obj
    end

    def to_s
      "(#{name} #{obj} #{args.join ' '})"
    end

		def clone
			call = self.class.new name, args.map(&:clone), obj
			call.source_code = source_code
			call
		end
	end

	class Function < ASTNode
		attr_accessor :name
		attr_accessor :params
		attr_accessor :body
		attr_accessor :return_type
		attr_accessor :receiver
		attr_accessor :sequence

		def initialize(name, params = [], body = [], return_type = :Any, receiver = nil)
			@name = name.to_sym
			@params = to_args(params)
			@params.each {|param| param.parent = self}
			@body = Expressions.from body
			@body.parent = self
			@return_type = return_type || :Any
			@receiver = receiver
			@receiver.parent = self if receiver
			@sequence = 0
    end

    def receiver=(receiver)
      @receiver = receiver
      @receiver.parent = self if receiver
    end

		def accept_children(visitor)
			params.map { |param| param.accept visitor }
			body.accept visitor
		end

		def replace(old, new)
			case old
			when @body
				@body = new
			when @receiver
				@receiver = new
			end

			params.each_with_index do |child, idx|
				if old == child
					params[idx] = new
				end
			end
		end

		def ==(other)
			other.class == self.class && other.name == name && other.params == params &&
				other.body == body && other.return_type == return_type && other.receiver == receiver
    end

    def to_s
      "(def #{name} (#{params.join ' '}) #{body})"
    end

		def clone
			function = self.class.new name, params.map(&:clone), body.clone, return_type, receiver
			function.sequence = sequence
			function.source_code = source_code
			function
		end
	end

	class Lambda < Function
		def initialize(params = [], body = [], return_type = :Any, receiver = nil)
			super :lambda, params, body, return_type, receiver
    end

    def to_s
      "(def (#{params.join ' '}) #{body})"
    end

		def clone
			lambda = self.class.new params, body, return_type, receiver
			lambda.sequence = sequence
			lambda.source_code = source_code
			lambda
		end
	end

	class External < Function
		attr_accessor :output_name

		def initialize(name, output_name, params = [], return_type = :Void, receiver = nil)
			super name, params, [], return_type, receiver
			@output_name = output_name || name
		end

		def ==(other)
			super && other.output_name == output_name
		end

		def clone
			external = self.class.new name, output_name, params.map(&:clone), return_type, receiver
			external.body = body
			external
		end
	end

	class Operator < External
  end

  class ClassFun < Function
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

    def then=(a_then)
      @then = Expressions.from a_then
      @then.parent = self
    end

    def else=(a_else)
      @else = Expressions.from a_else
      @else.parent = self
    end

		def accept_children(visitor)
			@cond.accept visitor
			@then.accept visitor
			@else.accept visitor if @else
		end

		def replace(old, new)
			case old
			when @cond
				@cond = new
			when @then
				@then = new
			when @else
				@else = new
			end
		end

		def ==(other)
			other.class == self.class && other.cond == cond && other.then == self.then &&
				other.else == self.else
    end

    def to_s
      "(#{cond} #{@then} #{@else})"
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
			cond.accept visitor
			body.accept visitor
		end

		def replace(old, new)
			case old
			when @cond
				@cond = new
			when @body
				@body = new
			end
		end

		def ==(other)
			other.class == self.class && other.cond == cond && other.body == self.body
		end

		def clone
			self.class.new cond.clone, body.clone
		end
	end

	class DoWhile < While
	end

	class Return < ASTNode
		attr_accessor :values

		def initialize(values)
			@values = to_args(values)
			@values.each {|value| value.parent = self}
		end

		def accept_children(visitor)
			@values.each {|v| v.accept visitor}
		end

		def replace(old, new)
			values.each_with_index do |child, idx|
				if old == child
					values[idx] = new
				end
			end
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

		def replace(old, new)
			case old
			when target
				@target = new
			when value
				@value = new
			end
		end

		def ==(other)
			other.class == self.class && other.target == target && other.value == value
		end

		def clone
			assign = self.class.new target.clone, value.clone
			assign.source_code = source_code
			assign
		end
	end

	class Cast < Assign
	end

	class Typeof < ASTNode
		attr_accessor :value

		def initialize(value)
			@value = value
			@value.parent = self
		end

		def accept_children(visitor)
			value.accept visitor
		end

		def replace(old, new)
			value = new if old == value
		end

		def ==(other)
			other.class == self.class && other.value == value
		end

		def clone
			self.class.new value.clone
		end
	end

	class Sizeof < ASTNode
		attr_accessor :value

		def initialize(value)
			@value = value
			@value.parent = self
		end

		def accept_children(visitor)
			value.accept visitor
		end

		def replace(old, new)
			value = new if old == value
		end

		def ==(other)
			other.class == self.class && other.value == value
		end

		def clone
			self.class.new value.clone
		end
	end

	class ArrayNew < ASTNode
		attr_accessor :size

		def initialize(size)
			@size = size
			@size.parent = self
		end

		def replace(old, new)
			size = new if old == size
		end

		def ==(other)
			other.class == self.class && other.size == size
		end

		def accept_children(visitor)
			size.accept visitor
		end

		def clone
			self.class.new size.clone
		end
	end

	class ArraySet < ASTNode
		attr_accessor :target
		attr_accessor :index
		attr_accessor :value

		def initialize(target, index, value)
			@target = target
			@target.parent = self
			@index = index
			@index.parent = self
			@value = value
			@value.parent = self
		end

		def accept_children(visitor)
			target.accept visitor
			index.accept visitor
			value.accept visitor
		end

		def replace(old, new)
			case old
			when target
				target = new
			when index
				index = new
			when value
				value = new
			end
		end

		def ==(other)
			other.class == self.class && other.target == target && other.index == index &&
				other.value == value
		end

		def clone
			node = self.class.new target.clone, index.clone, value.clone
			node.source_code = source_code
			node
		end
	end

	class ArrayGet < ASTNode
		attr_accessor :target
		attr_accessor :index

		def initialize(target, index)
			@target = target
			@target.parent = self
			@index = index
			@index.parent = self
		end

		def accept_children(visitor)
			target.accept visitor
			index.accept visitor
		end

		def replace(old, new)
			case old
			when target
				target = new
			when index
				index = new
			end
		end

		def ==(other)
			other.class == self.class && other.target == target && other.index == index
		end

		def clone
			self.class.new target.clone, index.clone
		end
	end
end
