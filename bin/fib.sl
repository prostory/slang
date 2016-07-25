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

printf "fib(6) = %d\n", fib(6)
foo
