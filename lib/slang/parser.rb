require 'parslet'

module SLang
  class Parser < Parslet::Parser
    rule(:digit)            { match '[0-9]' }

    rule(:integer)          do
      str('-').maybe >> match('[1-9]') >> digit.repeat
    end

    rule(:float)            do
      str('-').maybe >> digit.repeat(1) >> str('.') >> digit.repeat(1)
    end

    rule(:boolean)          do
      str('true') | str('false')
    end

    rule(:string_special)   { match['\0\t\n\r"\\\\'] }
    rule(:escaped_special)  { str("\\") >> match['0tnr"\\\\'] }
    rule(:string)           do
      str('"') >>
          (escaped_special | string_special.absent? >> any).repeat >>
          str('"')
    end

    rule(:literal)          do
      integer | float | boolean | string
    end
  end

end