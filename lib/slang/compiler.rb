module SLang
	class Compiler
		def initialize
			parse_opt
		end

		def parse_opt
			require 'optparse'

			@options = {}
			OptionParser.new do |opts|
				opts.on('-o ', 'Output filename') do |output|
					@options[:output_filename] = output
				end
			end.parse!

			if !@options[:output_filename] && ARGV.length > 0
				@options[:output_filename] = File.basename(ARGV[0], File.extname(ARGV[0]))
			end
		end

		def compile(expr)
			File.open(@options[:output_filename], "w") { |io| io.puts CodeGen.new(source_file, expr).to_asm }
		end

		def output_file
			@options[:output_filename]
		end

		def source_file
			File.basename(output_file, File.extname(output_file)) << '.rb'
		end
	end
end