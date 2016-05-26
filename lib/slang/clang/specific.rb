module SLang
  module CLang
    class Specific
      @@symbols = {}

      def self.symbols
        @@symbols
      end

      symbols[:+] = '__add__'
      symbols[:-] = '__sub__'
      symbols[:*] = '__mul__'
      symbols[:/] = '__div__'
      symbols[:%] = '__mod__'

      def self.convert(c)
        symbols[c.to_sym] || c
      end
    end
  end
end