module SLang
	class Constant
		attr_accessor :type
		attr_accessor :seq
		attr_accessor :value
		attr_accessor :address

		def initialize(type, seq, value)
			@type = type
			@seq = seq
			@value = value
			@address = "$.LC#{@seq}"
		end

		def to_s
			"\"#{value}\""
		end
	end

	class Constants
		@@instance = nil

		attr_accessor :list

		def initialize
			@list = {}
		end

		def self.instance
			@@instance = Constants.new if @@instance == nil
			@@instance
		end

		def self.<< (value)
			instance << value
		end

		def self.[] (value)
			instance[value]
		end

		def << (value)
			const = @list[value]
			return const if const
			const = Constant.new(get_value_type(value), @list.length, value)
			@list[value] = const
			return const
		end

		def [] (value)
			const = @list[value]
			return const if const
		end

		private
		def get_value_type(value)
			"#{value.class}_const".downcase.to_sym
		end
	end

	class Expression
		attr_accessor :command
		attr_accessor :params
		attr_accessor :address
		attr_accessor :regs

		def initialize(expr)
			@command = expr[0].to_s
			@regs = []
			i = 0
			@params = expr[1..-1].map do |param|
				case param
					when Array
						expr = Expression.new(param)
						expr.address = X64.e2_r64(i)
						@regs << expr.address if i > 0 && i < X64.count
						i += 1
						expr
					when String
						Constants << param
				end
			end
		end

		def to_s
			"#{@command}( #{@params.join(', ').to_s} )"
		end
	end
end