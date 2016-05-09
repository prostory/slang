Dir["#{File.expand_path('../',  __FILE__)}/**/*.rb"].each do |filename|
	require filename
end


prog = [:do, [:fun, :hello_world, [], [:printf, "Hello World %d\\n", 50]], [:hello_world]]
SLang::Compiler.new.compile(prog)
