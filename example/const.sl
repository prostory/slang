B = 2
class A
	B = 3
	printf "%d\n", B
	printf "%d\n", ::B
	class C
		D = 4
	end
	E = 0x5643
end

class F < A
end

printf "%d\n", A::C::D
printf "0x%x\n", A::E
printf "F::B = %d\n", F::B

class F
	B = 5
end

printf "F::B = %d\n", F::B