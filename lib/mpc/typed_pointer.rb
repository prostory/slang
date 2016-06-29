module FFI
  class TypedPointer < ManagedStruct
    ##
    # Set the "type" of the value
    def self.type(kind)
      layout :value, kind
    end
    ##
    # Give access to that value
    def value
      self[:value]
    end
    ##
    # Alias value as deref so this can be treated like a pointer
    alias_method :deref, :value
    ##
    # A float-typed pointer
    class Float < TypedPointer
      type :float
    end

    # Int-typed pointer
    class Int < TypedPointer
      type :int
    end

    ##
    # UInt16 typed pointer
    class UInt16 < TypedPointer
      type :uint16
    end
    ##
    # UInt32 typed pointer
    class UInt32 < TypedPointer
      type :uint32
    end
    ##
    # Uint8 typed pointer
    class UInt8 < TypedPointer
      type :uint8
    end
    ##
    # Pointer typed pointer
    class Pointer < TypedPointer
      type :pointer
    end
  end
end