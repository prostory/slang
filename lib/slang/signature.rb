module SLang
  class Signature
    attr_accessor :types

    def initialize(types = [])
      @types = types
    end

    def child_of_types?(types)
      return true if types == :VarList
      return false if types.size != @types.size

      result = types.each_with_index do |type, idx|
        break unless @types[idx].child_of?(type)
      end

      return result.nil? ? false : true
    end

    def child_of?(other)
      child_of_types?(other.types)
    end

    def parent_of?(other)
      other.child_of_types?(types)
    end

    def hash
      types.hash
    end

    def eql?(other)
      other.types == types
    end

    def <=>(other)
      if eql?(other)
        0
      elsif child_of?(other)
        -1
      else
        1
      end
    end

    def to_s
      types.join ', '
    end
  end

  class VarListSignature < Signature
    def initialize
      @types = :VarList
    end

    def child_of_types?(types)
      false
    end
  end
end