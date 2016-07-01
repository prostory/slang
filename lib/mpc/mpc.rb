require_relative 'mpc_lib'
require_relative 'typed_pointer'
require_relative 'struct_helper'

module MPC
  class State < FFI::Struct
    layout :pos, :long,
           :row, :long,
           :col, :long

    member_reader :pos, :row, :col

    def to_s
      "#{pos} #{row}:#{col}"
    end
  end

  class Error < FFI::ManagedStruct
    layout :state, State,
           :expected_num, :int,
           :filename, :string,
           :failure, :string,
           :expected, :pointer,
           :recieved, :char

    def self.release(ptr)
      MPC.mpc_error_delete ptr
    end

    def to_s
      MPC.mpc_err_string self
    end

    def display
      MPC.mpc_err_print self
    end

    def write(file)
      MPC.mpc_err_print_to self, file
    end
  end

  class Result < FFI::Union
    layout :error, Error,
           :output, :pointer

    member_reader :error, :output
  end

  class Parser < FFI::TypedPointer
    type :pointer

    def self.build(name)
      Parser.new MPC.mpc_new(name)
    end

    def self.release(ptr)
      MPC.mpc_delete ptr
    end

    def define(other)
      MPC.mpc_define(self, other)
      self
    end

    def undefine
      MPC.mpc_undefine(self)
      self
    end

    def self.cleanup(*parsers)
      MPC.mpc_cleanup parsers.size, parsers
    end

    def self.any
      self.new MPC.mpc_any
    end

    def self.char(c)
      self.new MPC.mpc_char(c)
    end

    def self.range(s, e)
      self.new MPC.mpc_range(s, e)
    end

    def self.oneof(s)
      self.new MPC.mpc_oneof(s)
    end

    def self.noneof(s)
      self.new MPC.mpc_noneof(s)
    end

    def self.satisfy(callback)
      self.new MPC.mpc_satisfy(callback)
    end

    def self.string(s)
      self.new MPC.mpc_string(s)
    end

    def self.pass
      self.new MPC.mpc_pass
    end

    def self.fail(m)
      self.new MPC.mpc_fail(m)
    end

    def self.fail_format(fmt, *args)
      self.new MPC.mpc_failf(fmt, args)
    end

    def self.lift(ctor)
      self.new MPC.mpc_lift(ctor)
    end

    def self.lift_val(x)
      self.new MPC.mpc_lift_val(x)
    end

    def self.anchor(callback)
      self.new MPC.mpc_anchor(callback)
    end

    def self.state
      self.new MPC.mpc_state
    end

    def expect(e)
      self.class.new MPC.mpc_expect(self, e)
    end

    def expect_format(fmt, *args)
      self.class.new MPC.mpc_expectf(self, fmt, args)
    end

    def apply(apply_fun)
      self.class.new MPC.mpc_apply(self, apply_fun)
    end

    def apply_to(apply_fun, x)
      self.class.new MPC.mpc_apply_to(self, apply_fun, x)
    end

    def not(dtor)
      self.class.new MPC.mpc_not(self, dtor)
    end

    def not_lift(dtor, ctor)
      self.class.new MPC.mpc_not_lift(self, dtor, ctor)
    end

    def maybe
      self.class.new MPC.mpc_maybe(self)
    end

    def maybe_lift(ctor)
      self.class.new MPC.mpc_maybe_lift(self, ctor)
    end

    def many(fold)
      self.class.new MPC.mpc_many(fold, self)
    end

    def many1(fold)
      self.class.new MPC.mpc_many1(fold, self)
    end

    def count(n, fold, dtor)
      self.class.new MPC.mpc_count(n, fold, self, dtor)
    end

    def self.or(*parsers)
      self.new MPC.mpc_or(parsers.size, parsers)
    end

    def self.and(fold, *parsers)
      self.new MPC.mpc_and(parsers.size, fold, parsers)
    end

    def predictive
      self.class.new MPC.mpc_predictive(self)
    end

    def self.eoi
      self.new MPC.mpc_eoi
    end

    def self.soi
      self.new MPC.mpc_soi
    end

    def self.boundary
      self.new MPC.mpc_boundary
    end

    def self.whitespace
      self.new MPC.mpc_whitespace
    end

    def self.whitespaces
      self.new MPC.mpc_whitespaces
    end

    def self.blank
      self.new MPC.mpc_blank
    end

    def self.newline
      self.new MPC.mpc_newline
    end

    def self.tab
      self.new MPC.mpc_tab
    end

    def self.escape
      self.new MPC.mpc_escape
    end

    def self.digit
      self.new MPC.mpc_digit
    end

    def self.hexdigit
      self.new MPC.mpc_hexdigit
    end

    def self.octdigit
      self.new MPC.mpc_octdigit
    end

    def self.digits
      self.new MPC.mpc_digits
    end

    def self.hexdigits
      self.new MPC.mpc_hexdigits
    end

    def self.octdigits
      self.new MPC.mpc_octdigits
    end

    def self.lower
      self.new MPC.mpc_lower
    end

    def self.upper
      self.new MPC.mpc_upper
    end

    def self.alpha
      self.new MPC.mpc_alpha
    end

    def self.underscore
      self.new MPC.mpc_underscore
    end

    def self.alphanum
      self.new MPC.mpc_alphanum
    end

    def self.int
      self.new MPC.mpc_int
    end

    def self.hex
      self.new MPC.mpc_hex
    end

    def self.oct
      self.new MPC.mpc_oct
    end

    def self.number
      self.new MPC.mpc_number
    end

    def self.real
      self.new MPC.mpc_real
    end

    def self.float
      self.new MPC.mpc_float
    end

    def self.char_lit
      self.new MPC.mpc_char_lit
    end

    def self.string_lit
      self.new MPC.mpc_string_lit
    end

    def self.regex_lit
      self.new MPC.mpc_regex_lit
    end

    def self.ident
      self.new MPC.mpc_ident
    end

    def startwith
      self.class.new MPC.mpc_startwith(self)
    end

    def endwith(dtor)
      self.class.new MPC.mpc_endwith(self, dtor)
    end

    def whole(dtor)
      self.class.new MPC.mpc_whole(self, dtor)
    end

    def stripl
      self.class.new MPC.mpc_stripl(self)
    end

    def stripr
      self.class.new MPC.mpc_stripr(self)
    end

    def strip
      self.class.new MPC.mpc_strip(self)
    end

    def tok
      self.class.new MPC.mpc_tok(self)
    end

    def self.sym(s)
      self.new MPC.mpc_sym(s)
    end

    def total(dtor)
      self.class.new MPC.mpc_total(self, dtor)
    end

    def display
      MPC.mpc_print self
    end
  end

  class AST < FFI::ManagedStruct
    include Enumerable

    layout :tag, :string,
           :contents, :string,
           :state, State,
           :children_num, :int,
           :children, :pointer

    member_reader :contents, :state, :children_num

    def self.build(tag, *contents)
      if contents.size == 1
        self.new MPC.mpc_ast_new(tag, contents[0])
      else
        self.new MPC.mpc_ast_build(contents.size, tag, contents)
      end
    end

    def self.release(ptr)
