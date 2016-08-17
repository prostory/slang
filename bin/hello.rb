# This is a Simple Language sample
# Author: Xiao Peng
# Date: 2016-07-19

puts "Hello World"

class Greeter

	# the constructor function
	# @params: name
	# @return
	def initialize(name)
		@name = name
	end
	
	def say_hello
		puts "Hello, #{@name}"
	end
end

g = Greeter.new "SLang"
g.say_hello

10.times do |n|
	puts "Say hello #{n} times."
end

class Point
	def initialize(x, y)
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
		puts "(#{@x}, #{@y})" 
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
when 1, 2, 3
	puts "i = 1 or 2 or 3"
when 4, 5, 6
	puts "i = 4 or 5 or 6"
else
	puts "i = other"
end

while i < 10
	puts "Hello"
	i = i + 1
end
puts "i = #{i}"

i = 0
begin
	puts "Hello"
	i = i + 1
end while i < 10
i = 5
begin puts "Hello"; i = i + 1 end until i == 10 unless i == 5

puts "Hello i = 10" if i == 10

puts "3 * (5 - 4) / ((6 - 3) + 4) = #{3 * (5 - 4) / ((6 - 3) + 4)}"
i += 5 - 6 * 3
puts "i = #{i}"
puts "i++*5 = #{i*5}"
i+=1

begin i += 1; puts "i = #{i}" end
