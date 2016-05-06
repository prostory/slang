module SLang
	class Compiler
		def initialize
			parse_opt
			@string_constants = {}
			@seq = 0
			@common_regs = ['%edi', '%esi', '%edx', '%ecx', '%r8d', '%r9d']
			@temp_regs = ['%eax', '%ebx', '%r12d', '%r13d', '%r14d', '%r15d']
		end

		def one_word_bytes
			64 / one_byte_bits
		end

		def one_byte_bits
			8
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

		def need_rsp?(seq)
			seq > @common_regs.length-1
		end

		def get_rsp_size(seq)
			(seq - @common_regs.length) * one_word_bytes
		end

		def need_rbp?(seq)
			seq > @temp_regs.length-1
		end

		def get_rbp_size(seq)
			seq * one_word_bytes
		end

		def common_reg(seq)
			rsp_size = get_rsp_size(seq)
			if rsp_size > 0
				return "#{rsp_size}(%rsp)"
			elsif rsp_size == 0
				return "(%rsp)"
			else
				return @common_regs[seq]
			end
		end

		def temp_reg(seq)
			rbp_size = get_rbp_size(seq)
			if need_rbp?(seq)
				return "-#{rbp_size}(%rbp)"
			else
				return @temp_regs[seq]
			end
		end

		def get_arg(io, a)
			if a.is_a?(Array)
				output_expr(io, a)
				return [:subexpr]
			end

			seq = @string_constants[a]
			return [:strconst, seq] if seq
			seq = @seq
			@seq += 1
			@string_constants[a] = seq
			return [:strconst, seq]
		end

		def output_constants(io)
			io.puts "\t.section\t.rodata"
			@string_constants.each do |c, seq|
				io.puts ".LC#{seq}:"
				io.puts "\t.string \"#{c}\""
			end
		end

		def output_expr(io, expr)
			call = expr[0].to_s

			io.puts "\tsubq $#{get_rsp_size(expr.length)}, %rsp" if need_rsp?(expr.length-2)

			ints1 = []
			ints2 = []
			expr[1..-1].each do |a|
				atype, aparpm = get_arg(io, a)
				if expr[0] != :do
					case atype
						when :strconst
							param = "$.LC#{aparpm}"
						when :subexpr
							param = :subexpr
							ints2 << temp_reg(ints2.length)
					end
					if need_rsp?(ints1.length-1)
						ints1 << [:movq, param]
					else
						ints1 << [:movl, param]
					end
				end
			end

			ints2 = ints2.reverse
			i = 0
			ints1.each_with_index do |int, idx|
				p int
				param = int[1]
				if int[1] == :subexpr
					param = ints2[i]
					i += 1
				end

				io.puts "\t#{int[0]} #{param}, #{common_reg(ints1.length-idx-1)}"
			end

			io.puts "\tmovl	$0, %eax"
			io.puts "\tcall\t#{call}"

		end

		def output_prolog(io)
			io.puts <<PROLOG
	.file   "#{source_file}"
	.text
	.globl main
	.type   main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
PROLOG
		end

		def output_epilog(io)
			io.puts <<EPILOG
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
EPILOG
		end

		def output_global_epilog(io)
			io.puts <<GLOBAL_EPILOG
.LFE0:
	.size   main, .-main
GLOBAL_EPILOG
		end

		def output(io, expr)
			output_prolog(io)
			output_expr(io, expr)
			output_epilog(io)
			output_global_epilog(io)
			output_constants(io)
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