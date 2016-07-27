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
	if n < 0
		-n
	else
		n.to_f
	end
end

printf "fib(6) = %d\n", fib(6)
foo

i = 0
printf "i = %d\n", i
i = i + 1.0
i = 1 + i
printf "i = %.2f\n", i
i = String.new("Hello ")
i = i << "World"
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

puts i.to_s
i = false
puts i.to_s
