require 'parslet'

module SLang
  class Parser < Parslet::Parser
    rule(:space)            { match('[ \t]').repeat(1) }
    rule(:space?)           { space.maybe  }
    rule(:blank)            { match('[ \t\n]').repeat(1) }
    rule(:blank?)           { blank.maybe }
    rule(:terms)            { match('[;\n]').repeat(1) >> space? }

    rule(:lparen)           { str('(') >> space? }
    rule(:rparen)           { str(')') >> space? }
    rule(:comma)            { str(',') >> space? }

    def spaced(s)
      space? >> str(s) >> space?
    end

    def blanked(s)
      blank? >> str(s) >> blank?
    end

    rule(:digit)            { match('[0-9]') }

    rule(:alpha)            { match('[a-zA-Z_]') }

    rule(:bin)              { str('0b') >> match('[0-1]').repeat(1) }
    rule(:oct)              { str('0o') >> match('[0-7]').repeat(1) }
    rule(:dec)              { match('[1-9]') >> digit.repeat }
    rule(:hex)              { str('0x') >> match('[0-9a-fA-F]').repeat(1) }

    rule(:int_literal)              do
      (str('-').maybe >> (bin | oct | dec | hex)).as(:integer) >> space?
    end

    rule(:float_literal)            do
      (str('-').maybe >> digit.repeat(1) >> str('.') >> digit.repeat(1)).as(:float) >> space?
    end

    rule(:bool_literal)             do
      (str('true') | str('false')).as(:bool) >> space?
    end

    rule(:nil_literal)              do
      str('nil').as(:nil) >> space?
    end

    rule(:string_special)   { match['\0\t\n\r"\\\\'] }
    rule(:escaped_special)  { str("\\") >> match['0tnr"\\\\'] }
    rule(:string_literal)           do
      (str('"') >>
          (escaped_special | string_special.absent? >> any).repeat >>
          str('"')).as(:string) >> space?
    end

    def args(arg)
      (arg) >> (blanked(',') >> (arg)).repeat >> str(',').maybe
    end

    rule(:array_literal)            do
      (str('[') >> blank? >> args(expr).maybe >> blank? >> str(']')).as(:array) >> space?
    end

    rule(:hash_literal)             do
      (str('{') >> blank? >> args(entry).maybe >> blank? >> str('}')).as(:hash) >> space?
    end

    rule(:ident)                    do
      (alpha >> (alpha | digit).repeat >> match['?!'].maybe).as(:ident) >> space?
    end

    rule(:entry)                    do
      ((ident.as(:key) >> spaced(':')) | (str('[') >> space? >> expr.as(:key) >> space? >> str(']') >> spaced('='))) >> expr.as(:value)
    end

    rule(:f_arg)                    do
      ident.as(:name) >> (spaced(':') >> ident.as(:type)).maybe
    end

    rule(:f_args)                   do
      f_arg >> (blanked(',') >> f_arg).repeat
    end

    rule(:bparam)                   do
      (f_args | (str('(') >> blank? >> f_args.maybe >> blank? >> str(')'))).maybe >> op_rasgn
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
      lparen >> expr >> rparen | literal | do_stmt | if_stmt | unless_stmt | case_stmt | lambda_stmt | assign_stmt | ident
    end

    rule(:expr)                     do
      primary
    end

    rule(:do_stmt)                  do
      (do_keyword >> blank? >> stmts >> blank? >> end_keyword).as(:do_statement)
    end

    rule(:if_stmt)                  do
      (if_keyword >> expr >> (then_keyword | terms) >> stmts.as(:then_body) >>
          (elif_keyword >> expr >> (then_keyword | terms) >> stmts.as(:elif_body)).repeat >>
          (else_keyword >> stmts.as(:else_body)).maybe >> end_keyword).as(:if_statement)
    end

    rule(:unless_stmt)              do
      (unless_keyword >> expr >> (then_keyword | terms) >> stmts.as(:then_body) >>
          (else_keyword >> stmts.as(:else_body)).maybe >> end_keyword).as(:unless_statement)
    end

    rule(:case_stmt)                do
      (case_keyword >> expr >> (of_keyword >> args(expr) >> (then_keyword | terms) >> stmts.as(:of_body)).repeat(1) >>
        (else_keyword >> stmts.as(:else_body)).maybe).as(:case_statement)
    end

    rule(:lambda_stmt)              do
      (bparam >> stmts.as(:body) >> end_keyword).as(:lambda_statement)
    end

    rule(:assign_stmt)              do
      (ident.as(:target) >> blanked('=') >> expr.as(:value)).as(:assign_statement)
    end

    rule(:return_stmt)              do
      (return_keyword >> blank? >> args(expr).maybe).as(:return_statement)
    end

    rule(:break_stmt)               do
      (break_keyword).as(:break_statement)
    end

    rule(:continue_stmt)            do
      (continue_keyword).as(:continue_statement)
    end

    rule(:include_stmt)             do
      (include_keyword >> ident).as(:include_statement)
    end

    rule(:extend_stmt)              do
      (extend_keyword >> ident).as(:include_statement)
    end

    rule(:stmt)                     do
      return_stmt | break_stmt | continue_stmt | expr
    end

    rule(:stmt_list)                do
      stmt >> (terms >> blank? >> stmt).repeat
    end

    rule(:stmts)                    do
      stmt_list.maybe >> terms.repeat >> blank?
    end

    rule(:module_decl)              do
      (export_keyword.maybe >> module_keyword >> ident.as(:name) >>
        blank? >> decls.as(:body) >> end_keyword).as(:module_declaration)
    end

    rule(:class_decl)              do
      (export_keyword.maybe >> class_keyword >> ident.as(:name) >>
        (str('>') >> ident.as(:parent)) >> blank? >> decls.as(:body) >> end_keyword).as(:class_declaration)
    end

    rule(:import_decl)              do
      (import_keyword >> ident.as(:module)).as(:import_declaration)
    end

    rule(:def_decal)                do
      (export_keyword.maybe >> def_keyword >> ident >>
        str('(') >> blanked? >> f_args >> blanked? >> str(')') >> stmts >> end_keyword).as(:def_declaration)
    end

    rule(:decal)                    do
      module_decl | class_decl | import_decl | def_decal | stmts
    end

    rule(:decal_list)                do
      decal >> (terms >> blank? >> decal).repeat
    end

    rule(:decals)                    do
      decal_list.maybe >> terms.repeat >> blank?
    end

    def self.keywords(*names)
      names.each do |name|
        rule("#{name}_keyword") { str(name.to_s) >> space? }
      end
    end

    keywords :break, :case, :class, :const, :continue, :def, :do, :elif, :else,
        :end, :export, :extend, :for, :if, :import, :include, :module, :of,
        :return, :then, :until, :unless, :while

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
          rule(name) { str(symbol).as(:operator) >> space? }
        else
          pattern = "[#{Regexp.escape(trailing.join)}]"

          rule(name) {
            (str(symbol) >> match(pattern).absent?).as(:operator) >> space?
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
  require 'pp'
  pp Parser.new.stmt.parse('a = b = if empty? then true else false end')
end

