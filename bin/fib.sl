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
	elif n == 0
		"result is 0"
	else
		n + 1.25
	end
	result
end

printf "fib(6) = %d\n", fib(6)
foo
bar 10

i = 0
printf "i = %d\n", i
i = i + 1.0
i = 1 + i
printf "i = %.2f\n", i
i = String.new("Hello ")
i << "World"
puts i
i = true

class Bool
	def to_s
		if self
			"true"
		else
			"false"
		end
	end
end

class Options
	def string
		cast(String, self)
	end
	
	def int
		cast(Integer, self)
	end
	
	def float
		cast(Float, self)
	end
end

puts i.to_s
i = false
puts i.to_s
printf "bar(0) = '%s'\n", bar(0).string
printf "bar(-1) = %d\n", bar(-1).int
printf "bar(10) = %.2f\n", bar(10).float

class Rect
	def __init__(x, y, w, h)
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
		printf "(%d, %d, %d, %d)\n", x, y, w, h
	end
end

r = Rect.new(10, 10, 20, 20)
r.dump
(r/2).dump
