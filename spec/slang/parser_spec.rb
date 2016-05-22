require_relative '../spec_helper'

describe Parser do
	def self.it_parse(exp, nodes)
		it "parses ‘#{exp}’" do
			Parser.parse(exp).should eq(Expressions.from nodes)
		end
	end



	it_parse [:foo], Call.new(:foo)
	it_parse [:inc, 1], Call.new(:inc, [1.int])
	it_parse [:puts, "Hello World"], Call.new(:puts, ["Hello World".string])
	it_parse [:do, [:foo], [:bar]], Do.new([Call.new(:foo), Call.new(:bar)])
	it_parse [:fun, :foo, [], [:bar]], Function.new(:foo, [], [Call.new(:bar)])
	it_parse [:lambda, [], [:foo]], Lambda.new([], [Call.new(:foo)])
	it_parse [:call, [:lambda, [], [:foo]], []], Expressions.new([Lambda.new([], [Call.new(:foo)]), Call.new(:lambda__3)])
	it_parse [:if, [:test], [:foo], [:bar]], If.new(Call.new(:test), [Call.new(:foo)], [Call.new(:bar)])
	it_parse [:while, [:test], [:foo]], While.new(Call.new(:test), [Call.new(:foo)])
  it_parse [:fun, :foo, [], [:ret, 1]], Function.new(:foo, [], [Return.new([1.int])])
end