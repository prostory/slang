require_relative '../../spec_helper'

describe 'Type inference: function' do
  it "types a call with an int" do
    node = Parser.parse [:do, [:fun, :foo, [], [:ret, 1]], [:foo]]
    context = CLang::Context.new.type_inference node
    node.last.type.should eq(context.int)
  end

  it "types a call with a string" do
    node = Parser.parse [:do, [:fun, :foo, [], [:ret, "Hello World"]], [:foo]]
    context = CLang::Context.new.type_inference node
    node.last.type.should eq(context.string)
  end

  it "types a call with an argument" do
    node = Parser.parse [:do, [:fun, :foo, [:arg], [:ret, :arg]], [:foo, nil, [1]], [:foo, nil, ["Hello World"]]]
    context = CLang::Context.new.type_inference node
    node[1].type.should eq(context.int)
    node[2].type.should eq(context.string)
  end
end