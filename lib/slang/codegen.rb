require_relative 'ast'

module SLang
	class CodeGen
		def initialize(file, expr)
			@expr = main_function(expr)
			@file = file
			@context = Context.new
			puts @context.to_s
		end

		def to_asm
			file << @context.to_asm
		end

		private
		def file
			"\t.file\t\"#{@file}\"\n"
		end

		def main_function(expr)
			Context.expression([:fun, :main, [], expr])
		end
	end

	class Context
		@@global_constants = {}
		@@global_functions = {}

		def self.add_constant(value)
			const = @@global_constants[value]
			return const if const
			const = Constant.new(value)
			@@global_constants[value] = const
			return const
		end

		def self.add_function(expr)
			name = expr[1]
			raise "Function #{name} is redefined!" if @@global_functions[name]
			@@global_functions[name] = Function.new(*expr[1..-1])
			NilExpression.new
		end

		def self.expression(expr)
			case expr[0]
				when :do
					do_block(expr)
				when :fun
					add_function(expr)
				else
					Expression.new(expr)
			end
		end

		def self.do_block(expr)
			Block.new(expr)
		end

		def constants
			s = "\t.section\t.rodata\n"
			@@global_constants.each do |_, const|
				s << const.to_asm
			end
			s << "\t.text\n"
			s
		end

		def functions
			@@global_functions.values.map {|func| func.to_asm}.join
		end

		def to_asm
			constants << functions
		end

		def to_s
			@@global_functions.values.join
		end
	end

	class Constant
		@@seq = 0
		attr_accessor :seq

		def initialize(value)
			@value = value
			@seq = @@seq
			@@seq += 1
		end

		def to_asm
			".LC#{seq}:\n\t.string \"#{value}\"\n"
		end

		def address
			"$.LC#{seq}"
		end
	end

	class Expression
		attr_accessor :address
		attr_accessor :regs

		def initialize(expr)
			init expr
			@regs = []
			init_params
		end

		def init_params
			@regs = []
			i = 0
			@params = @params.map do |param|
				case param
					when Array
						expr = Context.expression(param)
						expr.address = X64.e2_r64(i)
						@regs << expr.address if i > 0 && i < X64.count
						i += 1
						expr
					when String
						Context.add_constant param
				end
			end
		end

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

	class NilExpression < Expression
		def initialize
		end

		def to_s
			""
		end

		def to_asm
			""
		end
	end

	class Block < Expression
		def to_asm
			params.map {|param| param.to_asm }.join
		end
	end

	class Function
		attr_accessor :seq

		@@seq = 0

		def initialize(name, args, body, return_type = :void)
			init(name, args, body, return_type)
			@seq = @@seq
			@@seq += 1
		end

		def to_asm
			"\t.globl\t#{name}\n" <<
				"\t.type\t#{name}, @function\n" <<
				"#{name}:\n" <<
				".LFB#{seq}:\n" <<
				"\t.cfi_startproc\n" <<
				"\tpushq %rbp\n" <<
				"\t.cfi_def_cfa_offset 16\n" <<
				"\t.cfi_offset 6, -16\n" <<
				"\tmovq\t%rsp, %rbp\n" <<
				"\t.cfi_def_cfa_register 6\n" <<
				"#{body.to_asm}" <<
				"\tleave\n" <<
				"\t.cfi_def_cfa 7, 8\n" <<
				"\tret\n\t.cfi_endproc\n" <<
				".LFE#{seq}:\n" <<
				"\t.size\t#{name}, .-#{name}\n"
		end
	end
end