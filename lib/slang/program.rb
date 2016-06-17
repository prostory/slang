require_relative '../tcc/tcc'

module SLang
  class Program
    def initialize
      parse_opt
    end

    def to_clang
      prog = [:do,
              [:external, :calloc, [:Integer, :Integer], :Pointer],
              [:class, :Pointer, nil,
               [:static, :new, [:size], [:calloc, nil, [:size, 1]]],
               [:static, :new, [:size, :nitems], [:calloc, nil, [:size, :nitems]]],
               [:external, :realloc, [:Integer], :Pointer],
               [:external, :release, [], :Void],
               [:fun, :[], [:index], [:+, :self, [:index]]],
               [:fun, :[]=, [:index, :value], [:at, [:+, :self, [:index]], :value]]
              ],
              [:class, :Object, nil,
               [:static, :__alloc__, [:size], [:calloc, nil, [:size, 1]]],
               [:static, :new, {args: :VarList}, [[:set, :obj, [:__alloc__, :self, [[:sizeof]]]], [:__init__, :obj, [:args]], [:ret, :obj]]],
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
               [:fun, :to_i, [], [:ret, :self]],
               [:fun, :times, [:fn], [[:set, :i, 1], [:while, [:<=, :i, [:self]], [[:fn, nil, [:i]], [:set, :i, [:+, :i, [1]]]]]]]
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
              [:module, :StringHelper,
               [:external, :echo, :puts, [], :Integer],
               [:external, :len, :strlen, [], :Integer],
               [:external, :dup, :strdup, [], :String],
               [:external, :cat, :strcat, [:String], :String],
               [:external, :printf, [:VarList], :Integer],
              ],
              [:class, :String, nil,
               [:include, :StringHelper],
               [:static, :new, [:const_str], [:dup, :const_str]],
               [:fun, :<<, [:s], [[:set, :len, [:+, [:+, [:len, :self], [[:len, :s]]], [1]]],
                                  [:set, :self, [:grow, :self, [:len]]],
                                  [:cat, :self, [:s]]]],
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
              [:set, :b, [:new, :B, ["Xiao Peng"]]],
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
              [:echo, [:type, [:get_id, :b]]],
              [:set_id, :b, [1]],
              [:echo, [:type, [:get_id, :b]]],
              [:echo, [:name, :b]],
              [:echo, [:type, :b]],
              [:printf, 'hello, goto %d\n', [[:get_id, :b]]],
              [:times, 5, [[:lambda, [:n], [:echo, 'Hello']]]],
              [:times, 5, [[:lambda, [:n], [:echo, 'World']]]],
              [:times, 5, [[:lambda, [:n], [:printf, 'count: %d\n', [:n]]]]],
              [:set, :a, [:list, 1, 2, 3, 4]],
              [:set, :p, [:new, :Pointer, [[:sizeof, :Integer], 4]]],
              [:[]=, :p, [0, 5]]
      ]
      main_prog = [:fun, :main, [], prog << [:ret, [:&, 5, [[:<<, 1, [2]]]]], :Integer]

      CLang::Context.new.gen_code(Parser.parse(main_prog))
    end

    def error_func(opaque, msg)
      raise msg
    end

    def run
      code = to_clang
      output code
      if run?
        state = TCC::State.new
        state.set_error_func(method(:error_func))
        state.add_library_path '../vendor/tcc/lib'
        state.compile(code)
        state.run
      end
    end

    def parse_opt
      require 'optparse'

      @options = {}
      OptionParser.new do |opts|
        opts.on('-o ', 'Output filename') do |output|
          @options[:output_filename] = output
        end
        opts.on('-r', 'Run program') do
          @run = true
        end
      end.parse!

      if output_file.nil? && ARGV.length > 0
        @options[:output_filename] = File.basename(ARGV[0], File.extname(ARGV[0]))
      end
    end

    def output(code)
      File.open(output_file, "w") { |io| io.puts code } if output_file
    end

    def output_file
      @options[:output_filename]
    end

    def run?
      @run
    end
  end
end
