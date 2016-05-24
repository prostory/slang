Dir["#{File.expand_path('../',  __FILE__)}/slang/**/*.rb"].uniq.each do |filename|
	require filename if filename.include? ".rb"
end

include SLang

prog = [:do, [:external, :puts, [:RawString], :Int], [:fun, :foo, [:arg], [:ret, :arg]], [:foo, "Hello World"], [:foo, 1], [:foo, "Hello World"]]

main_prog = [:fun, :main, [], prog]

puts CLang::Context.new.gen_code(Parser.parse(main_prog))
