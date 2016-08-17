def fib(n)
	if n < 2
		n
	else
		fib(n-2) + fib(n-1)
	end
end

def foo
	i = 0
	while i < 10 do i = i + 1 end 
end

def bar(n)
	result = if n < 0
		-n
	elsif n == 0
		"result is 0"
	else
		n + 1.25
	end
	result
end

puts "fib(6) = #{fib(6)}"
puts "fib(6.5) = #{fib(6.5)}"
foo
bar 10

i = 0
puts "i = #{i}"
i = i + 1.0
i = 1 + i
puts "i = #{i}"
i = String.new("Hello ")
i << "World"
puts i
i = true

puts i.to_s
i = false
puts i.to_s
puts "bar(0) = '#{bar(0)}'"
puts "bar(-1) = #{bar(-1)}"
puts "bar(10) = #{bar(10)}"

class Rect
	def initialize(x, y, w, h)
		@x = x
		@y = y
		@w = w
		@h = h
	end
	
	def x; @x end
	def y; @y end
	def w; @w end
	def h; @h end
	
	def /(n)
		Rect.new(x/n, y/n, w/n, h/n)
	end
	
	def dump
		puts "(#{x}, #{y}, #{w}, #{h})"
	end
end

r = Rect.new(10, 10, 20, 20)
r.dump
(r/2).dump
