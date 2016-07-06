require 'parslet'

require 'pp'

module SLang
  class Transform < Parslet::Transform
    rule(:integer           => simple(:t))  { NumberLiteral.new(t.to_i) }
    rule(:float             => simple(:t))  { NumberLiteral.new(t.to_f) }
    rule(:bool              => simple(:t))  { BoolLiteral.new(t == 'true') }
    rule(:nil               => simple(:t))  { NilLiteral.new }
    rule(:string            => simple(:t))        do
      StringLiteral.new t.to_s.gsub(/\\[0tnr]/,
                                    "\\0" => "\0",
                                    "\\t" => "\t",
                                    "\\n" => "\n",
                                    "\\r" => "\r")
    end
    rule(:array             => subtree(:t))  { ArrayLiteral.new t }
  end
end