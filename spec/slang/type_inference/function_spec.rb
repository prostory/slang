require_relative '../../spec_helper'

describe 'Type inference: function' do
  let(:string_class) { [:class, :String, nil,
      [:external, :dup, :strdup, [], :String],
      [:static, :new, [:const_str], [:dup, :const_str]]
  ] }

  it "types a call with an int" do
    node = BaseParser.parse [:do, [:fun, :foo, [], [:ret, 1]], [:foo]]
    CLang::Context.new.type_inference node
    node.last.type.should eq(Type.int)
  end

  it "types a call with a float" do
    node = BaseParser.parse [:do, [:fun, :foo, [], [:ret, 1.1]], [:foo]]
    CLang::Context.new.type_inference node
    node.last.type.should eq(Type.float)
  end

  it "types a call with a string" do
    node = BaseParser.parse [:do, string_class, [:fun, :foo, [], [:ret, "Hello World"]], [:foo]]
    CLang::Context.new.type_inference node
    node.last.type.should eq(Type.string)
  end

  it "types a call with an argument" do
    node = BaseParser.parse [:do, string_class, [:fun, :foo, [:arg], [:ret, :arg]], [:foo, nil, [1]], [:foo, nil, ["Hello World"]]]
    CLang::Context.new.type_inference node
    node[-2].type.should eq(Type.int)
    node[-1].type.should eq(Type.string)
  end
end