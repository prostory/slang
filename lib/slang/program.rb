require_relative '../tcc/tcc'

require_relative 'parser'
require_relative 'transform'

require 'pp'

module SLang
  class Program
    def initialize
      parse_opt
    end

    def core_lib
      stdlib = [:do,
              [:external, :calloc, [:Integer, :Integer], :Pointer],
              [:external, :puts, [:String], :Integer],
              [:external, :printf, [:String, :VarList], :Integer],
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
               [:operator, :!, [], :Bool],
               [:fun, :or, [:n], [:'||', :self, [:n]]],
               [:fun, :and, [:n], [:'&&', :self, [:n]]],
               [:fun, :not, [:n], [:!, :self, [:n]]],
              ],
              [:module, :StringHelper,
               [:external, :len, :strlen, [], :Integer],
               [:external, :dup, :strdup, [], :String],
               [:external, :cat, :strcat, [:String], :String],
               [:external, :grow, :realloc, [:Integer], :String]
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
      BaseParser.parse(stdlib)
    end

    def parse(source)
      parser = Parser.new
      input = parser.parse(source)
      #pp input
      Transform.new.apply input
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end

    def compile(source)
      context = CLang::Context.new
      code = parse(source)
      main_prog = Function.new(:main, [], core_lib.children.push(*code) << Return.new([NumberLiteral.new(0)]), :Integer)
      context.gen_code(main_prog)
    end

    def error_func(opaque, msg)
      raise msg
    end

    def run
      source = ARGF.read || 'return 0'
      code = compile(source)
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
      @run = false
      OptionParser.new do |opts|
        opts.banner = "Usage: slang [options] file1[, file2...]"
        opts.separator ""
        opts.separator "Specific options:"
        
        opts.on('-o file', '--output', 'Output filename') do |output|
          @options[:output_filename] = output
        end
        opts.on('-e code', '--execute', 'Execute Code') do |code|
          @options[:code] = code
        end
        opts.on('-r', '--run', 'Run program') do
          @run = true
        end
        
        opts.separator ""
        opts.separator "Common options:"
        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end
        opts.on_tail('-v', '--version', 'Show version') do
          puts SLang::VERSION
          exit
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
