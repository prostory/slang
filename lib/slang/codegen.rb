require_relative 'ast'

module SLang
	class CodeGen
		def initialize(file, expr)
			define_main_function(expr)
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

		def define_main_function(expr)
			Function.from(:main, [], expr)
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

		def self.add_function(func)
			name = func.name
			raise "Function #{name} is redefined!" if @@global_functions[name]
			@@global_functions[name] = func
			return func
		end

		def constants
			s = "\t.section\t.rodata\n"
			s << @@global_constants.values.map { |const| const.to_asm }.join
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
		attr_accessor :value

		def initialize(value)
			@value = value
			@seq = @@seq
			@@seq += 1
		end

		def to_asm
			".LC#{seq}:\n\t.string \"#{value}\"\n"
		end
	end

	class NumberLiteral
		def self.from(value)
			new value
		end

		def address
			"$#{value}"
		end

		def to_asm
			""
		end
	end

	class StringLiteral
		attr_accessor :seq

		def self.from(value)
			const = Context.add_constant value
			s = new(value)
			s.seq = const.seq
			s
		end

		def address
			"$.LC#{@seq}"
		end

		def to_asm
			""
		end
	end

	class Expression
		def self.from(expr)
			case expr[0]
				when :do
					Do.from(expr[1..-1])
				when :fun
					Function.from(*expr[1..-1])
				when :if
					If.from(*expr[1..-1])
				else
					Call.from(expr[0], expr[1..-1])
			end
		end
	end

	class Parameter
		def self.from(obj)
			case obj
				when Array
					Expression.from(obj)
				when String
					StringLiteral.from(obj)
				when Fixnum
					NumberLiteral.from(obj)
			end
		end
	end

	class Call
		attr_accessor :address
		attr_accessor :regs

		def self.from(name, params)
			call = new(name, params.map{|p| Parameter.from(p)})
			call.init_params
			call
		end

		def init_params
			@regs = []
			i = 0
			@params = @params.select {|p| p.respond_to?(:address)}
			@params = @params.map do |param|
					if param.is_a?(Expression)
						param.address = X64.e2_r64(i)
						@regs << param.address if i > 0 && i < X64.count
						i += 1
					end
					param
			end
		end

		def to_asm
			s = ""

			regs.each {|r| s << "\tpushq\t#{r}\n"}

			s << "\tsubq\t$#{X64.stack_size(params.length)}, %rsp\n" if params.length > X64.count

			params.reverse.each do |param|
				if param.is_a?(Expression)
					s << param.to_asm
					s << "\tmovq\t%rax, #{param.address}\n" if param.address != '%rax'
				end
			end

			params.reverse.each_with_index do |param, idx|
				i = params.length - idx - 1

				if i >= X64.count && param.address.include?('rbp')
					s << "\tmovq\t#{param.address}, %rdx\n"
					s << "\tmovq\t%rdx, #{X64.e1_r64(i)}\n"
				else
					s << "\tmovq\t#{param.address}, #{X64.e1_r64(i)}\n"
				end
			end
			s << "\tcall\t#{name}\n"
		end
	end

	class Do
		def self.from(body)
			new body.map{|expr| Expression.from(expr)}
		end

		def to_asm
			body.map {|expr| expr.to_asm }.join
		end
	end

	class Function
		attr_accessor :seq

		@@seq = 0

		def self.from(name, args, body, return_type = :void)
			fun = Context.add_function Function.new(name, args, Expression.from(body), return_type)
			fun.seq = @@seq
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

	class If
		attr_accessor :seq

		@@seq = 0

		def self.from(cond, a_then, a_else)
			@@seq += 2
			s = new(Expression.from(cond), Expression.from(a_then), Expression.from(a_else))
			s.seq = @@seq
			s
		end

		def to_asm
			else_seq = seq - 1
			end_if_seq = seq
			cond.to_asm <<
				"\ttestl\t%eax, %eax\n" <<
				"\tje\t.L#{else_seq}\n" <<
				@then.to_asm <<
				"\tjmp\t.L#{end_if_seq}\n" <<
				".L#{else_seq}:\n" <<
				@else.to_asm <<
				".L#{end_if_seq}:\n"
		end
	end
end