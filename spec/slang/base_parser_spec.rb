require_relative '../spec_helper'

describe BaseParser do
	def self.it_parse(exp, nodes)
		it "parses ‘#{exp}’" do
			BaseParser.parse(exp).should eq(Expressions.from nodes)
		end
	end

	it_parse [:foo], Call.new(:foo)
	it_parse [:inc, 1], Call.new(:inc, [], 1.int)
	it_parse [:puts, "Hello World"], Call.new(:puts, [], "Hello World".new_string)
	it_parse [:do, [:foo], [:bar]], Do.new([Call.new(:foo), Call.new(:bar)])
	it_parse [:fun, :foo, [], [:bar]], Function.new(:foo, [], [Call.new(:bar)])
	it_parse [:lambda, [], [:foo]], Lambda.new([], [Call.new(:foo)])
	it_parse [:call, [:lambda, [], [:foo]], []], Expressions.new([Lambda.new([], [Call.new(:foo)]), Call.new(:lambda)])
	it_parse [:if, [:test], [:foo], [:bar]], If.new(Call.new(:test), [Call.new(:foo)], [Call.new(:bar)])
	it_parse [:while, [:test], [:foo]], While.new(Call.new(:test), [Call.new(:foo)])
  it_parse [:fun, :foo, [], [:ret, 1]], Function.new(:foo, [], [Return.new([1.int])])
	it_parse [:external, :puts, [:String], :Integer], External.new(:puts, nil, [Parameter.new(nil, :String)], :Integer)
	it_parse [:class, :Integer], ClassDef.new(:Integer)
	it_parse [:operator, :+, [:Integer, :Integer], :Integer], Operator.new(:+, nil, [Parameter.new(nil, :Integer), Parameter.new(nil, :Integer)], :Integer)
	it_parse [:set, :i, 0], Assign.new(Variable.new(:i), 0.int)
	it_parse [:list, 1, 2, 3, 4], ArrayLiteral.new([1.int, 2.int, 3.int, 4.int])
	it_parse [:set, :@i, 0], Assign.new(Member.new(:i), 0.int)
	it_parse [:new, :Integer, [1]], Call.new(:new, [1.int], Const.new(:Integer))
	it_parse [:set, :@@i, 2.3], Assign.new(ClassVar.new(:i), 2.3.float)
end