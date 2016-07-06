require 'rspec'

require(File.expand_path("../../lib/slang", __FILE__))

RSpec.configure do |config|
	config.expect_with(:rspec) { |c| c.syntax = :should, :expect }
end

include SLang

class Fixnum
	def int
		NumberLiteral.new(self)
	end
end

class Float
	def float
		NumberLiteral.new(self)
	end
end

class TrueClass
	def bool
		BoolLiteral.new(self)
	end
end

class FalseClass
	def bool
		BoolLiteral.new(self)
	end
end

class String
	def string
		StringLiteral.new(self)
	end

	def new_string
		Call.new(:new, [StringLiteral.new(self)], Const.new(:String))
	end
end

class Array
	def array
		ArrayLiteral.new(self)
	end
end

class Parslet::Cause
  def cause
  end
  def backtrace
  end
end
