require_relative '../spec_helper'
require "parslet/rig/rspec"

describe SLang::Transform do
  let(:xform) { SLang::Transform.new }
  let(:parser) { SLang::Parser.new }

  context "statement" do
    it "transforms an integer value" do
      expect(xform.apply(:integer => "1")).to eq(1.int)
    end

    it "transforms a float" do
      expect(xform.apply(:float => "0.123")).to eq(0.123.float)
    end

    it "transforms a boolean" do
      expect(xform.apply(:bool => "true")).to eq(true.bool)
      expect(xform.apply(:bool => "false")).to eq(false.bool)
    end

    it "transforms a string" do
      expect(xform.apply(:string => "a string")).to eq("a string".string)
    end

    it "unescapes special characters in captured strings" do
      expect(xform.apply(:string => "a\\nb")).to eq("a\\nb".string)
    end

    it "transforms an array" do
      input = { :array => [{:integer=>"1"}, {:float=>"1.02"}, {:string=>'hello'}] }
      expect(xform.apply(input)).to eq([1.int, 1.02.float, "hello".string].array)
    end

    it "transforms a const" do
      expect(xform.apply(:const => 'Hello')).to eq('Hello'.const)
    end

    it "transforms a class variable" do
      expect(xform.apply(:class_var => '@@hello')).to eq('hello'.class_var)
    end

    it "transforms a instance variable" do
      expect(xform.apply(:instance_var => '@hello')).to eq('hello'.instance_var)
    end

    it "transforms a variable" do
      expect(xform.apply(:variable => 'hello')).to eq('hello'.var)
    end

    it "transforms a negative expression" do
      input = parser.parse('-i')
      expect(xform.apply(input).last).to eq('-'.call(['i'.var], 0.int))
    end

    it "transforms a unary operation" do
      input = parser.parse('!i')
      expect(xform.apply(input).last).to eq('!'.call([], 'i'.var))
    end

    it "transforms a binary operation" do
      input = parser.parse('1 +i')
      expect(xform.apply(input).last).to eq('+'.call(['i'.var], 1.int))
      input = parser.parse('2 * i + 5')
      expect(xform.apply(input).last).to eq('+'.call([5.int], '*'.call(['i'.var], 2.int)))
      input = parser.parse('1++*5')
      expect(xform.apply(input).last).to eq('*'.call([5.int], 2.int))
    end

    it "transforms a if statement" do
      input = parser.parse('if i < 0 then i else -i end')
      expect(xform.apply(input).last).to eq(If.new('<'.call([0.int], 'i'.var), 'i'.var, '-'.call(['i'.var], 0.int)))
    end

    it "transforms a if statement witch has else if subtree" do
      input = parser.parse('if i < 0 then i elif i == 0 then i + 1 elif i > 5 then i - 4 else -i end')
      expect(xform.apply(input).last).to eq(If.new('<'.call([0.int], 'i'.var), 'i'.var,
                                              If.new('=='.call([0.int], 'i'.var), '+'.call([1.int], 'i'.var),
                                              If.new('>'.call([5.int], 'i'.var), '-'.call([4.int], 'i'.var), '-'.call(['i'.var], 0.int)))))
    end

    it "transforms a unless statement" do
      input = parser.parse('unless i < 0 then i end')
      expect(xform.apply(input).last).to eq(If.new('!'.call([], '<'.call([0.int], 'i'.var)), 'i'.var))
    end

    it "transforms a case of statement" do
      input = parser.parse('case a of 1, 2; 3 of 3; 4 else 5 end')
      expect(xform.apply(input).last).to eq(If.new('=='.call([1.int], 'a'.var), 3.int,
                                        If.new('=='.call([2.int], 'a'.var), 3.int,
                                        If.new('=='.call([3.int], 'a'.var), 4.int,
                                        5.int))))

    end

    it "transforms a while statement" do
      input = parser.parse('while i < 10 do i++ end')
      expect(xform.apply(input).last).to eq(While.new('<'.call([10.int], 'i'.var), '++'.call([], 'i'.var)))
    end

    it "transforms a until statement" do
      input = parser.parse('until i < 10 do i-- end')
      expect(xform.apply(input).last).to eq(While.new('!'.call([], '<'.call([10.int], 'i'.var)), '--'.call([], 'i'.var)))
    end

    it "transforms a do while statement" do
      input = parser.parse('do i++ while i < 10 end')
      expect(xform.apply(input).last).to eq(DoWhile.new('<'.call([10.int], 'i'.var), '++'.call([], 'i'.var)))
    end

    it "transforms a do until statement" do
      input = parser.parse('do i++ until i < 10 end')
      expect(xform.apply(input).last).to eq(DoWhile.new('!'.call([], '<'.call([10.int], 'i'.var)), '++'.call([], 'i'.var)))
    end

    it "transforms a lambda statement" do
      input = parser.parse('(a, b) -> a + b end')
      expect(xform.apply(input).last).to eq(Lambda.new(['a'.param, 'b'.param], '+'.call(['b'.var], 'a'.var)))
    end

    it "transforms a call statement" do
      input = parser.parse('foo a, b, c')
      expect(xform.apply(input).last).to eq('foo'.call(['a'.var, 'b'.var, 'c'.var]))
    end

    it "transforms a call statement with object" do
      input = parser.parse('p.foo a, b, c')
      expect(xform.apply(input).last).to eq('foo'.call(['a'.var, 'b'.var, 'c'.var], 'p'.var))
      input = parser.parse('p.foo.bar a, b, c')
      expect(xform.apply(input).last).to eq('bar'.call(['a'.var, 'b'.var, 'c'.var], 'foo'.call([], 'p'.var)))
    end

    it "transforms an assign statement" do
      input = parser.parse('a = 1')
      expect(xform.apply(input).last).to eq(Assign.new('a'.var, 1.int))
    end

    it "transforms a return statement" do
      input = parser.parse('return a, b')
      expect(xform.apply(input).last).to eq(Return.new(['a'.var, 'b'.var]))
    end

    it "transforms a return statement without values" do
      input = parser.parse('return')
      expect(xform.apply(input).last).to eq(Return.new([]))
    end

    it "transforms a include statement" do
      input = parser.parse('include A, B, C')
      expect(xform.apply(input).last).to eq(Include.new(['A', 'B', 'C']))
    end

    it "transforms a module declaration" do
      input = parser.parse('module A a = a + 2; 3 end')
      expect(xform.apply(input).last).to eq('A'.module([Assign.new('a'.var, '+'.call([2.int], 'a'.var)), 3.int]))
    end

    it "transforms a module declaration include function" do
      input = parser.parse('module A def foo; 1 end end')
      mod = 'A'.module
      mod << 'foo'.function([], [1.int], mod)
      expect(xform.apply(input).last).to eq(mod)
    end

    it "transforms a class declaration" do
      input = parser.parse('class A < B a = a + 2; 3 end')
      expect(xform.apply(input).last).to eq('A'.class_def([Assign.new('a'.var, '+'.call([2.int], 'a'.var)), 3.int], 'B'))
    end

    it "transforms a class declaration include function" do
      input = parser.parse('class A def foo; 1 end end')
      clazz = 'A'.class_def(nil, 'Object')
      clazz << 'foo'.function([], [1.int], clazz)
      expect(xform.apply(input).last).to eq(clazz)
    end

    it "transforms a function declaration" do
      input = parser.parse('def foo(a); a + b end')
      expect(xform.apply(input).last).to eq('foo'.function(['a'.param], '+'.call(['b'.var], 'a'.var)))
    end

    it "transforms a external declaration" do
      input = parser.parse('external foo(Integer):Integer')
      expect(xform.apply(input).last).to eq('foo'.external([:Integer.param], :Integer))
    end

    it "transforms a operator declaration" do
      input = parser.parse('operator +(Integer, Float):Float')
      expect(xform.apply(input).last).to eq('+'.operator([:Integer.param, :Float.param], :Float))
    end
  end
end