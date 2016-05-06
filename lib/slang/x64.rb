module SLang
	class X64
		EXP1_REG32 = [:edi, :esi, :edx, :ecx, :r8d, :r9d]
		EXP1_REG64 = [:rdi, :rsi, :rdx, :rcx, :r8, :r9]
		EXP2_REG32 = [:eax, :ebx, :r12d, :r13d, :r14d, :r15d]
		EXP2_REG64 = [:rax, :rbx, :r12, :r13, :r14, :r15]

		def self.e1_r32(i)
			return "%#{EXP1_REG32[i]}" if i < count
			return "#{(i-count)*ptr_size if i > count}(%rsp)"
		end

		def self.e2_r32(i)
			if i >= count
				return "#{-52-(i-count)*4}(%rbp)"
			else
				return "%#{EXP2_REG32[i]}"
			end
		end

		def self.e1_r64(i)
			return "%#{EXP1_REG64[i]}" if i < count
			return "#{(i-count)*ptr_size if i > count}(%rsp)"
		end

		def self.e2_r64(i)
			if i >= count
				return "#{-56-(i-count)*ptr_size}(%rbp)"
			else
				return "%#{EXP2_REG64[i]}"
			end
		end

		def self.count
			6
		end

		def self.ptr_size
			8
		end

		def self.stack_size(size)
			ptr_size + (((size-1+0.5)*ptr_size/(4.0*ptr_size)).round) * (4*ptr_size)
		end
	end
end