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
              [:class, :Class, nil],
              [:class, :Object, nil,
               [:operator, :==, [:Object], :Bool]
              ],
              [:class, :Integer, nil,
               [:operator, :-, [], :Integer],
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
               [:fun, :times, [:fn], [[:set, :i, 0], [:while, [:<, :i, [:self]], [[:fn, nil, [:i]], [:set, :i, [:+, :i, [1]]]]]]]
              ],
              [:class, :Float, nil,
               [:operator, :-, [], :Float],
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
      if code
        source = code
      else
        source = ARGF.read || 'return 0'
      end
      code = compile(source)
      if compile?
        output code
      else
        state = TCC::State.new
        state.set_error_func(method(:error_func))
        state.add_library_path '../vendor/tcc/lib'
        state.add_library_path '/usr/lib'
        state.add_library_path '/usr/local/lib'
        if run?
          state.add_libraries(libraries)
          state.compile(code)
          state.run
        else
          state.output_type = TCC::OutPutType::EXE
          state.add_libraries(libraries)
          state.compile(code)
          state.output_file = output_file
        end
      end
    end

    def parse_opt
      require 'optparse'

      @options = {}
      @run = false
      @compile = false
      @libraries = []
      OptionParser.new do |opts|
        opts.banner = "Usage: slang [options] file1[, file2...]"
        opts.separator ""
        opts.separator "Specific options:"
        
        opts.on('-o file', '--output', 'Output file') do |output|
          @options[:output_filename] = output
        end
        opts.on('-e code', '--execute', 'Execute Code') do |code|
          @options[:code] = code
          @run = true
        end
        opts.on('-r', '--run', 'Run program') do
          @run = true
        end
        opts.on('-c', '--compile', 'Compile to C file') do
          @compile = true
          @options[:output_filename] << '.c' if File.extname(output_file) != '.c'
        end
        opts.on('-l x,y,z', Array, "Link libraries") do |libs|
          @libraries = libs
        end
        
        if output_file.nil? && ARGV.length > 0
          source_file = ARGV.find {|arg| File.extname(arg) == '.sl'}
          @options[:output_filename] = File.basename(source_file, File.extname(source_file)) if source_file
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
    end

    def output(code)
      File.open(output_file, "w") { |io| io.puts code } if compile?
    end

    def output_file
      @options[:output_filename]
    end

    def code
      @options[:code]
    end
    
    def libraries
      @libraries
    end

    def run?
      @run
    end
    
    def compile?
      @compile
    end
  end
end
