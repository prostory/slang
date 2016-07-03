require_relative '../spec_helper'
require "parslet/rig/rspec"

describe SLang::Parser do
  let(:parser) { SLang::Parser.new }

  context "value parsing" do
    let(:expr_parser) { parser.expr }

    it "parses integers" do
      expect(expr_parser).to     parse("1")
      expect(expr_parser).to     parse("-123")
      expect(expr_parser).to     parse("0b0101")
      expect(expr_parser).to     parse("0o1234")
      expect(expr_parser).to     parse("0xabcd")
      expect(expr_parser).to     parse("-0b0101")
      expect(expr_parser).to     parse("-0o1234")
      expect(expr_parser).to     parse("-0xabcd")
      expect(expr_parser).to_not parse("0b123")
      expect(expr_parser).to_not parse("0o89a")
      expect(expr_parser).to_not parse("0xggg")
      expect(expr_parser).to_not parse("0181")
    end

    it "parses floats" do
      expect(expr_parser).to     parse("0.1")
      expect(expr_parser).to     parse("3.14159")
      expect(expr_parser).to     parse("-0.00001")
      expect(expr_parser).to_not parse(".1")
    end

    it "parses booleans" do
      expect(expr_parser).to     parse("true")
      expect(expr_parser).to     parse("false")
    end

    it "parses strings" do
      expect(expr_parser).to     parse('""')
      expect(expr_parser).to     parse('"hello world"')
      expect(expr_parser).to     parse('"hello\\nworld"')
      expect(expr_parser).to     parse('"hello\\t\\n\\\\\\0world\\n"')
      expect(expr_parser).to_not parse("\"hello\nworld\"")
    end

    it "parses arrays" do
      expect(expr_parser).to     parse('[]')
      expect(expr_parser).to     parse('[1, 2, "hello"]')
      expect(expr_parser).to     parse('["hello", true, ["hello", 2.0, 3.5, 1, 2]]')
      expect(expr_parser).to     parse("[\n1,\n2\n]")
      expect(expr_parser).to     parse('[1.2, false, 3, ]')
      expect(expr_parser).to_not parse('[1, 2, 3, 4')
    end

    it "parses identifiers" do
      expect(expr_parser).to     parse('abc')
      expect(expr_parser).to     parse('a_001_22')
      expect(expr_parser).to     parse('empty?')
      expect(expr_parser).to     parse('strip!')
      expect(expr_parser).to_not parse('汉字')
      expect(expr_parser).to_not parse('122ba')
      expect(expr_parser).to_not parse('ad@$')
    end

    it "parses hashs" do
      expect(expr_parser).to     parse('{}')
      expect(expr_parser).to     parse('{a: 1, b: 2}')
      expect(expr_parser).to     parse('{[1] = "hello", ["hello"] = 2 }')
      expect(expr_parser).to     parse("{a: 1, b: false, c: d, }")
      expect(expr_parser).to_not parse('{1}')
      expect(expr_parser).to_not parse("{1:2 }")
      expect(expr_parser).to_not parse("{a:1, b:2, c:3, d:4")
    end

    it "parses do statements" do
     # expect(expr_parser).to     parse('do end')
      expect(expr_parser).to     parse('do 1 end')
    end

    def self.it_parse(code, type, value = code)
      it "parses #{type} into {#{type} => #{value}}" do
        expect(expr_parser.parse(code)).to eq type => value
      end
    end

    it_parse '1234', :integer
    it_parse '-0.123', :float
    it_parse 'true', :bool
    it_parse '"Hello world"', :string
    it_parse '[1, 2, 3]', :array, [{:integer=>"1"}, {:integer=>"2"}, {:integer=>"3"}]
    it_parse '{a: 1, b: 2}', :hash, [{:key=>{:ident=>"a"}, :value=>{:integer=>"1"}}, {:key=>{:ident=>"b"}, :value=>{:integer=>"2"}}]
  end
end

