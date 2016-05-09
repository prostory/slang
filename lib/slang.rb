Dir["#{File.expand_path('../',  __FILE__)}/**/*.rb"].each do |filename|
	require filename
end


prog = [:do, [:fun, :hello_world, [], [:puts, "Hello World"]], [:hello_world]]
SLang::Compiler.new.compile(prog)
