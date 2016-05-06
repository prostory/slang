module SLang
	class CodeGen
		def initialize(file, expr)
			@expr = Expression.new(expr)
			puts @expr.to_s
			@file = file
		end

		def to_asm
			ProLog.new(@file).to_asm <<
				@expr.to_asm <<
				EpiLog.new.to_asm <<
				GlobalEpiLog.new.to_asm
		end
	end

	class ProLog
		def initialize(file)
			@file = file
		end

		def to_asm
			<<PROLOG
	.file   "#{@file}"
#{Constants.to_asm}
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
	end

	class EpiLog
		def to_asm
			<<EPILOG
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
EPILOG
		end
	end

	class GlobalEpiLog
		def to_asm
			<<GLOBAL_EPILOG
	.LFE0:
		.size   main, .-main
GLOBAL_EPILOG
		end
	end

	class Constant
		def to_asm
			".LC#{seq}:\n\t.string \"#{value}\"\n"
		end
	end

	class Constants
		def self.to_asm
			instance.to_asm
		end

		def to_asm
			s = "\t.section\t.rodata\n"
			list.each do |_, const|
				s << const.to_asm
			end
			s
		end
	end

	class Expression
		def to_asm
			push_regs <<
				init_stack <<
				visit_sub_expression <<
				visit_string_params <<
				"\tcall\t#{command}\n"
		end

		def push_regs
			s = ""
			regs.each {|r| s << "\tpushq\t#{r}\n"}
			s
		end

		def pop_regs

		end

		def init_stack
			return "\tsubq\t$#{X64.stack_size(params.length)}, %rsp\n" if params.length > X64.count
			""
		end

		def visit_sub_expression
			s = ""
			params.reverse.each do |param|
				if param.is_a?(Expression)
					s << param.to_asm
					s << "\tmovq\t%rax, #{param.address}\n" if param.address != '%rax'
				end
			end
			s
		end

		def visit_string_params
			s = ""
			params.reverse.each_with_index do |param, idx|
				i = params.length - idx - 1
				if i >= X64.count && param.address.include?('rbp')
					s << "\tmovq\t#{param.address}, %rdx\n"
					s << "\tmovq\t%rdx, #{X64.e1_r64(i)}\n"
				else
					s << "\tmovq\t#{param.address}, #{X64.e1_r64(i)}\n"
				end
			end
			s
		end
	end
end