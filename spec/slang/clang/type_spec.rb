describe "CLang type" do
  context = CLang::Context.new

  it "types int" do
    context.int.type.should eq(:int)
  end

  it "types void" do
    context.void.type.should eq(:void)
  end

  it "types string" do
    context.string.type.should eq('char *')
  end

  it "types struct with no name" do
    point = context.struct({x: context.int, y: context.int})
    point.type.should eq('struct { Integer x; Integer y; }')
  end

  it "types struct width name" do
    point = context.struct({x: context.int, y: context.int}, :Point)
    point.define.should eq('typedef struct { Integer x; Integer y; } Point;')
  end

  it "types union with no name" do
    value = context.union({i: context.int, s: context.string})
    value.type.should eq('union { Integer i; String s; }')
  end

  it "types union width name" do
    value = context.union({i: context.int, s: context.string}, :Value)
    value.define.should eq('typedef union { Integer i; String s; } Value;')
  end

  it "types merge" do
    context.merge(context.int, context.int).should eq(context.int)
    context.merge(context.int, context.string).should eq(context.union([context.int, context.string]))
  end
end