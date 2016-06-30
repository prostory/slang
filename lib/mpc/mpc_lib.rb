require 'ffi'

module MPC
  extend FFI::Library
  ffi_lib ['mpc', '../vendor/mpc/libmpc.so']

  enum :default, 0,
       :predictive, 1,
       :whitespace_sensitive, 2

  # Error Type
  attach_function :mpc_err_delete, [ :pointer ], :void
  attach_function :mpc_err_string, [ :pointer ], :string
  attach_function :mpc_err_print, [ :pointer ], :void
  attach_function :mpc_err_print_to, [ :pointer, :pointer ], :void

  # Parsing
  attach_function :mpc_parse, [ :string, :string, :pointer, :pointer ], :int
  attach_function :mpc_parse_file, [ :string, :pointer, :pointer, :pointer ], :int
  attach_function :mpc_parse_pipe, [ :string, :pointer, :pointer, :pointer ], :int
  attach_function :mpc_parse_contents, [ :string, :pointer, :pointer ], :int

  # Function Types
  callback :mpc_dtor_t, [ :pointer ], :void
  callback :mpc_ctor_t, [ ], :pointer
  callback :mpc_apply_t, [ :pointer ], :pointer
  callback :mpc_apply_to_t, [ :pointer, :pointer ], :pointer
  callback :mpc_fold_t, [ :int, :pointer ], :pointer

  # Building a Parser
  attach_function :mpc_new, [ :string ], :pointer
  attach_function :mpc_define, [ :pointer, :pointer ], :pointer
  attach_function :mpc_undefine, [ :pointer ], :pointer
  attach_function :mpc_delete, [ :pointer ], :void
  attach_function :mpc_cleanup, [ :int, :varargs ], :void

  # Basic Parsers
  attach_function :mpc_any, [ :void ], :pointer
  attach_function :mpc_char, [ :char ], :pointer
  attach_function :mpc_range, [ :char, :char ], :pointer
  attach_function :mpc_oneof, [ :string ], :pointer
  attach_function :mpc_noneof, [ :string ], :pointer
  attach_function :mpc_satisfy, [ callback([:char], :int) ], :pointer
  attach_function :mpc_string, [ :string ], :pointer

  # Other Parsers
  attach_function :mpc_pass, [ ], :pointer
  attach_function :mpc_fail, [ :string ], :pointer
  attach_function :mpc_failf, [ :string, :varargs ], :pointer
  attach_function :mpc_lift, [ :mpc_ctor_t ], :pointer
  attach_function :mpc_lift_val, [ :pointer ], :pointer
  attach_function :mpc_anchor, [ callback([:char, :char], :int) ], :pointer
  attach_function :mpc_state, [  ], :pointer

  # Combinator Parsers
  attach_function :mpc_expect, [ :pointer, :string ], :pointer
  attach_function :mpc_expectf, [ :pointer, :string, :varargs ], :pointer
  attach_function :mpc_apply, [ :pointer, :mpc_apply_t ], :pointer
  attach_function :mpc_apply_to, [ :pointer, :mpc_apply_to_t, :pointer ], :pointer
  attach_function :mpc_not, [ :pointer, :mpc_dtor_t ], :pointer
  attach_function :mpc_not_lift, [ :pointer, :mpc_dtor_t, :mpc_ctor_t ], :pointer
  attach_function :mpc_maybe, [ :pointer ], :pointer
  attach_function :mpc_maybe_lift, [ :pointer, :mpc_ctor_t ], :pointer
  attach_function :mpc_many, [ :mpc_fold_t, :pointer ], :pointer
  attach_function :mpc_many1, [ :mpc_fold_t, :pointer ], :pointer
  attach_function :mpc_count, [ :int, :mpc_fold_t, :pointer, :mpc_dtor_t ], :pointer
  attach_function :mpc_or, [ :int, :varargs ], :pointer
  attach_function :mpc_and, [ :int, :mpc_fold_t, :varargs ], :pointer
  attach_function :mpc_predictive, [ :pointer ], :pointer

  # Common Parsers
  attach_function :mpc_eoi, [ ], :pointer
  attach_function :mpc_soi, [ ], :pointer

  attach_function :mpc_boundary, [ ], :pointer

  attach_function :mpc_whitespace, [ ], :pointer
  attach_function :mpc_whitespaces, [ ], :pointer
  attach_function :mpc_blank, [ ], :pointer

  attach_function :mpc_newline, [ ], :pointer
  attach_function :mpc_tab, [ ], :pointer
  attach_function :mpc_escape, [ ], :pointer

  attach_function :mpc_digit, [ ], :pointer
  attach_function :mpc_hexdigit, [ ], :pointer
  attach_function :mpc_octdigit, [ ], :pointer
  attach_function :mpc_digits, [ ], :pointer
  attach_function :mpc_hexdigits, [ ], :pointer
  attach_function :mpc_octdigits, [ ], :pointer

  attach_function :mpc_lower, [ ], :pointer
  attach_function :mpc_upper, [ ], :pointer
  attach_function :mpc_alpha, [ ], :pointer
  attach_function :mpc_underscore, [ ], :pointer
  attach_function :mpc_alphanum, [ ], :pointer

  attach_function :mpc_int, [ ], :pointer
  attach_function :mpc_hex, [ ], :pointer
  attach_function :mpc_oct, [ ], :pointer
  attach_function :mpc_number, [ ], :pointer

  attach_function :mpc_real, [ ], :pointer
  attach_function :mpc_float, [ ], :pointer

  attach_function :mpc_char_lit, [ ], :pointer
  attach_function :mpc_string_lit, [ ], :pointer
  attach_function :mpc_regex_lit, [ ], :pointer

  attach_function :mpc_ident, [ ], :pointer

  # Useful Parsers
  attach_function :mpcf_dtor_null, [ :pointer ], :void

  attach_function :mpcf_ctor_null, [  ], :pointer
  attach_function :mpcf_ctor_str, [  ], :pointer

  attach_function :mpcf_free, [ :pointer ], :pointer
  attach_function :mpcf_int, [ :pointer ], :pointer
  attach_function :mpcf_hex, [ :pointer ], :pointer
  attach_function :mpcf_oct, [ :pointer ], :pointer
  attach_function :mpcf_float, [ :pointer ], :pointer
  attach_function :mpcf_strtriml, [ :pointer ], :pointer
  attach_function :mpcf_strtrimr, [ :pointer ], :pointer
  attach_function :mpcf_strtrim, [ :pointer ], :pointer

  attach_function :mpcf_escape, [ :pointer ], :pointer
  attach_function :mpcf_escape_regex, [ :pointer ], :pointer
  attach_function :mpcf_escape_string_raw, [ :pointer ], :pointer
  attach_function :mpcf_escape_char_raw, [ :pointer ], :pointer

  attach_function :mpcf_unescape, [ :pointer ], :pointer
  attach_function :mpcf_unescape_regex, [ :pointer ], :pointer
  attach_function :mpcf_unescape_string_raw, [ :pointer ], :pointer
  attach_function :mpcf_unescape_char_raw, [ :pointer ], :pointer

  attach_function :mpcf_null, [ :int, :pointer ], :pointer
  attach_function :mpcf_fst, [ :int, :pointer ], :pointer
  attach_function :mpcf_snd, [ :int, :pointer ], :pointer
  attach_function :mpcf_trd, [ :int, :pointer ], :pointer

  attach_function :mpcf_fst_free, [ :int, :pointer ], :pointer
  attach_function :mpcf_snd_free, [ :int, :pointer ], :pointer
  attach_function :mpcf_trd_free, [ :int, :pointer ], :pointer

  attach_function :mpcf_strfold, [ :int, :pointer ], :pointer
  attach_function :mpcf_maths, [ :int, :pointer ], :pointer

  # Regular Expression Parsers
  attach_function :mpc_re, [ :string ], :pointer

  attach_function :mpc_ast_new, [ :string, :string ], :pointer
  attach_function :mpc_ast_build, [ :int, :string, :varargs ], :pointer
  attach_function :mpc_ast_add_root, [ :pointer ], :pointer
  attach_function :mpc_ast_add_child, [ :pointer, :pointer ], :pointer
  attach_function :mpc_ast_add_tag, [ :pointer, :string ], :pointer
  attach_function :mpc_ast_tag, [ :pointer, :string ], :pointer
  attach_function :mpc_ast_state, [ :pointer, :pointer ], :pointer

  attach_function :mpc_ast_delete, [ :pointer ], :void
  attach_function :mpc_ast_print, [ :pointer ], :void
  attach_function :mpc_ast_print_to, [ :pointer ], :void

  attach_function :mpc_ast_eq, [ :pointer, :pointer ], :int

  attach_function :mpcf_fold_ast, [ :int, :pointer ], :pointer
  attach_function :mpcf_str_ast, [ :pointer ], :pointer
  attach_function :mpcf_state_ast, [ :int, :pointer ], :pointer

  attach_function :mpca_tag, [ :pointer, :string ], :pointer
  attach_function :mpca_add_tag, [ :pointer, :string ], :pointer
  attach_function :mpca_root, [ :pointer ], :pointer
  attach_function :mpca_state, [ :pointer ], :pointer
  attach_function :mpca_total, [ :pointer ], :pointer

  attach_function :mpca_not, [ :pointer ], :pointer
  attach_function :mpca_maybe, [ :pointer ], :pointer

  attach_function :mpca_many, [ :pointer ], :pointer
  attach_function :mpca_many1, [ :pointer ], :pointer
  attach_function :mpca_count, [ :int, :pointer ], :pointer

  attach_function :mpc_or, [ :int, :varargs ], :pointer
  attach_function :mpc_and, [ :int, :varargs ], :pointer

  attach_function :mpca_grammar, [ :int, :string, :varargs ], :pointer

  attach_function :mpca_lang, [ :int, :string, :varargs ], :pointer
  attach_function :mpca_lang_file, [ :int, :pointer, :varargs ], :pointer
  attach_function :mpca_lang_pipe, [ :int, :pointer, :varargs ], :pointer
  attach_function :mpca_lang_contents, [ :int, :string, :varargs ], :pointer

  # Misc
  attach_function :mpc_print, [ :pointer ], :void
  attach_function :mpc_optimise, [ :pointer ], :void
  attach_function :mpc_stats, [ :pointer ], :void

  attach_function :mpc_test_pass, [ :pointer, :string, :pointer, callback([:pointer, :pointer], :int), :mpc_dtor_t, callback([:pointer, :pointer], :void) ], :int
  attach_function :mpc_test_fail, [ :pointer, :string, :pointer, callback([:pointer, :pointer], :int), :mpc_dtor_t, callback([:pointer, :pointer], :void) ], :int
end
