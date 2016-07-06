require_relative '../spec_helper'
require "parslet/rig/rspec"

describe SLang::Transform do
  let(:xform) { SLang::Transform.new }

  context "literal" do
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
      expect(xform.apply(:string => "a\\nb")).to eq("a\nb".string)
    end

    it "transforms an array" do
      input = { :array => [{:integer=>"1"}, {:float=>"1.02"}, {:string=>'hello'}] }
      expect(xform.apply(input)).to eq([1.int, 1.02.float, "hello".string].array)
    end
  end

end