require 'parslet'

module SLang
  class Transform < Parslet::Transform
    rule(:integer           => simple(:t))  { NumberLiteral.new(t.to_i) }
    rule(:float             => simple(:t))  { NumberLiteral.new(t.to_f) }
    rule(:bool              => simple(:t))  { BoolLiteral.new(t == 'true') }
    rule(:nil               => simple(:t))  { NilLiteral.new }
    rule(:string            => simple(:t))        do
      StringLiteral.new t.to_s
    end
    rule(:array             => subtree(:t)) { ArrayLiteral.new t }
    rule(:const             => simple(:t))  { Const.new(t) }
    rule(:class_var         => simple(:t))  { ClassVar.new(t.gsub(/^@@/, '')) }
    rule(:instance_var      => simple(:t))  { Member.new(t.gsub(/^@/, '')) }
    rule(:ident             => simple(:t))  { Variable.new(t) }
    rule(:unary_operation   => subtree(:t)) { Call.new(t[:operator], [], t[:operand]) }
    rule(:binary_operation  => subtree(:t))       do
      if t[:operator] == '.'
        if t[:right].is_a?(Variable)
          t[:right] = Call.new(t[:right].name)
        end
        t[:right].obj = t[:left]
        t[:right]
      else
        Call.new(t[:operator], [t[:right]], t[:left])
      end
    end
    rule(:negative_expr     => subtree(:t)) { Call.new('-',[t], NumberLiteral.new(0)) }
    rule(:if_statement      => subtree(:t))       do
      if t.is_a?(Array)
        if t.length > 1
          i = 1
          while i < t.length-1
            t[i].else = t[i+1].is_a?(If) ? t[i+1] : t[i+1][:else_body] if t[i].is_a? If
            i += 1
          end
          else_body = t[1].is_a?(If) ? t[1] : t[1][:else_body]
        end
        If.new(t.first[:condition], t.first[:then_body], else_body)
      else
        If.new(t[:condition], t[:then_body], t[:else_body])
      end
    end
    rule(:elif_statement    => subtree(:t)) { If.new(t[:condition], t[:body]) }
    rule(:unless_statement  => subtree(:t)) { If.new('!'.call([], t[:condition]), t[:then_body], t[:else_body]) }
    rule(:case_statement    => subtree(:t))       do
      var = t.first
      i = 1
      result = nil
      last_match = nil
      while i < t.length
        match = t[i][:match]
        if match
          body = t[i][:of_body]
          if match.is_a? Array
            match = match.map {|m| If.new(Call.new('==', [m], var), body) }
            match[0..-2].each_with_index { |s, i| s.else = match[i+1] }
            last_match.else = match.first if last_match
            last_match = match.last
            result = match.first if result.nil?
          else
            match = If.new(Call.new('==', [match], var), body)
            last_match.else = match if last_match
            last_match = match
            result = last_match if result.nil?
          end
        else
          last_match.else = t[i][:else_body]
        end
        i += 1
      end
      result
    end
    rule(:while_statement   => subtree(:t)) { While.new(t[:condition], t[:body]) }
    rule(:until_statement   => subtree(:t)) { While.new('!'.call([], t[:condition]), t[:body]) }
    #rule(:do_while_statement)
    #rule(:do_until_statement)
    rule(:parameter         => subtree(:t)) { Parameter.new(t[:name], t[:type]) }
    rule(:lambda_statement  => subtree(:t)) { Lambda.new(t[:params], t[:body]) }
    rule(:call_statement    => subtree(:t)) { Call.new(t[:name], t[:args]) }
    rule(:assign_statement  => subtree(:t)) { Assign.new(t[:target], t[:value]) }
    rule(:return_statement  => subtree(:t)) { Return.new(t[:args]) }
    #rule(:break_statement   => subtree(:t)) { }
    #rule(:continue_statement)
    rule(:include_statement => subtree(:t)) { Include.new(t[:args].map(&:name)) }
    #rule(:extend_statement)
    rule(:module_declaration=> subtree(:t))     do
      body = t[:body]
      mod = Module.new(t[:name], body)
      if body.kind_of? Array
        body.each do |child|
          child.receiver = mod if child.is_a? Function
        end
      elsif body.is_a? Function
        body.receiver = mod
      end
      mod
    end
    rule(:class_declaration => subtree(:t))     do
      body = t[:body]
      parent = t[:parent]
      clazz = ClassDef.new(t[:name], t[:body], parent && parent[:name])
      if body.kind_of? Array
        body.each do |child|
          child.receiver = clazz if child.is_a? Function
        end
      elsif body.is_a? Function
        body.receiver = clazz
      end
      clazz
    end
    # rule(:import_declaration)
    rule(:def_declaration       => subtree(:t)) { Function.new(t[:name], t[:params], t[:body]) }
    rule(:external_declaration  => subtree(:t)) { External.new(t[:name], nil, t[:params]) }
    rule(:operator_declaration  => subtree(:t)) { Operator.new(t[:name], nil, t[:params]) }
  end
end