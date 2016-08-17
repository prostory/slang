class A
  def a; @a end
  def a=(n); @a = n - 1 end
  def a=(n:Integer); @a = n end
end

a = A.new
a.a = 5

printf "%d\n", a.a

a.a = 3.5
printf "%f\n", a.a

class B < A

end

b = B.new
b.a = 5.5
printf "%.1f\n", b.a

class A
  def a; 1 end
end

a = A.new
b = B.new

printf "%d\n", a.a
printf "%d\n", b.a
