class Options
	def option(value)
		@value = value
		self
	end
	
	def value; @value end
	
	def dump
    puts value
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
puts B.a
B.a = 5.1
puts B.a

if B.a.class == String
  B.a = "Hello"
else
  B.a = "World"
end

puts B.a