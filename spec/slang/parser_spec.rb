require_relative '../spec_helper'
require "parslet/rig/rspec"

describe SLang::Parser do
  let(:parser) { SLang::Parser.new }

  context "value parsing" do
    let(:literal_parser) { parser.literal }

    it "parses integers" do
      expect(literal_parser).to     parse("1")
      expect(literal_parser).to     parse("-123")
      expect(literal_parser).to     parse("120381")
      expect(literal_parser).to     parse("181")
      expect(literal_parser).to_not parse("0181")
    end

    it "parses floats" do
      expect(literal_parser).to     parse("0.1")
      expect(literal_parser).to     parse("3.14159")
      expect(literal_parser).to     parse("-0.00001")
      expect(literal_parser).to_not parse(".1")
    end

    it "parses booleans" do
      expect(literal_parser).to     parse("true")
      expect(literal_parser).to     parse("false")
      expect(literal_parser).to_not parse("truefalse")
    end

    it "parses strings" do
      expect(literal_parser).to     parse('""')
      expect(literal_parser).to     parse('"hello world"')
      expect(literal_parser).to     parse('"hello\\nworld"')
      expect(literal_parser).to     parse('"hello\\t\\n\\\\\\0world\\n"')
      expect(literal_parser).to_not parse("\"hello\nworld\"")
    end
  end
end

