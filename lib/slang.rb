Dir["#{File.expand_path('../',  __FILE__)}/slang/**/*.rb"].uniq.each do |filename|
	require filename if filename.include? ".rb"
end

include SLang

prog = [:do,
        [:operator, :+, [:Integer, :Integer], :Integer],
        [:operator, :-, [:Integer, :Integer], :Integer],
        [:operator, :*, [:Integer, :Integer], :Integer],
        [:operator, :/, [:Integer, :Integer], :Integer],
        [:operator, :%, [:Integer, :Integer], :Integer],
        [:class, :Integer, nil,
         [:fun, :+, [:n], [:ret, [:+, nil, [:self, :n]]]],
         [:fun, :-, [:n], [:ret, [:-, nil, [:self, :n]]]],
         [:fun, :*, [:n], [:ret, [:*, nil, [:self, :n]]]],
         [:fun, :/, [:n], [:ret, [:/, nil, [:self, :n]]]],
         [:fun, :%, [:n], [:ret, [:%, nil, [:self, :n]]]],
        ]
]

main_prog = [:fun, :main, [], prog << [:ret, [:*, 1, [[:+, 2, [3]]]]], :Integer]

puts CLang::Context.new.gen_code(Parser.parse(main_prog))
