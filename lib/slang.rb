Dir["#{File.expand_path('../',  __FILE__)}/slang/**/*.rb"].uniq.each do |filename|
	require filename if filename.include? ".rb"
end