require_relative '../spec_helper'
require "parslet/rig/rspec"

describe SLang::Parser do
  let(:parser) { SLang::Parser.new }

  context "expression parsing" do
    let(:expr_parser) { parser.expr }

    it "parses integers" do
      expect(expr_parser).to     parse("0")
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

    it "parses primarys" do
      expect(expr_parser).to     parse('(1)')
      expect(expr_parser).to     parse('(if empty? then false end)')
    end
    
    it "parses expressions" do
	  expect(expr_parser).to     parse('1 + 2')
      expect(expr_parser).to     parse('1 + 2*3/4')
      expect(expr_parser).to     parse('(1 + 2)*3/4')
      expect(expr_parser).to     parse('a && b || c')
      expect(expr_parser).to     parse('! a || (b && c)')
      expect(expr_parser).to     parse('(a >> 5)++')
      expect(expr_parser).to     parse('a + 5 ++')
    end

    def self.it_parse(code, type, value = code)
      it "parses #{type} into {#{type} => #{value}}" do
        expect(expr_parser.parse(code)).to eq type => value
      end
    end

    it_parse '1234', :integer
    it_parse '0.123', :float
    it_parse 'true', :bool
    it_parse '"Hello world"', :string
    it_parse '[1, 2, 3]', :array, [{:integer=>"1"}, {:integer=>"2"}, {:integer=>"3"}]
    it_parse '{a: 1, b: 2}', :hash, [{:key=>{:ident=>"a"}, :value=>{:integer=>"1"}}, {:key=>{:ident=>"b"}, :value=>{:integer=>"2"}}]
    it_parse 'if empty? then false end', :if_statement, {:condition=>{:ident=>"empty?"}, :then_body=>{:bool=>"false"}}
  end

  context "statement parsing" do
    let(:stmt_parser) { parser.stmt }

    it "parses block statements" do
      expect(stmt_parser).to     parse('begin end')
      expect(stmt_parser).to     parse('begin 1 end')
      expect(stmt_parser).to     parse('begin 1;2 end')
      expect(stmt_parser).to_not parse('begin 1')
    end

    it "parses if statements" do
      expect(stmt_parser).to     parse('if empty? then true end')
      expect(stmt_parser).to     parse('if empty? then true end')
      expect(stmt_parser).to     parse('if empty? then true else false end')
      expect(stmt_parser).to     parse('if empty? ; true elif has_one? ; 1 else size end')
      expect(stmt_parser).to     parse('if empty? ; true elif one? ; 1 elif two? then 2 else false end')
      # expect(stmt_parser).to	 parse('return true if empty?')
      expect(stmt_parser).to_not parse('if empty? ; true')
      expect(stmt_parser).to_not parse('if empty? ; true else 1 else size end')
    end

    it "parses unless statements" do
      expect(stmt_parser).to     parse('unless empty? ; true end')
      expect(stmt_parser).to     parse('unless empty? then true end')
      expect(stmt_parser).to     parse('unless empty? ; true else false end')
      expect(stmt_parser).to_not parse('unless empty? true else 1 else size end')
    end

    it "parses case statements" do
      expect(stmt_parser).to     parse('case a of 1; 2 end')
      expect(stmt_parser).to     parse('case a of 1, 2, 3; a; of 4, 5, 6; b end')
      expect(stmt_parser).to	 parse("case a \nof 1, 2, 3\n a; b of 4, 5, 6; b end")
      expect(stmt_parser).to	 parse("case a \nof 1, 2, 3\n a; b else b end")
      expect(stmt_parser).to_not parse('case a end')
    end
    
    it "parses while statements" do
      expect(stmt_parser).to     parse('while empty? do 1 end')
      expect(stmt_parser).to     parse("while empty? \n 1 end")
      expect(stmt_parser).to	 parse("until empty? do 1 end")
      expect(stmt_parser).to	 parse("until empty? \n 1 end")
      expect(stmt_parser).to_not parse('while empty? end')
    end
    
    it "parses do-while statements" do
      expect(stmt_parser).to     parse('do 1 while empty? end')
      expect(stmt_parser).to     parse("do 1 until empty? end")
      expect(stmt_parser).to_not parse('do 1 while empty?')
    end

    it "parses lambda statements" do
      expect(stmt_parser).to     parse('-> end')
      expect(stmt_parser).to     parse('()-> end')
      expect(stmt_parser).to     parse('-> 1 end')
      expect(stmt_parser).to     parse('()-> 2 end')
      expect(stmt_parser).to     parse('(a)-> 3 end')
      expect(stmt_parser).to     parse('(a, b, c)-> a; b; c end')
      expect(stmt_parser).to     parse('a, b, c-> a; b; c end')
      expect(stmt_parser).to     parse("a\n, \nb, \nc-> a; b; c end")
      expect(stmt_parser).to_not parse("-> do_something")
    end

    it "parses assign statements" do
      expect(stmt_parser).to     parse('a = b')
      expect(stmt_parser).to     parse('a = b = c')
      expect(stmt_parser).to_not parse("1 = a")
      expect(stmt_parser).to_not parse("a = 1 = 2")
    end

    it "parses return statements" do
      expect(stmt_parser).to     parse('return')
      expect(stmt_parser).to     parse('return a')
      expect(stmt_parser).to     parse('return a, b, c')
    end

    it "parses break statements" do
      expect(stmt_parser).to     parse('break')
      expect(stmt_parser).to     parse('break')
      expect(stmt_parser).to_not parse('break a')
    end

    it "parses continue statements" do
      expect(stmt_parser).to     parse('continue')
      expect(stmt_parser).to     parse('continue')
      expect(stmt_parser).to_not parse('continue a')
    end
  end
  
  context "declaration parsing" do
    let(:decl_parser) { parser.decl }

    it "parses module declaration" do
      expect(decl_parser).to     parse('module A end')
      expect(decl_parser).to     parse('module A 1 end')
      expect(decl_parser).to     parse("module A \n 1;2 end")
      expect(decl_parser).to     parse("export module A end")
      expect(decl_parser).to_not parse('module A 1')
    end
    
    it "parses class declaration" do
      expect(decl_parser).to     parse('class A end')
      expect(decl_parser).to     parse('class A 1 end')
      expect(decl_parser).to     parse("class A \n 1;2 end")
      expect(decl_parser).to     parse("export class A end")
      expect(decl_parser).to     parse("class A < B end")
      expect(decl_parser).to_not parse('class A 1')
    end
    
    it "parses import declaration" do
      expect(decl_parser).to     parse('import A')
    end
    
    it "parses def declaration" do
      expect(decl_parser).to     parse('def foo; end')
      expect(decl_parser).to     parse('def foo; 1 end')
      expect(decl_parser).to     parse("def foo(); 1 end")
      expect(decl_parser).to     parse("def foo(a, b); a; b end")
      expect(decl_parser).to     parse("export def foo(a: Integer, b: Float); 1 end")
      expect(decl_parser).to_not parse('def a 1')
    end
  end
end

