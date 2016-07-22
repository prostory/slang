# This is a Simple Language sample
# Author: Xiao Peng
# Date: 2016-07-19

puts "Hello World"

class Integer
	operator ++():Integer
	operator +=(Integer):Integer
end

class Greeter

	# the constructor function
	# @params: name
	# @return
	def __init__(name)
		@name = name
	end
	
	def say_hello
		printf "Hello, %s\n", @name
	end
end

g = Greeter.new "SLang"
g.say_hello

10.times (n)-> 
	printf "Say hello %d times.\n", n 
end

class Point
	def __init__(x, y)
		@x = x
		@y = y
	end
	
	def x; @x end
	def y; @y end
	
	def +(p)
		Point.new(@x + p.x, @y + p.y)
	end
	
	def -(p)
		Point.new(@x - p.x, @y - p.y)
	end
	
	def dump
		printf "(%.2f, %.2f)\n", @x.to_f, @y.to_f
	end
end

p1 = Point.new(1.2, 2.3)
p2 = Point.new(2.2, 6.4)

p3 = p1 + p2
p4 = p1 - p2
p3.dump
p4.dump
(p3 + p4).dump

i = 1
if i > 0
	puts "i > 0"
else
	puts "i < 0"
end
i = 5
case i
of 1, 2, 3
	puts "i = 1 or 2 or 3"
of 4, 5, 6
	puts "i = 4 or 5 or 6"
else
	puts "i = other"
end

while i < 10
	puts "Hello"
	i = i + 1
end
printf "i = %d\n", i

i = 0
do
	puts "Hello"
	i = i + 1
while i < 10 end
i = 0
do puts "Hello"; i = i + 1 until i == 10 end unless i == 5

puts "Hello i = 10" if i == 10

printf "1 * (5 + 4) / (6 - 3) + 4 = %d\n", 1 * (5 + 4) / (6 - 3) + 4
i += 5 - 6 * 3
printf "i++*5 = %d\n", i++*5

begin i += 1; printf "i = %d\n", i end
