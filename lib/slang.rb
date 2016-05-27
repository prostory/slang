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
        [:operator, :>, [:Integer, :Integer], :Bool],
        [:operator, :<, [:Integer, :Integer], :Bool],
        [:operator, :>=, [:Integer, :Integer], :Bool],
        [:operator, :<=, [:Integer, :Integer], :Bool],
        [:operator, :==, [:Integer, :Integer], :Bool],
        [:operator, :!=, [:Integer, :Integer], :Bool],
        [:operator, :+, [:Integer, :Float], :Float],
        [:operator, :-, [:Integer, :Float], :Float],
        [:operator, :*, [:Integer, :Float], :Float],
        [:operator, :/, [:Integer, :Float], :Float],
        [:operator, :%, [:Integer, :Float], :Float],
        [:operator, :>, [:Integer, :Float], :Bool],
        [:operator, :<, [:Integer, :Float], :Bool],
        [:operator, :>=, [:Integer, :Float], :Bool],
        [:operator, :<=, [:Integer, :Float], :Bool],
        [:operator, :==, [:Integer, :Float], :Bool],
        [:operator, :!=, [:Integer, :Float], :Bool],
        [:operator, :+, [:Float, :Integer], :Float],
        [:operator, :-, [:Float, :Integer], :Float],
        [:operator, :*, [:Float, :Integer], :Float],
        [:operator, :/, [:Float, :Integer], :Float],
        [:operator, :%, [:Float, :Integer], :Float],
        [:operator, :>, [:Float, :Integer], :Bool],
        [:operator, :<, [:Float, :Integer], :Bool],
        [:operator, :>=, [:Float, :Integer], :Bool],
        [:operator, :<=, [:Float, :Integer], :Bool],
        [:operator, :==, [:Float, :Integer], :Bool],
        [:operator, :!=, [:Float, :Integer], :Bool],
        [:operator, :+, [:Float, :Float], :Float],
        [:operator, :-, [:Float, :Float], :Float],
        [:operator, :*, [:Float, :Float], :Float],
        [:operator, :/, [:Float, :Float], :Float],
        [:operator, :%, [:Float, :Float], :Float],
        [:operator, :>, [:Float, :Float], :Bool],
        [:operator, :<, [:Float, :Float], :Bool],
        [:operator, :>=, [:Float, :Float], :Bool],
        [:operator, :<=, [:Float, :Float], :Bool],
        [:operator, :==, [:Float, :Float], :Bool],
        [:operator, :!=, [:Float, :Float], :Bool],
        [:operator, :'&&', [:Bool, :Bool], :Bool],
        [:operator, :'||', [:Bool, :Bool], :Bool],
        [:operator, :!, [:Bool, :Bool], :Bool],
        [:class, :Integer, nil,
         [:fun, :+, [:n], [:ret, [:+, nil, [:self, :n]]]],
         [:fun, :-, [:n], [:ret, [:-, nil, [:self, :n]]]],
         [:fun, :*, [:n], [:ret, [:*, nil, [:self, :n]]]],
         [:fun, :/, [:n], [:ret, [:/, nil, [:self, :n]]]],
         [:fun, :%, [:n], [:ret, [:%, nil, [:self, :n]]]],
         [:fun, :>, [:n], [:ret, [:>, nil, [:self, :n]]]],
         [:fun, :<, [:n], [:ret, [:<, nil, [:self, :n]]]],
         [:fun, :>=, [:n], [:ret, [:>=, nil, [:self, :n]]]],
         [:fun, :<=, [:n], [:ret, [:<=, nil, [:self, :n]]]],
         [:fun, :==, [:n], [:ret, [:==, nil, [:self, :n]]]],
         [:fun, :!=, [:n], [:ret, [:!=, nil, [:self, :n]]]],
        ],
        [:class, :Float, nil,
         [:fun, :+, [:n], [:ret, [:+, nil, [:self, :n]]]],
         [:fun, :-, [:n], [:ret, [:-, nil, [:self, :n]]]],
         [:fun, :*, [:n], [:ret, [:*, nil, [:self, :n]]]],
         [:fun, :/, [:n], [:ret, [:/, nil, [:self, :n]]]],
         [:fun, :%, [:n], [:ret, [:%, nil, [:self, :n]]]],
         [:fun, :>, [:n], [:ret, [:>, nil, [:self, :n]]]],
         [:fun, :<, [:n], [:ret, [:<, nil, [:self, :n]]]],
         [:fun, :>=, [:n], [:ret, [:>=, nil, [:self, :n]]]],
         [:fun, :<=, [:n], [:ret, [:<=, nil, [:self, :n]]]],
         [:fun, :==, [:n], [:ret, [:==, nil, [:self, :n]]]],
         [:fun, :!=, [:n], [:ret, [:!=, nil, [:self, :n]]]],
        ],
        [:class, :Bool, nil,
         [:fun, :or, [:n], [:ret, [:'||', nil, [:self, :n]]]],
         [:fun, :and, [:n], [:ret, [:'&&', nil, [:self, :n]]]],
         [:fun, :not, [:n], [:ret, [:!, nil, [:self, :n]]]],
        ]
]

main_prog = [:fun, :main, [], prog << [:ret, [:or, [:>, 1.5, [[:*, 1.2, [1.8]]]], [[:>, [:/, 5, [2.0]], [2]]]]], :Integer]

puts CLang::Context.new.gen_code(Parser.parse(main_prog))
