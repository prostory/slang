require_relative 'tcc_lib'

module TCC
  module OutPutType
    MEMORY = TCC_OUTPUT_MEMORY
    EXE = TCC_OUTPUT_EXE
    DLL = TCC_OUTPUT_DLL
    OBJ = TCC_OUTPUT_OBJ
    PREPROCESS = TCC_OUTPUT_PREPROCESS
  end

  class State < FFI::ManagedStruct
    layout :handle, :pointer

    def initialize
      super(TCC.tcc_new)
    end

    def self.release
      TCC.tcc_delete self
    end

    def set_error_func(error_func, opaque = nil)
      opaque = FFI::MemoryPointer.from_string(opaque.to_s) if opaque
      TCC.tcc_set_error_func self, opaque, error_func
    end

    def set_options(str)
      TCC.tcc_set_options self, str
    end

    def add_include_path(path)
      TCC.tcc_add_include_path self, path
    end

    def add_sysinclude_path(path)
      TCC.tcc_add_sysinclude_path self, path
    end

    def define_symbol(sym, value)
      TCC.tcc_define_symbol self, sym, value
    end

    def undefine_symbol(sym)
      TCC.tcc_undefine_symbol self, sym
    end

    def add_file(file)
      TCC.tcc_add_file self, file
    end

    def compile(code)
      TCC.tcc_compile_string self, code
    end

    def output_type=(output_type)
      TCC.tcc_set_output_type self, output_type
    end

    def add_library_path(path)
      TCC.tcc_add_library_path self, path
    end

    def add_library(library)
      TCC.tcc_add_library self, library
    end

    def add_symbol(name, value)
      TCC.tcc_add_symbol self, name, value
    end

    def output_file(file)
      TCC.tcc_output_file self, file
    end

    def run(*args)
      argc = args.size
      argv = FFI::MemoryPointer.new(:pointer, argc)
      argv.write_array_of_pointer(args.map {|arg| FFI::MemoryPointer.from_string(arg.to_s)})
      TCC.tcc_run self, argc, argv
    end

    def relocate(ptr)
      TCC.tcc_relocate self, ptr
    end

    def symbol(name)
      TCC.tcc_get_symbol self, name
    end

    def add_function(name, return_type, args_type, &block)
      add_symbol(name, FFI::Function.new(return_type, args_type, &block))
    end

    def function(name, return_type, args_type)
      FFI::Function.new(return_type, args_type, symbol(state, name))
    end
  end
end
