class Pointer
end

class Object
  def as(type)
    cast(type, self)
  end
end

class Class
  def ==(other)
    self.as(Pointer) == other.as(Pointer)
  end
end

class Point
  def __init__(x, y)
    @x = x
    @y = y
  end
  
  def x; @x end
  def y; @y end
end

class Options
	def option(value)
		@type = value.class.as(Pointer)
		@value = value
		self
	end
	
	def type; @type end
	def value; @value end
	
	def dump
		case type
		of String
			puts value.as(String)
		of Float
			printf "%f\n", value.as(Float)
		end
	end
end

def foo(n)
	a = nil
	a = "Hello World"
	a = Options.new
	b = Object.new
	c = Object.new
	d = (b == c)
	if d then puts "true" else puts "false" end
	if n > 0
		a.option("hello")
	else
		a.option(1.5)
	end
end

class A
end

class B
	def A.a; @@a = 1; puts "a" end
	
	def B.a
		@@a
	end
	
	def self.a=(n)
		@@a = n
	end
end

a = foo 5
a.dump
a = foo -1
a.dump

def A.b
	puts "b"
end
A.a

A.b
printf "%d\n", B.a
B.a = 5.1
printf "%f\n", B.a

if B.a.class == String
  B.a = "Hello"
else
  B.a = "World"
end
puts B.a.as(String)