#      MPC.mpc_ast_delete ptr
    end

    def each(&block)
      children.each(&block)
    end

    def add_root
      self.class.new MPC.mpc_ast_add_root(self)
    end

    def add_child(child)
      MPC.mpc_ast_add_child(self, child)
      self
    end

    def add_tag(tag)
      MPC.mpc_ast_add_tag(self, tag)
      self
    end

    def tag
      tags = self[:tag].split("|")
      tags.last == "regex" || tags.last == ">" ? tags.last(2).first.to_sym : tags.last.to_sym
    end

    def tag=(tag)
      MPC.mpc_ast_tag(self, tag)
      self
    end

    def state=(state)
      MPC.mpc_ast_state(self, state)
      self
    end

    def children
      return [] if children_num == 0
      self[:children].get_array_of_pointer(0, children_num).map { |ptr| AST.new ptr }
    end

    def display
      MPC.mpc_ast_print self
    end

    def write_to(fp)
      MPC.mpc_ast_print_to self, fp
    end

    def line
      state.row + 1
    end

    def col
      state.col + 1
    end

    def location(source)
      s = ''
      s << source[state.row]
      s << "\n#{' ' * state.col}#{'^' * contents.length}"
    end

    def ==(other)
      self.class == other.class && MPC.mpc_ast_eq(self, other)
    end

    def to_s
      "#{tag}:#{contents}"
    end
  end
  
  class GrammarRule
    attr_accessor :name
    attr_accessor :rule
    
    def initialize(name, rule)
      @name = name
      @rule = rule
      @parser = Parser.build(name.to_s)
    end
    
    def parser
      @parser
    end
    
    def to_s
      "#{name}\t:#{rule};"
    end
  end
  
  class Language
    @@rules = {}

    def self.inherited(klass)
      @@rules = {}
    end
    
    def initialize(flags = :default)
      parsers = [:pointer].product(@@rules.values.map(&:parser)).push(:int, 0).flatten
      err = MPC.mpca_lang(flags, grammar, *parsers)
      unless err.null?
        puts grammar
        raise Error.new(err).to_s
      end
    end

    def grammar
      @@rules.values.join("\t\n")
    end
    
    def self.define(name, rule)
      @@rules[name] = GrammarRule.new(name, rule)
    end
    
    def rule(name)
      @@rules[name] or raise "can't find rule '#{name}'"
    end
    
    def parser(name)
      rule(name).parser
    end

    def self.rules
      @@rules
    end
    
    def parse_file(file, root)
      result = Result.new
      if MPC.mpc_parse_contents(file, parser(root), result) == 0
        puts rule(root).to_s
        raise result.error.to_s
      end
      result.output
    end

    def parse_string(string, root)
      result = Result.new
      if MPC.mpc_parse(__FILE__, string, parser(root), result) == 0
        puts string
        puts rule(root).to_s
        raise result.error.to_s
      end
      result.output
    end
	end
end
