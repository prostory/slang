require 'ffi'

module TCC
  extend FFI::Library
  ffi_lib ['tcc', '../vendor/tcc/libtcc.dll']
  TCC_OUTPUT_MEMORY = 0
  TCC_OUTPUT_EXE = 1
  TCC_OUTPUT_DLL = 2
  TCC_OUTPUT_OBJ = 3
  TCC_OUTPUT_PREPROCESS = 4

  attach_function :tcc_new, [  ], :pointer
  attach_function :tcc_delete, [ :pointer ], :void
  attach_function :tcc_set_error_func, [ :pointer, :pointer, callback([ :pointer, :string ], :void) ], :void
  attach_function :tcc_set_options, [ :pointer, :string ], :int
  attach_function :tcc_add_include_path, [ :pointer, :string ], :int
  attach_function :tcc_add_sysinclude_path, [ :pointer, :string ], :int
  attach_function :tcc_define_symbol, [ :pointer, :string, :string ], :void
  attach_function :tcc_undefine_symbol, [ :pointer, :string ], :void
  attach_function :tcc_add_file, [ :pointer, :string ], :int
  attach_function :tcc_compile_string, [ :pointer, :string ], :int
  attach_function :tcc_set_output_type, [ :pointer, :int ], :int
  attach_function :tcc_add_library_path, [ :pointer, :string ], :int
  attach_function :tcc_add_library, [ :pointer, :string ], :int
  attach_function :tcc_add_symbol, [ :pointer, :string, :pointer ], :int
  attach_function :tcc_output_file, [ :pointer, :string ], :int
  attach_function :tcc_run, [ :pointer, :int, :pointer ], :int
  attach_function :tcc_relocate, [ :pointer, :pointer ], :int
  attach_function :tcc_get_symbol, [ :pointer, :string ], :pointer
end
