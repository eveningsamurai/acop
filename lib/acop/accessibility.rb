require 'open-uri'
require 'nokogiri'
require 'rexml/document'

module Acop

	class Enforcer
		attr_reader :ah, :source, :contents

		def initialize(options={})
			@ah = Helpers.new
			url = options[:url]
			url = "http://" + options[:url] unless options[:url].include?("http")
			@source = open(url)
			@contents = Nokogiri::HTML(@source)
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
				if (@ah.attribute_empty_or_nil(input, "alt") and input.parent.name != "a")
					error_messages.push("Missing alt text/attribute for image button with id/name: " + (input['name'] || input['id'] || ""))
				end
			end
			error_messages
		end

		def check_image_alt(source=@contents)
			image_elements = source.css('img')
			error_messages = []
			image_elements.each do |element|
				if (@ah.attribute_empty_or_nil(element, "alt") and element.parent.name != "a")
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
		
		def check_areas(source=@contents)
			area_elements = source.css("area")
			error_messages = []
			area_elements.each do |element|
				if (@ah.attribute_empty_or_nil(element, "alt"))
					error_messages.push("Missing alt text/attribute for area element with id/name: " + (element['name'] || element['id'] || ""))
				end
			end
			error_messages
		end

		def check_page_title(source=@contents)
			title_element = source.css('title')
			error_messages = []
			error_messages.push("Missing title element") if title_element.empty?
			error_messages.push("Empty title element") if(title_element.first and title_element.first.text == "")
			error_messages.push("More than 1 title element") if title_element.length > 1

			error_messages
		end

		def check_doctype(source=@contents)
			frame_elements = source.css("frame")
			iframe_elements = source.css("iframe")
			error_messages = []
			if(frame_elements.length > 0 or iframe_elements.length > 0)
				doctype = REXML::Document.new(@source.string).doctype
				error_messages.push("Frames/iFrames present but doctype is missing") unless doctype
			end
			error_messages
		end

		def check_frame_title(source=@contents)
			return [] if source.css("frameset").length < 1
			frame_elements = source.css("frame")
			error_messages = []
			frame_elements.each do |frame|
				error_messages.push("Missing frame title element") unless frame['title']
				error_messages.push("Empty frame title element") if frame['title'] == ""
			end
			error_messages
		end

		def check_iframe_title(source=@contents)
			iframe_elements = source.css("iframe")
			error_messages = []
			iframe_elements.each do |iframe|
				error_messages.push("Missing iframe title element") unless iframe['title']
				error_messages.push("Empty iframe title element") if iframe['title'] == ""
			end
			error_messages
		end

		def check_forms(source=@contents)
         forms = source.css("form")
         error_messages = []
			forms.each do |form|
				labels = form.css("label")
				form_fields = []
				%w{input select textarea button}.each do |element|
					element_fields = form.css(element)
					form_fields << form.css(element) unless element_fields.empty?
				end
				form_fields.each do |field|
					id = field.attr('id')
					error_messages.push("Missing label for form field with id/name: " + id || field.attr('name') || "") if (labels.select {|label| label['for'].to_s == id.to_s }.size < 1)
				end
			end
         error_messages
		end

	end

	class Helpers
		def attribute_empty_or_nil(element, attribute)
			if(element[attribute] == nil || element[attribute] == "")
				return true
			end
			false
		end
	end

end
