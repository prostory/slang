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
      symbols[:>] = '__gt__'
      symbols[:<] = '__lt__'
      symbols[:>=] = '__ge__'
      symbols[:<=] = '__le__'
      symbols[:==] = '__eq__'
      symbols[:!=] = '__ne__'
      symbols[:<<] = '__lsh__'
      symbols[:>>] = '__rsh__'
      symbols[:&] = '__band__'
      symbols[:|] = '__bor__'
      symbols[:^] = '__xor__'
      symbols['+='.to_sym] = '__add_asgn__'
      symbols['-='.to_sym] = '__sub_asgn__'
      symbols[:[]=] = '__set__'
      symbols[:[]] = '__get__'

      def self.convert(s)
        symbols[s.to_sym] || s
      end
    end
  end
end