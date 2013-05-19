module Acop
	class RSpecWriter
		attr_writer :file
		attr_reader :url

		def initialize(url)
			@url = url
			Dir.mkdir("./spec") unless File.exists?("./spec")
			if File.exists?("./spec/acop_spec.rb")
				@file = File.open("./spec/acop_accessibility_spec.rb", 'a')
				append_file(@url)
			else
				@file = File.open("./spec/acop_accessibility_spec.rb", 'w')
				write_file(@url)
			end
			close_file
		end

		def append_file(url)
			write_rspec(url)
		end

		def write_file(url)
			write_requires
			write_rspec(url)
		end

		def write_requires
			@file.puts "require 'rspec/expectations'"
		end

		def write_rspec(url)
			@file.puts "describe '#{url.chomp}' do"
			@file.puts "  it 'should pass accessibility tests' do"
			@file.puts "    output = `acop -u #{url.chomp}`"
			@file.puts "    output = output.split(\"\\n\").reject! {|line| line[0] == '='}"
			@file.puts "    puts '== ACCESSIBILITY ISSUES =='"
			@file.puts "    puts output"
			@file.puts "    output.should be_empty"
			@file.puts "  end"
			@file.puts "end"
			@file.puts
		end

		def close_file
			@file.close
		end
	end
end

