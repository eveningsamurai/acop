require 'open-uri'
require 'nokogiri'
require_relative 'helper'

module Acop
	class Enforcer
		attr_writer :ah

		def initialize(options={})
			@ah = Helpers.new
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
				if (@ah.alt_empty_or_nil(input) and input.parent.name != "a")
					error_messages.push("Missing alt text/attribute for image button with id/name: " + (input['name'] || input['id'] || ""))
				end
			end
			error_messages
		end

		def check_image_alt(source=@contents)
			image_elements = source.css('img')
			error_messages = []
			image_elements.each do |element|
				if (@ah.alt_empty_or_nil(element) and element.parent.name != "a")
					error_messages.push("Missing alt text/attribute for image with src: " + element['src'])
				end
			end
			error_messages
		end

		def check_image_links(source=@contents)
			link_elements = source.css('a img')
			error_messages = []
			image_links = []
			link_elements.each do |link_element|
				if(link_element['alt'] != "")
					error_messages.push("Alt Text not empty or nil for image link with src: " + link_element['src'])
				end
			end
			error_messages
		end

		def check_page_title(source=@contents)
			title_element = source.css('title')
			error_messages = []
			error_messages.push("Missing title element") unless title_element.first['title']
			error_messages.push("Empty title element") if title_element.first['title'] == ""
			error_messages
		end

		def check_frame_title(source=@contents)
			return [] if source.css("frameset").length < 1
			frame_elements = source.css("frame")
			frame_elements.each do |frame|
				error_messages.push("Missing frame title element") unless frame['title']
				error_messages.push("Empty frame title element") if frame['title'] == ""
			end
			error_messages
		end
	end

	class Helpers
		def alt_empty_or_nil(element)
			if(element['alt'] == nil || element['alt'] == "")
				return true
			end
			false
		end
	end

end
