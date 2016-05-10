Dir["#{File.expand_path('../',  __FILE__)}/**/*.rb"].each do |filename|
	require filename
end


#prog = [:do, [:fun, :hello_world, [], [:printf, "Hello World %d\\n", 50]], [:hello_world]]
# prog = [:do,
#         [:if, [:strlen,""],
#          [:puts, "IF: The string was not empty"],
#          [:puts, "ELSE: The string was empty"]
#         ],
#         [:if, [:strlen,"Test"],
#          [:puts, "Second IF: The string was not empty"],
#          [:puts, "Second IF: The string was empty"]
#         ]
# ]
prog = [:call, [:lambda, [], [:puts, "Test"]], [] ]
SLang::Compiler.new.compile(prog)
