require 'parslet'

module SLang
  class Parslet::Context
    def transform_call(t, obj)
      if t[:name].kind_of? Call
        t[:name].obj = obj
      else
        t[:name] = Call.new(t[:name], [], obj)
      end

      if t[:call]
        t[:call] = transform_call(t[:call], t[:name])
      end
      t[:call] ? t[:call] : t[:name]
    end
  end

  class Transform < Parslet::Transform
    rule(:integer           => simple(:t))  { NumberLiteral.new(t.to_s.to_i(0)) }
    rule(:float             => simple(:t))  { NumberLiteral.new(t.to_s.to_f) }
    rule(:bool              => simple(:t))  { BoolLiteral.new(t.to_s == 'true') }
    rule(:nil               => simple(:t))  { NilLiteral.new }
    rule(:string            => simple(:t))        do
      StringLiteral.new t.to_s
    end
    rule(:array             => subtree(:t)) { ArrayLiteral.new t }
    rule(:const             => simple(:t))  { Const.new(t) }
    rule(:class_var         => simple(:t))  { ClassVar.new(t.to_s.gsub(/^@@/, '')) }
    rule(:instance_var      => simple(:t))  { Member.new(t.to_s.gsub(/^@/, '')) }
    rule(:variable          => simple(:t))  { Variable.new(t) }
    rule(:unary_operation   => subtree(:t)) do
      if t[:operand].is_a?(NumberLiteral) && (t[:operator] == '++' || t[:operator] == '--')
        NumberLiteral.new(t[:operand].value + 1)
      else
        Call.new(t[:operator], [], t[:operand])
      end
    end
    rule(:array_set_expr    => subtree(:t)) { ArraySet.new(t[:target], t[:index], t[:value]) }
    rule(:array_get_expr    => subtree(:t)) { ArrayGet.new(t[:target], t[:index]) }
    rule(:binary_operation  => subtree(:t))       do
      if t[:right].is_a? Call
        call = t[:right]
        if Parser.operator?(call.name) && Parser.high_priority?(t[:operator].to_sym, call.name)
          t[:left] = Call.new(t[:operator], [call.obj], t[:left])
          t[:right] = call.args.first
          t[:operator] = call.name
        end
      end
      Call.new(t[:operator], [t[:right]], t[:left])
    end
    rule(:negative_expr     => subtree(:t)) { Call.new('-',[t], NumberLiteral.new(0)) }
    rule(:access_expr       => subtree(:t))       do
      transform_call(t[:call], t[:obj])
    end

    rule(:if_stmt      => subtree(:t))       do
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
    rule(:elif_stmt    => subtree(:t)) { If.new(t[:condition], t[:body]) }
    rule(:unless_stmt  => subtree(:t)) { If.new('!'.call([], t[:condition]), t[:then_body], t[:else_body]) }
    rule(:case_stmt    => subtree(:t))       do
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
    rule(:while_stmt   => subtree(:t)) { While.new(t[:condition], t[:body]) }
    rule(:until_stmt   => subtree(:t)) { While.new(Call.new(:!, [], t[:condition]), t[:body]) }
    #rule(:do_while_statement)
    #rule(:do_until_statement)
    rule(:param         => subtree(:t))     do
      type = t[:type].to_sym if t[:type]
      Parameter.new(t[:name], type)
    end
    rule(:lambda  => subtree(:t)) { Lambda.new(t[:params], t[:body]) }
    rule(:call_stmt    => subtree(:t)) { Call.new(t[:name], t[:args]) }
    rule(:assign_stmt  => subtree(:t)) { Assign.new(t[:target], t[:value]) }
    rule(:return_stmt  => subtree(:t)) { Return.new(t[:args]) }
    #rule(:break_stmt   => subtree(:t)) { }
    #rule(:continue_stmt)
    rule(:include_stmt => subtree(:t)) { Include.new(t[:args].map(&:name)) }
    #rule(:extend_stmt)
    rule(:module_decl => subtree(:t))     do
      body = t[:body]
      mod = Module.new(t[:name].name, body)
      if body.kind_of? Expressions
        body.each do |child|
          child.receiver = mod if child.is_a? Function
        end
      elsif body.is_a? Function
        body.receiver = mod
      end
      mod
    end
    rule(:class_decl => subtree(:t))     do
      body = t[:body]
      parent = t[:parent] ? t[:parent].name : :Object
      clazz = ClassDef.new(t[:name].name, t[:body], parent)
      if body.kind_of? Expressions
        body.each do |child|
          child.receiver = clazz if child.is_a? Function
        end
      elsif body.is_a? Function
        body.receiver = clazz
      end
      clazz
    end
    # rule(:import_decl)
    rule(:def_decl       => subtree(:t)) do
      return_type = t[:return_type].to_sym if t[:return_type]
      Function.new(t[:name], t[:params], t[:body], return_type)
    end
    rule(:external_decl  => subtree(:t)) do
      External.new(t[:name], nil, t[:params], t[:return_type].to_sym)
    end
    rule(:operator_decl  => subtree(:t)) do
      Operator.new(t[:name], nil, t[:params], t[:return_type].to_sym)
    end
    rule(:stmts          => subtree(:t)) { Expressions.from(t) }
    rule(:decls          => subtree(:t)) { Expressions.from(t) }
  end
end