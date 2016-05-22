describe "CLang type" do
  context = CLang::Context.new

  it "types int" do
    context.int.type.should eq(:int)
  end

  it "types void" do
    context.void.type.should eq(:void)
  end

  it "types string" do
    context.raw_string.type.should eq('char *')
  end

  it "types struct with no name" do
    point = context.struct({x: context.int, y: context.int})
    point.type.should eq('struct { int x; int y; }')
  end

  it "types struct width name" do
    point = context.struct({x: context.int, y: context.int}, :Point)
    point.define.should eq('typedef struct { int x; int y; } Point;')
  end

  it "types union with no name" do
    value = context.union({i: context.int, s: context.raw_string})
    value.type.should eq('union { int i; char * s; }')
  end

  it "types union width name" do
    value = context.union({i: context.int, s: context.raw_string}, :Value)
    value.define.should eq('typedef union { int i; char * s; } Value;')
  end

  it "types merge" do
    context.merge(context.int, context.int).should eq(context.int)
    context.merge(context.int, context.raw_string).should eq(context.union([context.int, context.raw_string]))
  end
end