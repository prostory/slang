B = 2
class A
	B = 3
	printf "%d\n", B
	class C
		D = 4
	end
end

printf "%d\n", A::C::D
