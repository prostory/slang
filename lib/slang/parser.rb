require 'parslet'

module SLang
  class Parser < Parslet::Parser
    rule(:space)            { match["\t "] }
    rule(:spaces?)          { space.repeat  }
    rule(:blank)            { match["\t\n "].repeat  }

    def spacesd(s)
      spaces? >> str(s) >> spaces?
    end

    def blanked(s)
      blank >> str(s) >> blank
    end

    rule(:digit)            { match('[0-9]') }

    rule(:alpha)            { match('[a-zA-Z_]') }

    rule(:bin)              { str('0b') >> match('[0-1]').repeat(1) }
    rule(:oct)              { str('0o') >> match('[0-7]').repeat(1) }
    rule(:dec)              { match('[1-9]') >> digit.repeat }
    rule(:hex)              { str('0x') >> match('[0-9a-fA-F]').repeat(1) }

    rule(:int_literal)              do
      (str('-').maybe >> (bin | oct | dec | hex)).as(:integer) >> spaces?
    end

    rule(:float_literal)            do
      (str('-').maybe >> digit.repeat(1) >> str('.') >> digit.repeat(1)).as(:float) >> spaces?
    end

    rule(:bool_literal)             do
      (str('true') | str('false')).as(:bool) >> spaces?
    end

    rule(:nil_literal)              do
      str('nil').as(:nil) >> spaces?
    end

    rule(:string_special)   { match['\0\t\n\r"\\\\'] }
    rule(:escaped_special)  { str("\\") >> match['0tnr"\\\\'] }
    rule(:string_literal)           do
      (str('"') >>
          (escaped_special | string_special.absent? >> any).repeat >>
          str('"')).as(:string) >> spaces?
    end

    def args(arg)
      (arg) >> (blanked(',') >> (arg)).repeat >> str(',').maybe
    end

    rule(:array_literal)            do
      (str('[') >> blank >> args(expr).maybe >> blank >> str(']')).as(:array) >> spaces?
    end

    rule(:hash_literal)             do
      (str('{') >> blank >> args(entry).maybe >> blank >> str('}')).as(:hash) >> spaces?
    end

    rule(:ident)                    do
      (alpha >> (alpha | digit).repeat >> match['?!'].maybe).as(:ident) >> spaces?
    end

    rule(:entry)                    do
      ((ident.as(:key) >> spacesd(':')) | (str('[') >> spaces? >> expr.as(:key) >> spaces? >> str(']') >> spacesd('='))) >> expr.as(:value)
    end

    rule(:f_arg)                    do
      ident.as(:name) >> (spacesd(':') >> ident.as(:type)).maybe
    end

    rule(:f_args)                   do
      f_arg >> (blanked(',') >> f_arg).repeat
    end

    rule(:bparam)                   do
      (f_args | (str('(') >> blank >> f_args.maybe >> blank >> str(')'))).maybe >> op_rasgn
    end

    rule(:literal)                  do
      float_literal |
          int_literal |
          bool_literal |
          nil_literal |
          string_literal |
          array_literal |
          hash_literal
    end

    rule(:primary)                  do
      literal | ident | str('(') >> expr >> str(')')
    end

    rule(:expr)                     do
      primary
    end

    rule(:do_stmt)                  do
      (do_keyword >> blank >> stmts >> blank >> end_keyword).as(:do_statement)
    end

    rule(:if_stmt)                  do
      ((if_keyword >> expr >> keyword_then.maybe >> stmts >>
          (keyword_elif >> expr >> stmts).repeat >>
          (keyword_else >> stmts).maybe >> keyword_end) |
          (stmt >> keyword_if >> expr)).as(:if_statement)
    end

    rule(:unless_stmt)              do
      ((unless_keyword >> expr >> keyword_then.maybe >> stmts >>
          (keyword_else >> stmts).maybe >> keyword_end) |
          (stmt >> unless_keyword >> expr)).as(:unless_statement)
    end

    rule(:block)                    do
      (str('{') >> bparam.maybe >> stmts >> str('}')).as(:block)
    end

    rule(:lambda)                   do
      (bparam >> stmts >> end_keyword).as(:lambda)
    end



    rule(:stmts)                    do
      expr
    end

    def self.keywords(*names)
      names.each do |name|
        rule("#{name}_keyword") { str(name.to_s) >> spaces? }
      end
    end

    keywords :break, :case, :class, :const, :continue, :def, :do, :elif, :else,
        :end, :export, :extend, :for, :if, :import, :include, :module, :of,
        :return, :until, :unless, :while

    def self.operators(operators={})
      trailing_chars = Hash.new { |hash,symbol| hash[symbol] = [] }

      operators.each_value do |symbol|
        operators.each_value do |op|
          if op[0,symbol.length] == symbol
            char = op[symbol.length,1]

            unless (char.nil? || char.empty?)
              trailing_chars[symbol] << char
            end
          end
        end
      end

      operators.each do |name,symbol|
        trailing = trailing_chars[symbol]

        if trailing.empty?
          rule(name) { str(symbol).as(:operator) >> spaces? }
        else
          pattern = "[#{Regexp.escape(trailing.join)}]"

          rule(name) {
            (str(symbol) >> match(pattern).absent?).as(:operator) >> spaces?
          }
        end
      end
    end

    operators :op_rshift_assign => '>>=',
        :op_lshift_assign => '<<=',
        :op_add_assign => '+=',
        :op_sub_assign => '-=',
        :op_mul_assign => '*=',
        :op_div_assign => '/=',
        :op_mod_assign => '%=',
        :op_band_assign => '&=',
        :op_xor_assign => '^=',
        :op_bor_assign => '|=',
        :op_inc => '++',
        :op_dec => '--',
        :op_rasgn => '->',
        :op_and => '&&',
        :op_or => '||',
        :op_le => '<=',
        :op_ge => '>=',
        :op_eq => '==',
        :op_ne => '!=',
        :op_assign => '=',
        :op_add => '+',
        :op_sub => '-',
        :op_mul => '*',
        :op_div => '/',
        :op_mod => '%',
        :op_lt => '<',
        :op_gt => '>',
        :op_not => '!',
        :op_bor => '|',
        :op_band => '&',
        :op_xor => '^',
        :op_lshift => '<<',
        :op_rshift => '>>',
        :op_inverse => '~'
  end
end