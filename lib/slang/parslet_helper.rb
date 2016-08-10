require 'parslet'

module SLang
  class IgnoreParslet < Parslet::Atoms::Base
    def initialize(parslet)
      @parslet = parslet
    end
    def to_s_inner(prec)
      @parslet.to_s(prec)
    end
    def try(source, context, consume_all)
      success, value = result = @parslet.try(source, context, consume_all)

      return succ(nil) if success
      return result
    end

  end
  module IgnoreDSL
    def ignore
      IgnoreParslet.new(self)
    end
  end

  class Parslet::Atoms::Base
    include IgnoreDSL
  end

  class Parslet::Parser
    rule(:space)            { match('[ \t]').repeat(1) }
    rule(:space?)           { space.maybe }

    def spaced(s)
      str(s) >> space?
    end

    def self.keywords(*names)
      names.each do |name|
        rule("#{name}_keyword") { str(name.to_s) >> space? }
      end

      define_method(:reserved) do
        reservd = (str(names[0].to_s) >> space?).absent?
        names[1..-1].each { |name| reservd = reservd >> (str(name.to_s) >> space?).absent? }
        reservd
      end
    end

    def self.operator?(op)
      @@operators.has_key? op
    end

    def self.high_priority?(op1, op2)
      @@operators[op1] <= @@operators[op2]
    end

    def self.operators(operators={})
      @@operators = {}
      trailing_chars = Hash.new { |hash,symbol| hash[symbol] = [] }

      operators.each_value do |s|
        operators.each_value do |op|
          symbol = s.first
          if op.first[0,symbol.length] == symbol
            char = op.first[symbol.length,1]

            unless (char.nil? || char.empty?)
              trailing_chars[symbol] << char
            end
          end
        end
      end

      operators.each do |name, op|
        symbol = op.first
        trailing = trailing_chars[symbol]

        if trailing.empty?
          rule(name) { str(symbol).as(:operator) >> space? }
        else
          pattern = "[#{Regexp.escape(trailing.join)}]"

          rule(name) {
            (str(symbol) >> match(pattern).absent?).as(:operator) >> space?
          }
        end
        @@operators[op.first.to_sym] = op.last
      end

      rule(:operators_name) do
        ops = operators.values
        name = str(ops[0].first)
        ops[1..-1].each { |op| name |= str(op.first) }
        name
      end
    end
  end
end
