require_relative 'parslet_helper'
require 'pp'

module SLang
  class Parser < Parslet::Parser
    rule(:newline)          { str("\n") }
    rule(:comment)          { str('#') >> (newline.absent? >> any).repeat }
    rule(:blank)            { (match('[ \t\n]')| (comment >> newline)).repeat(1) }
    rule(:blank?)           { blank.maybe }
    rule(:eol)              { (match('[;\n]') >> space?).repeat(1) }
    rule(:terms)            { ((match('[;\n]') | (comment >> newline)) >> space?).repeat(1) }

    rule(:lparen)           { str('(') >> space? }
    rule(:rparen)           { str(')') >> space? }
    rule(:lbrack)           { str('[') >> space? }
    rule(:rbrack)           { str(']') >> space? }
    rule(:lbrace)           { str('{') >> space? }
    rule(:rbrace)           { str('}') >> space? }
    rule(:comma)            { str(',') >> space? }
    rule(:colon)            { str(':') >> space? }

    def blanked(s)
      blank? >> str(s) >> blank?
    end

    rule(:digit)            { match('[0-9]') }

    rule(:alpha)            { match('[a-zA-Z_]') }
    rule(:upper)            { match('[A-Z]') }

    rule(:bin)              { str('0b') >> match('[0-1]').repeat(1) }
    rule(:oct)              { str('0o') >> match('[0-7]').repeat(1) }
    rule(:dec)              { match('[1-9]') >> digit.repeat }
    rule(:hex)              { str('0x') >> match('[0-9a-fA-F]').repeat(1) }

    rule(:integer)          { (bin | oct | dec | hex | str('0')).as(:integer) >> space? }
    rule(:float)                do
      (digit.repeat(1) >> str('.') >> digit.repeat(1) >>
        (match('[Ee]') >> match['+-'].maybe >> digit.repeat(1)).maybe).as(:float) >> space?
    end
    rule(:bool)             { (str('true') | str('false')).as(:bool) >> space? }
    rule(:null)             { str('nil').as(:nil) >> space? }
    rule(:string_special)   { match['\0\t\n\r"\\\\'] }
    rule(:escaped_special)  { str("\\") >> match['0tnr"\\\\'] }
    rule(:string)               do
      (str('"') >>
        (escaped_special | string_special.absent? >> any).repeat >>
        str('"')).as(:string) >> space?
    end

    def args(arg)
      (arg) >> (blanked(',') >> (arg)).repeat >> blanked(',').maybe
    end

    rule(:array)                do
      (blanked('[') >> args(expr).maybe >> blank? >> str(']')).as(:array) >> space?
    end

    rule(:hash)                 do
      (blanked('{') >> args(entry).maybe >> blank? >> str('}')).as(:hash) >> space?
    end

    rule(:entry)                do
      ((ident.as(:key) >> colon) | (expr.as(:key) >> spaced('=>'))) >> expr.as(:value)
    end
    
    def type(name = nil)
      name ||= :type
      (upper >> (alpha | digit).repeat).as(name) >> space?
    end
    
    rule(:param)                do
      (name >> (spaced(':') >> type).maybe).as(:param)
    end

    rule(:params)               do
      (param >> (blanked(',') >> param).repeat).as(:params)
    end
    
    def return_type
      spaced(':') >> type(:return_type)
    end

    rule(:bparam)               do
      (params | (lparen >> params.maybe >> rparen)).maybe >> return_type.maybe >> op_rasgn
    end

    rule(:lambda)               do
      ((bparam | op_rasgn) >> blank? >> stmts.as(:body) >> end_keyword).as(:lambda)
    end

    rule(:literal)          { float | integer | bool | null | string | array | hash | lambda }

    rule(:ident)                do
      reserved >>
        (alpha >> (alpha | digit).repeat >> match['?!'].maybe).as(:ident) >> space?
    end

    rule(:name)                 do
      reserved >>
        (alpha >> (alpha | digit).repeat >> (match['?!'] | (space?.ignore >> str('=')).maybe)).as(:name)
    end

    rule(:opt_name)			        do
      name | operators_name.as(:name)
    end

    rule(:const)                do
      (upper >> (alpha | digit).repeat).as(:const) >> space?
    end

    rule(:special_call)         do
      (alpha >> (alpha | digit).repeat >> match['?!']).as(:call_stmt) >> space?
    end

    rule(:variable)             do
      reserved >> (alpha >> (alpha | digit).repeat).as(:variable) >> space?
    end

    rule(:instance_var)         do
      (str('@') >> alpha >> (alpha | digit).repeat).as(:instance_var) >> space?
    end

    rule(:class_var)            do
      (str('@@') >> alpha >> (alpha | digit).repeat).as(:class_var) >> space?
    end

    rule(:var)              { const | variable | instance_var | class_var }

    rule(:primary)          { literal | if_stmt | unless_stmt | case_stmt | while_stmt | until_stmt | do_while_stmt | do_until_stmt | block_stmt |
      assign_stmt | include_stmt | extend_stmt | cast_stmt | call_stmt | negative_expr | special_call | var | lparen >> expr >> rparen }

    rule(:factor)           { array_set_expr | array_get_expr | access_expr | unary_operation | primary }

    rule(:expr)             { binary_operation | factor }

    rule(:prefix_operation)     do
      (op_not | op_inverse) >> factor.as(:operand)
    end

    rule(:postfix_operation)    do
      (prefix_operation | primary).as(:operand) >> (op_inc | op_dec)
    end

    rule(:unary_operation)      do
      ((prefix_operation | postfix_operation)).as(:unary_operation)
    end

    rule(:binary_operation)     do
      (factor.as(:left) >> (op_rshift_assign | op_lshift_assign | op_add_assign | op_sub_assign | op_mul_assign | op_div_assign |
        op_mod_assign | op_band_assign | op_xor_assign | op_bor_assign | op_and | op_or | op_le | op_ge | op_lt | op_gt | op_eq |
        op_ne | op_add | op_sub | op_mul | op_div | op_mod | op_band | op_xor | op_bor | op_lshift | op_rshift) >> expr.as(:right)).as(:binary_operation)
    end
    rule(:negative_expr)    { (str('-') >> factor).as(:negative_expr) }

    rule(:access_expr)          do
      (primary.as(:obj) >> access_expr0).as(:access_expr)
    end

    rule(:access_expr0)         do
      (str('.') >> opt_name >> (call_args | space).maybe >> access_expr0.maybe).as(:call)
    end

    rule(:pick_expr)            do
      (access_expr | primary).as(:target) >> pick_expr0
    end

    rule(:pick_expr0)           do
      (lbrack >> expr.as(:index) >> rbrack >> pick_expr0.maybe).as(:pick)
    end

    rule(:array_set_expr)       do
      (pick_expr >> spaced('=') >> expr.as(:value)).as(:array_set_expr)
    end

    rule(:array_get_expr)       do
      pick_expr.as(:array_get_expr)
    end

    rule(:cast_stmt)            do
      (cast_keyword >> lparen >> const.as(:type) >> comma >> expr.as(:value) >> rparen).as(:cast_stmt)
    end
    
    rule(:block_stmt)           do
      (begin_keyword >> stmts.as(:body) >> end_keyword).as(:block_stmt)
    end

    rule(:if_stmt)              do
      (if_keyword >> expr.as(:condition) >> (then_keyword | terms) >> stmts.as(:then_body) >> elif_stmt.repeat >>
          (else_keyword >> stmts.as(:else_body)).maybe >> end_keyword).as(:if_stmt)
    end

    rule(:elif_stmt)            do
      (elif_keyword >> expr.as(:condition) >> (then_keyword | terms) >> stmts.as(:body)).as(:elif_stmt)
    end

    rule(:unless_stmt)          do
      (unless_keyword >> expr.as(:condition) >> (then_keyword | terms) >> stmts.as(:then_body) >>
          (else_keyword >> stmts.as(:else_body)).maybe >> end_keyword).as(:unless_stmt)
    end

    rule(:case_stmt)            do
      (case_keyword >> expr >> blank? >> of_stmt.repeat(1) >>
          (else_keyword >> stmts.as(:else_body)).maybe >> end_keyword).as(:case_stmt)
    end

    rule(:of_stmt)              do
      of_keyword >> args(expr).as(:match) >> (then_keyword | terms) >> stmts.as(:of_body)
    end
    
    rule(:while_stmt)				    do
	    (while_keyword >> expr.as(:condition) >> (do_keyword | terms) >> stmts.as(:body) >> end_keyword).as(:while_stmt)
    end

    rule(:until_stmt)				    do
      (until_keyword >> expr.as(:condition) >> (do_keyword | terms) >> stmts.as(:body) >> end_keyword).as(:until_stmt)
    end
    
    rule(:do_while_stmt)			  do
	    (do_keyword >> blank? >> stmts.as(:body) >> while_keyword >> expr.as(:condition) >> end_keyword).as(:do_while_stmt)
    end

    rule(:do_until_stmt)			  do
      (do_keyword >> blank? >> stmts.as(:body) >> until_keyword >> expr.as(:condition) >> end_keyword).as(:do_until_stmt)
    end
    
    rule(:call_args)            do
      (spaced('(') >> blank? >> args(expr).maybe.as(:args) >> blank? >> spaced(')')) | space >> args(expr).as(:args)
    end

    rule(:call_stmt)            do
       (name >> call_args).as(:call_stmt)
    end

    rule(:assign_stmt)          do
      (var.as(:target) >> spaced('=') >> expr.as(:value)).as(:assign_stmt)
    end

    rule(:return_stmt)          do
      (return_keyword >> args(expr).maybe.as(:args)).as(:return_stmt)
    end

    rule(:break_stmt)           do
      (break_keyword).as(:break_stmt)
    end

    rule(:continue_stmt)        do
      (continue_keyword).as(:continue_stmt)
    end

    rule(:include_stmt)         do
      (include_keyword >> args(const).as(:args)).as(:include_stmt)
    end

    rule(:extend_stmt)          do
      (extend_keyword >> args(const).as(:args)).as(:extend_stmt)
    end

    rule(:null_stmt)            do
      space | (space? >> comment)
    end

    rule(:single_if_stmt)       do
      ((return_stmt | break_stmt | continue_stmt | expr).as(:body) >>
        if_keyword >> expr.as(:condition)).as(:single_if_stmt)
    end

    rule(:single_unless_stmt)   do
      ((return_stmt | break_stmt | continue_stmt | expr).as(:body) >>
        unless_keyword >> expr.as(:condition)).as(:single_unless_stmt)
    end

    rule(:stmt)                 do
      single_if_stmt | single_unless_stmt | return_stmt | break_stmt | continue_stmt | null_stmt | expr
    end

    rule(:stmts)                do
      (stmt.maybe >> (eol >> stmt.maybe).repeat).as(:stmts)
    end

    rule(:module_decl)          do
      (export_keyword.maybe >> module_keyword >> const.as(:name) >>
        blank? >> decls.as(:body) >> end_keyword).as(:module_decl)
    end

    rule(:class_decl)           do
      (export_keyword.maybe >> class_keyword >> const.as(:name) >>
        (spaced('<') >> const.as(:parent)).maybe >> blank? >> decls.as(:body) >> end_keyword).as(:class_decl)
    end

    rule(:import_decl)          do
      (import_keyword >> ident.as(:path)).as(:import_decl)
    end

    rule(:def_params)				    do
      (space >> params | (space? >> lparen >> params.maybe >> rparen)).maybe
    end

    rule(:fun_params)				    do
      space? >> lparen >> args(type(:type).as(:param)).as(:params).maybe >> rparen
    end

    rule(:def_decl)             do
      (export_keyword.maybe >> def_keyword >> opt_name >>
        def_params >> return_type.maybe >> terms >> stmts.as(:body) >> end_keyword).as(:def_decl)
    end

    rule(:external_decl)        do
      (external_keyword >> name >> fun_params >> return_type).as(:external_decl)
    end

    rule(:operator_decl)        do
      (operator_keyword >> operators_name.as(:name) >> fun_params >> return_type).as(:operator_decl)
    end

    rule(:decl)                 do
      module_decl | class_decl | import_decl | def_decl | external_decl | operator_decl | stmt
    end

    rule(:decls)                do
      (decl.maybe >> (eol >> decl.maybe).repeat).as(:decls)
    end

    keywords :begin, :break, :case, :cast, :class, :const, :continue, :def, :do, :elif, :else,
        :end, :export, :extend, :external, :for, :if, :import, :include, :module, :of, :operator,
        :return, :then, :until, :unless, :while

    operators :op_rshift_assign => ['>>=', 14],
        :op_lshift_assign => ['<<=', 14],
        :op_add_assign => ['+=', 14],
        :op_sub_assign => ['-=', 14],
        :op_mul_assign => ['*=', 14],
        :op_div_assign => ['/=', 14],
        :op_mod_assign => ['%=', 14],
        :op_band_assign => ['&=', 14],
        :op_xor_assign => ['^=', 14],
        :op_bor_assign => ['|=', 14],
        :op_inc => ['++', 1],
        :op_dec => ['--', 1],
        :op_rasgn => ['->', 1],
        :op_and => ['&&', 11],
        :op_or => ['||', 12],
        :op_le => ['<=', 6],
        :op_ge => ['>=', 6],
        :op_eq => ['==', 7],
        :op_ne => ['!=', 7],
        :op_add => ['+', 4],
        :op_sub => ['-', 4],
        :op_mul => ['*', 3],
        :op_div => ['/', 3],
        :op_mod => ['%', 3],
        :op_lt => ['<', 6],
        :op_gt => ['>', 6],
        :op_not => ['!', 2],
        :op_bor => ['|', 10],
        :op_band => ['&', 8],
        :op_xor => ['^', 9],
        :op_lshift => ['<<', 5],
        :op_rshift => ['>>', 5],
        :op_inverse => ['~', 2],
        :op_ary_set => ['[]=', 14],
        :op_ary_get => ['[]', 1]

     root :decls
  end

end

