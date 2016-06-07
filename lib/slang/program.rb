require_relative '../tcc/tcc'

module SLang
  class Program
    def to_clang
      prog = [:do,
              [:external, :calloc, [:Integer, :Integer], :Pointer],
              [:class, :Object, nil,
                  [:static, :__alloc__, [], [:cast, [:type], [:calloc, nil, [[:sizeof], 1]]]],
                  [:static, :new, {args: :VarList}, [[:set, :obj, [:__alloc__]], [:__init__, :obj, [:args]], [:ret, :obj]]],
                  [:fun, :__init__, [], []]
              ],
              [:class, :Integer, nil,
               [:operator, :+, [:Integer], :Integer],
               [:operator, :-, [:Integer], :Integer],
               [:operator, :*, [:Integer], :Integer],
               [:operator, :/, [:Integer], :Integer],
               [:operator, :%, [:Integer], :Integer],
               [:operator, :<<, [:Integer], :Integer],
               [:operator, :>>, [:Integer], :Integer],
               [:operator, :&, [:Integer], :Integer],
               [:operator, :|, [:Integer], :Integer],
               [:operator, :^, [:Integer], :Integer],
               [:operator, :>, [:Integer], :Bool],
               [:operator, :<, [:Integer], :Bool],
               [:operator, :>=, [:Integer], :Bool],
               [:operator, :<=, [:Integer], :Bool],
               [:operator, :==, [:Integer], :Bool],
               [:operator, :!=, [:Integer], :Bool],
               [:operator, :+, [:Float], :Float],
               [:operator, :-, [:Float], :Float],
               [:operator, :*, [:Float], :Float],
               [:operator, :/, [:Float], :Float],
               [:operator, :%, [:Float], :Float],
               [:operator, :>, [:Float], :Bool],
               [:operator, :<, [:Float], :Bool],
               [:operator, :>=, [:Float], :Bool],
               [:operator, :<=, [:Float], :Bool],
               [:operator, :==, [:Float], :Bool],
               [:operator, :!=, [:Float], :Bool],
               [:fun, :to_f, [], [:cast, :Float, :self]],
               [:fun, :to_i, [], [:ret, :self]]
              ],
              [:class, :Float, nil,
               [:operator, :+, [:Integer], :Float],
               [:operator, :-, [:Integer], :Float],
               [:operator, :*, [:Integer], :Float],
               [:operator, :/, [:Integer], :Float],
               [:operator, :%, [:Integer], :Float],
               [:operator, :>, [:Integer], :Bool],
               [:operator, :<, [:Integer], :Bool],
               [:operator, :>=, [:Integer], :Bool],
               [:operator, :<=, [:Integer], :Bool],
               [:operator, :==, [:Integer], :Bool],
               [:operator, :!=, [:Integer], :Bool],
               [:operator, :+, [:Float], :Float],
               [:operator, :-, [:Float], :Float],
               [:operator, :*, [:Float], :Float],
               [:operator, :/, [:Float], :Float],
               [:operator, :%, [:Float], :Float],
               [:operator, :>, [:Float], :Bool],
               [:operator, :<, [:Float], :Bool],
               [:operator, :>=, [:Float], :Bool],
               [:operator, :<=, [:Float], :Bool],
               [:operator, :==, [:Float], :Bool],
               [:operator, :!=, [:Float], :Bool],
               [:fun, :to_i, [], [:cast, :Integer, :self]],
               [:fun, :to_f, [], [:ret, :self]]
              ],
              [:class, :Bool, nil,
               [:operator, :'&&', [:Bool], :Bool],
               [:operator, :'||', [:Bool], :Bool],
               [:operator, :!, [:Bool], :Bool],
               [:fun, :or, [:n], [:'||', :self, [:n]]],
               [:fun, :and, [:n], [:'&&', :self, [:n]]],
               [:fun, :not, [:n], [:!, :self, [:n]]],
              ],
              [:class, :String, nil,
               [:external, :echo, :puts, [], :Integer],
               [:external, :len, :strlen, [], :Integer],
               [:external, :dup, :strdup, [], :String],
               [:external, :grow, :realloc, [:Integer], :String],
               [:external, :cat, :strcat, [:String], :String],
                  [:external, :printf, [:VarList], :Integer],
               [:fun, :<<, [:s], [[:set, :len, [:+, [:+, [:len, :self], [[:len, :s]]], [1]]],
                                  [:set, :self, [:grow, :self, [:len]]],
                                  [:cat, :self, [:s]]]]
              ],
              [:class, :A, :Object,
                [:fun, :a, [], [:echo, "hello"]],
                  [:static, :b, [], [:echo, "static hello"]],
                  [:fun, :set_id, [:n], [:set, :@a, :n]],
                  [:fun, :get_id, [], [:ret, :@a]]
              ],
              [:class, :B, :A,
                  [:fun, :__init__, [:name], [:set, :@name, :name]],
                  [:fun, :__init__, [:name, :id], [[:set, :@name, :name], [:set, :@id, :id]]],
                  [:fun, :name, [], [:ret, :@name]]
              ],
              [:set, :b, [:new, :B, ["Xiao Peng", 1]]],
              [:a, :b],
              [:b, :A],
              [:class, :A, nil,
                [:fun, :a, [], [:echo, "world"]],
                  [:static, :b, [], [[:echo, "static world"], [:set, :@@a, 5]]]
              ],
              [:a, :b],
              [:b, :A],
              [:b, :B],
              [:set_id, :b, [2.3]],
              [:get_id, :b],
              [:echo, [:name, :b]],
              [:echo, [:type, :b]],
              [:echo, [:type, [:get_id, :b]]],
              [:printf, 'hello, goto %f\n', [[:get_id, :b]]]
      ]
      main_prog = [:fun, :main, [], prog << [:ret, [:&, 5, [[:<<, 1, [2]]]]], :Integer]

      CLang::Context.new.gen_code(Parser.parse(main_prog))
    end

    def error_func(opaque, msg)
      raise msg
    end

    def run
      code = to_clang
      state = TCC::State.new
      state.set_error_func(method(:error_func))
      state.compile(code)
      state.run
    end
  end
end
