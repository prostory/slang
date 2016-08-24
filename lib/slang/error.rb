class String
  def tab_to_space(n = 2)
    self.gsub(/\t/, ' ' * n)
  end
end

module SLang
  Location      = Struct.new(:source, :line, :column, :offset)

  class Location
    def self.from_cause(source, cause)
      line, column = cause.source.line_and_column(cause.pos)
      Location.new(source, line, column, 1)
    end

    def self.from_slice(source, slice)
      line, column = slice.line_and_column
      offset = slice.size
      Location.new(source, line, column, offset)
    end

    def locate
      str = "at line #{line} column #{column}"
      str << "\n\t"
      str << source.lines.at(line - 1).chomp
      str << "\n\t"
      str << (' ' * (column - 1))
      str << '^'
      str << ('~' * (offset - 1))
    end
  end

  class Error < StandardError
    def initialize(message, location)
      str ="\n#{message} #{location.locate}"
      super(str)
    end
  end

  ParseError    = Class.new Error
  CompileError  = Class.new Error
end