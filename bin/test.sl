class Options
	def option(value)
		@type = value.class.type_id
		@value = value
		self
	end
	
	def type; @type end
	def value; @value end
	
	def string; cast(String, @value) end
	def float; cast(Float, @value) end
	
	def dump
		case type
		of String.type_id
			puts string
		of Float.type_id
			printf "%f\n", float
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
