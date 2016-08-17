class Fixnum
  def dump
    puts self
  end
end

class A
  @@f = 3
  
  def foo
    @a = 1
    @b = 2
    @@c = 1
    @@d = 2
  end
  
  def a; @a end
  def b; @b end
  def self.c; @@c end
  def self.d; @@d end
  def self.f; @@f end
end

class B < A
  @@f = 6
  
  def bar
    @@c = 3
    @@d = 4
    @@e = 5
  end
  
  def self.e; @@e end
end

a = A.new
a.foo
a.a.dump
a.b.dump
A.c.dump
A.d.dump
b = B.new
b.bar
A.c.dump
A.d.dump
b.foo
b.a.dump
b.b.dump
B.c.dump
B.d.dump
B.e.dump
A.f.dump



