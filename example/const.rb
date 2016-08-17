B = 2
class A
	B = 3
	puts B
	puts ::B
	class C
		D = 4
	end
end

puts A::C::D
