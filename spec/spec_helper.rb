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

	def var
		Variable.new(self)
	end

	def const
		Const.new(self)
	end

	def class_var
		ClassVar.new(self)
	end

	def instance_var
		Member.new(self)
  end

  def param(type = nil)
    Parameter.new(self, type)
  end

	def call(args, obj = nil)
		Call.new(self, args, obj)
  end

  def module(body = [])
    SLang::Module.new(self, body)
  end

  def class_def(body = [], parent = nil)
    ClassDef.new(self, body, parent)
  end

  def function(params = [], body = [], receiver = nil)
    Function.new(self, params, body, nil, receiver)
  end

  def external(params = [], receiver = nil)
    External.new(self, nil, params, nil, receiver)
  end

  def operator(params = [], receiver = nil)
    Operator.new(self, nil, params, nil, receiver)
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
