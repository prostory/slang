require_relative '../../spec_helper'

describe "CLang type" do
  CLang::Context.new

  it "types int" do
    Type.int.target_type.should eq(:int)
  end

  it "types void" do
    Type.void.target_type.should eq(:void)
  end

  it "types string" do
    Type.string.target_type.should eq('char *')
  end

  it "types struct" do
    point = Type.struct([Variable.new(:x, Type.int), Variable.new(:y, Type.int)], :Point)
    point.target_type.should eq('struct { Integer x; Integer y; }')
  end

  it "types union" do
    value = Type.union([Type.int, Type.string])
    value.define.should eq("typedef union { Integer uInteger; String uString; } Options;\n")
  end

  it "types merge" do
    Type.merge(Type.int, Type.int).should eq(Type.int)
    Type.merge(Type.int, Type.string).should eq(Type.union([Type.int, Type.string]))
  end
end