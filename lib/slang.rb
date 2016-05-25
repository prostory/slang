Dir["#{File.expand_path('../',  __FILE__)}/slang/**/*.rb"].uniq.each do |filename|
	require filename if filename.include? ".rb"
end

include SLang

prog = [:do,
        [:external, :puts, [:String], :Int],
        [:class, :String, nil,
         [:fun, :dump, [], [:puts, nil, [:self]]]
        ],
        [:dump, "Hello World"],
        [:puts, nil, ["Hello World"]]
]

main_prog = [:fun, :main, [], prog << [:ret, 0], :Int]

puts CLang::Context.new.gen_code(Parser.parse(main_prog))
