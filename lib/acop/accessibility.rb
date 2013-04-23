require 'open-uri'
require 'nokogiri'

module Acop
	class Enforcer
		def initialize(options={})
			url = options[:url]
			url = "http://" + options[:url] unless options[:url].include?("http")
			@contents = Nokogiri::HTML(open(url))
		end

		def accessibility_checks
			error_messages = []

			self.methods.each do |method|
				error_messages << (self.public_send(method)) if method[0..5] == "check_"
			end

			puts error_messages
		end

		def check_image_input_alt(source=@contents)
			input_elements = source.css('input')
			image_inputs   = input_elements.select {|image_input| image_input['type'] =~ /image/i}
			error_messages = []
			image_inputs.each do |input|
				error_messages.push("Missing alt text/attribute for image button with id/name: " + (input['name'] || input['id'] || "")) if alt_empty_or_nil(input)
			end
			error_messages
		end

		def check_image_alt(source=@contents)
			image_elements = source.css('img')
			error_messages = []
			image_elements.each do |element|
				error_messages.push("Missing alt text/attribute for image with src: " + element['src']) if alt_empty_or_nil(element)
			end
			error_messages
		end

		def alt_empty_or_nil(element)
			if(element['alt'] == nil || element['alt'] == "")
				return true
			end
			false
		end
	end

end
