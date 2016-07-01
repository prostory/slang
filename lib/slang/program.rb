require_relative '../tcc/tcc'

module SLang
  class Program
    def initialize
      parse_opt
    end

    def to_clang(prog = [])
      core_lib = [:do,
              [:external, :calloc, [:Integer, :Integer], :Pointer],
              [:class, :Object, nil,
               [:static, :__alloc__, [], [:calloc, nil, [[:sizeof, :self], 1]]],
               [:static, :new, [[:args, :VarList]], [[:set, :obj, [:__alloc__, :self, []]], [:__init__, :obj, [:args]], [:ret, :obj]]],
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
              [:class, :Array, nil,
               [:static, :new, [:size], [:array, :size]],
               [:fun, :[], [:index], [:ary_get, :self, :index]],
               [:fun, :[]=, [:index, :value], [:ary_set, :self, :index, :value]]
              ]
      ]
      main_prog = [:fun, :main, [], core_lib << prog, :Integer]
      CLang::Context.new.gen_code(Parser.parse(main_prog))
    end

    def error_func(opaque, msg)
      raise msg
    end

    def run(prog = nil)
      code = to_clang(prog)
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
      @run = true
      OptionParser.new do |opts|
        opts.on('-o ', 'Output filename') do |output|
          @options[:output_filename] = output
        end
        opts.on('-e ', 'Execute Code') do |code|
          @options[:code] = code
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

    def code
      @options[:code]
    end

    def run?
      @run
    end
  end
end
