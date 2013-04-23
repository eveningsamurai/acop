require 'open-uri'
require 'nokogiri'

module Acop
	class Enforcer
		def initialize(options={})
			@contents = html_source(options[:url])
		end

		def html_source(url)
			url = "http://" + url unless url.include?("http")
			Nokogiri::HTML(open(url))
		end

		def accessibility_checks
			error_messages = []

			self.methods.each do |method|
				error_messages << (self.public_send(method)) if method[0..5] == "check_"
			end

			puts error_messages
		end

		def check_image_input_alt
			input_elements = @contents.css('input')
			image_inputs   = input_elements.select {|image_input| image_input['type'] =~ /image/i}
			error_messages = []
			image_inputs.each do |input|
				error_messages.push("Missing alt text/attribute for image button with id/name: " + input['name'] || input['id'] || "") unless alt_empty_or_nil(input)
			end
			error_messages
		end

		def check_image_alt
			image_elements = @contents.css('img')
			error_messages = []
			image_elements.each do |element|
				error_messages.push("Missing alt text/attribute for image with src: " + element['src']) unless alt_empty_or_nil(element)
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
