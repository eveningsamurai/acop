require 'open-uri'
require 'nokogiri'

module Acop
	class Enforcer
		def initialize(options={})
			@url = options[:url]
		end

		def html_source(url)
			doc = Nokogiri::HTML(open(url))
		end

		def accessibility_checks
			contents = html_source(@url)
			error_messages = []

			self.methods.each do |method|
				error_messages << (self.public_send(method)) if method[0..5] == "check_"
			end

			puts error_messages
		end

		def check_image_input_alt
			input_elements = page.css('input')
			image_inputs   = input_elements.select {|image_input| image_input['type'] =~ /image/i}
			error_messages = []
			image_inputs.each do |input|
				error_messages.push("Missing alt attribute for image button with id/name: " + input['name'] || input['id'] || "") unless input['alt']
				error_messages.push("Missing alt text for image button with id/name " + input['name'] || input['id'] || "") if input['alt'] == ""
			end
			error_messages
		end

		def check_image_alt
			image_elements = page.css('img')
			error_messages = []
			image_elements.each do |element|
				error_messages.push("Missing alt attribute for image with src: " + element['src']) unless element['alt']
				error_messages.push("Missing alt text for image with src: " + element['src']) if element['alt'] == ""
			end
			error_messages
		end
	end

end
