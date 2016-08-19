require 'parslet'
require 'pp'
require_relative 'ast'
require_relative 'parser'

module SLang
  class Parslet::Context
    def transform_call(t, obj)
      t[:name] = Call.new(t[:name], t[:args], obj)

      if t[:call]
        t[:call] = transform_call(t[:call], t[:name])
      end
      t[:call] ? t[:call] : t[:name]
    end
  end
  
  class ASTNode
    attr_accessor :primary
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
    rule(:top_const         => subtree(:t)) { Const.new(t, Const.new(:Main))}
    rule(:const_chain       => subtree(:t))       do
      target = t[0]
      t[1..-1].each do |const|
        const.target = target
        target = const
      end
      t.last
    end
    rule(:class_var         => subtree(:t)) { ClassVar.new(t[:name].to_s.gsub(/^@@/, ''), t[:type]) }
    rule(:instance_var      => subtree(:t)) { Member.new(t[:name].to_s.gsub(/^@/, ''), t[:type]) }
    rule(:variable          => subtree(:t)) { Variable.new(t[:name], t[:type]) }
    rule(:primary           => subtree(:t)) { t.primary = true; t }
    rule(:unary_operation   => subtree(:t))       do
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
        right = call
        while call.is_a?(Call) && !call.primary
          right = call
          call = call.obj
        end
        if !right.primary && Parser.operator?(right.name) && Parser.high_priority?(t[:operator].to_sym, right.name)
          right.obj = Call.new(t[:operator], [right.obj], t[:left])
          t[:right]
        else
          Call.new(t[:operator], [t[:right]], t[:left])   
        end
      else
        Call.new(t[:operator], [t[:right]], t[:left])   
      end
    end
    rule(:negative_expr     => subtree(:t)) { Call.new('-', [], t) }
    rule(:access_expr       => subtree(:t)) { transform_call(t[:call], t[:obj]) }
    rule(:cast_stmt         => subtree(:t)) { Cast.new(t[:type], t[:value])}
    rule(:block_stmt        => subtree(:t)) { Do.from(t[:body]) }
    rule(:if_stmt           => subtree(:t))       do
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
    rule(:elif_stmt         => subtree(:t)) { If.new(t[:condition], t[:body]) }
    rule(:unless_stmt       => subtree(:t)) { If.new(Call.new('!', [], t[:condition]), t[:then_body], t[:else_body]) }
    rule(:single_if_stmt    => subtree(:t)) { If.new(t[:condition], t[:body]) }
    rule(:single_unless_stmt=> subtree(:t)) { If.new(Call.new('!', [], t[:condition]), t[:body]) }
    rule(:case_stmt         => subtree(:t))       do
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
    rule(:while_stmt        => subtree(:t)) { While.new(t[:condition], t[:body]) }
    rule(:until_stmt        => subtree(:t)) { While.new(Call.new(:!, [], t[:condition]), t[:body]) }
    rule(:do_while_stmt     => subtree(:t)) { DoWhile.new(t[:condition], t[:body]) }
    rule(:do_until_stmt     => subtree(:t)) { DoWhile.new(Call.new(:!, [], t[:condition]), t[:body]) }
    rule(:param             => subtree(:t))     do
      type = t[:type].to_sym if t[:type]
      Parameter.new(t[:name], type)
    end
    rule(:lambda            => subtree(:t)) { Lambda.new(t[:params], t[:body]) }
    rule(:call_stmt         => subtree(:t)) { Call.new(t[:name], t[:args]) }
    rule(:assign_stmt       => subtree(:t)) { Assign.new(t[:target], t[:value]) }
    rule(:return_stmt       => subtree(:t)) { Return.new(t[:args]) }
    #rule(:break_stmt   => subtree(:t)) { }
    #rule(:continue_stmt)
    rule(:include_stmt      => subtree(:t)) { Include.new(t[:args].map(&:name)) }
    #rule(:extend_stmt)
    rule(:module_decl       => subtree(:t))     do
      Module.new(t[:name], t[:body])
    end
    rule(:class_decl        => subtree(:t))     do
      ClassDef.new(t[:name], t[:body], t[:parent] || Const.new(:Object))
    end
    # rule(:import_decl)
    rule(:def_decl          => subtree(:t))     do
      return_type = t[:return_type].to_sym if t[:return_type]
      Function.new(t[:name], t[:params], t[:body], return_type, t[:owner])
    end
    rule(:external_decl     => subtree(:t))     do
      return_type = t[:return_type].to_sym if t[:return_type]
      External.new(t[:name], nil, t[:params], return_type, t[:owner])
    end
    rule(:operator_decl     => subtree(:t))     do
      return_type = t[:return_type].to_sym if t[:return_type]
      Operator.new(t[:name], nil, t[:params], return_type, t[:owner])
    end
    rule(:stmts             => subtree(:t))     do
      if t.is_a?(String) && t.empty?
        Expressions.from(nil)
      else
        Expressions.from(t)
      end
    end
    rule(:decls             => subtree(:t))     do
      if t.is_a?(String) && t.empty?
        Expressions.from(nil)
      else
        Expressions.from(t)
      end
    end
  end

  def self.parse(source)
    parser = Parser.new
    input = parser.parse(source)
    Transform.new.apply input
  rescue Parslet::ParseFailed => failure
    puts failure.cause.ascii_tree
  end
end
