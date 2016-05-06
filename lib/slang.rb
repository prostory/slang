Dir["#{File.expand_path('../',  __FILE__)}/**/*.rb"].each do |filename|
	require filename
end


prog = [:printf,"aaaa %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s\\n", [:strdup, "bbbb"], [:strdup, "cccc"], [:strdup, "cccc"], [:strdup, "cccc"],
        [:strdup, "cccc"], [:strdup, "cccc"], [:strdup, "cccc"], "eeee", "dddd", [:strdup, "cccc"], [:strdup, "cccc"],
        [:strdup, "cccc"], [:strdup, "cccc"]]
SLang::Compiler.new.compile(prog)
