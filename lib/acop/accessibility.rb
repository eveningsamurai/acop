require 'open-uri'
require 'nokogiri'
require 'rexml/document'
require File.dirname(__FILE__) + '/rspec_writer.rb'

module Acop

	class Enforcer
		attr_reader :ah, :options, :source, :contents

		def initialize(options={})
			@options = options
			@ah = Helpers.new
		end

		def get_url_contents(url)
			url = URI.parse(url)
			@source = open(url)
			@contents = Nokogiri::HTML(@source)
		end

		def formatted_url(url)
			url = "http://" + url unless url.include?("http")
		end

		def accessibility_checks
			if(@options[:url])
				Acop::RSpecWriter.new(options[:url]) if(options[:tests]=='rspec')
				error_messages = []
				length = 30 + @options[:url].length
				puts "="*length
				puts("==ACCESSIBILITY ISSUES FOR: #{@options[:url].chomp}==")
				puts "="*length
				get_url_contents(@options[:url])
				self.methods.each do |method|
					error_messages << (self.public_send(method)) if method[0..5] == "check_"
				end
				puts error_messages
			else
				urls = File.readlines(@options[:file])
				urls.each do |url|
					Acop::RSpecWriter.new(url) if(options[:tests]=='rspec')
					error_messages = []
					length = 30 + url.length
					puts "="*length
					puts("==ACCESSIBILITY ISSUES FOR: #{url.chomp}==")
					puts "="*length
					get_url_contents(formatted_url(url))
					self.methods.each do |method|
						error_messages << (self.public_send(method)) if method[0..5] == "check_"
					end
					puts error_messages
				end
			end
		end

		def check_image_input_alt(source=@contents)
			input_elements = source.css('input')
			image_inputs   = input_elements.select {|image_input| image_input['type'] =~ /image/i}
			error_messages = []
			image_inputs.each do |input|
				if (@ah.attribute_empty_or_nil(input, "alt") and input.parent.name != "a")
					error_messages.push("Line #{input.line}: Missing alt text/attribute for image button with id/name: " + (input['name'] || input['id'] || ""))
				end
			end
			error_messages
		end

		def check_image_alt(source=@contents)
			image_elements = source.css('img')
			error_messages = []
			image_elements.each do |element|
				if (@ah.attribute_empty_or_nil(element, "alt") and element.parent.name != "a")
					error_messages.push("Line #{element.line}: Missing alt text/attribute for image with src: " + element['src'])
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
					error_messages.push("Line #{link_element.line}: Alt Text not empty or nil for image link with src: " + link_element['src']) unless(@ah.attribute_empty_or_nil(link_element.parent, "alt"))
				end
			end
			error_messages
		end
		
		def check_areas(source=@contents)
			area_elements = source.css("area")
			error_messages = []
			area_elements.each do |element|
				if (@ah.attribute_empty_or_nil(element, "alt"))
					error_messages.push("Line #{element.line}: Missing alt text/attribute for area element with id/name: " + (element['name'] || element['id'] || ""))
				end
			end
			error_messages
		end

		def check_page_title(source=@contents)
			title_element = source.css('title')
			error_messages = []
			error_messages.push("Missing title element") if title_element.empty?
			error_messages.push("Line #{title_element.first.line}: Empty title element") if(title_element.first and title_element.first.text == "")
			error_messages.push("Line #{title_element.first.line}: More than 1 title element") if title_element.length > 1

			error_messages
		end

		def check_visual_formatting(source=@contents)
			error_messages = []
			%w{b i font center u}.each do |markup_element|
				visual_formatting_fields = source.css(markup_element)
				error_messages.push("Line #{visual_formatting_fields.first.line}: HTML visual formatting elements being used. Use CSS instead") unless visual_formatting_fields.empty?
			end
			error_messages
		end

		def check_doctype(source=@contents)
			frame_elements = source.css("frame")
			iframe_elements = source.css("iframe")
			error_messages = []
			if(frame_elements.length > 0 or iframe_elements.length > 0)
				puts @source.readlines.first
				doctype = REXML::Document.new(@source.readlines.first).doctype
				error_messages.push("Frames/iFrames present but doctype is missing") unless doctype
			end
			error_messages
		end

		def check_html_lang(source=@contents)
			html = source.css("html")
			error_messages = []
			error_messages.push("Missing lang attribute for html") if(html.attr('lang') == nil or html.attr('lang').value == "")
			error_messages
		end

		def check_hyperlinks(source=@contents)
			hyperlinks = source.css("a")
			error_messages = []
			hyperlinks.each do |link|
				error_messages.push("Line #{link.line}: Missing link text for link with href: #{link['href']}") if(link.css("img").empty? and (link.text==nil or link.text==""))
			end
			hyperlink_text = hyperlinks.collect {|link| link.text.lstrip }
			duplicate_hyperlink_text = hyperlink_text.select{|link| hyperlink_text.count(link) > 1}.uniq
			duplicate_hyperlink_text.reject! {|text| text.empty? }
			error_messages.push("Links should not have duplicate text: #{duplicate_hyperlink_text}") unless(duplicate_hyperlink_text.empty?)
			error_messages
		end

		def check_flashing_content(source=@contents)
			error_messages = []
			%w{blink marquee}.each do |flashing_element|
				flashing_element_fields = source.css(flashing_element)
				error_messages.push("Line #{flashing_element_fields.first.line}: Flashing elements such as 'blink' or 'marquee' should not be used") unless flashing_element_fields.empty?
			end
			error_messages
		end

		def check_frame_title(source=@contents)
			return [] if source.css("frameset").length < 1
			frame_elements = source.css("frame")
			error_messages = []
			frame_elements.each do |frame|
				error_messages.push("Line #{frame.line}: Missing frame title element") unless frame['title']
				error_messages.push("Line #{frame.line}: Empty frame title element") if frame['title'] == ""
			end
			error_messages
		end

		def check_iframe_title(source=@contents)
			iframe_elements = source.css("iframe")
			error_messages = []
			iframe_elements.each do |iframe|
				error_messages.push("Line #{iframe.line}: Missing iframe title element") unless iframe['title']
				error_messages.push("Line #{iframe.line}: Empty iframe title element") if iframe['title'] == ""
			end
			error_messages
		end

		# each form element should have a corresponding label
		def check_form_labels(source=@contents)
         forms = source.css("form")
         error_messages = []
			forms.each do |form|
				labels = form.css("label")
				form_fields = []
				%w{input select textarea button}.each do |element|
					element_fields = form.css(element)
					form_fields << form.css(element) unless element_fields.empty?
				end
				form_fields.flatten!
				form_fields.reject! {|field| field.attr('type') == 'submit' || field.attr('type') == 'reset' || field.attr('type') == 'button' }
				
				form_fields.each do |field|
					id = field.attr('id')
					error_messages.push("Line #{field.line}: Missing label for form field with id/name: " + (id || field.attr('name') || "")) if (labels.select {|label| label['for'].to_s == id.to_s }.size < 1)
				end
			end
         error_messages
		end

		# each input element of type (submit||reset||button) should have include a "value" attribute and should not have a corresponding label
		def check_form_inputs(source=@contents)
			forms = source.css("form")
			error_messages = []
			forms.each do |form|
				input_fields = form.css("input").select {|field| field.attr('type') == 'submit' || field.attr('type') == 'reset' || field.attr('type') == 'button' }
				labels = form.css("label")

				input_fields.each do |field|
					value_present = field.attr('value') != nil and field.attr('value') != ""
					label_absent  = (labels.select {|label| label['for'].to_s == field.attr('id').to_s }.size) < 1
					error_messages.push("Line #{field.line}: Missing value attribute/label present for input element with id/name: " + (field.attr('id').to_s || field.attr('name') || "")) unless(value_present and label_absent)
				end
			end
			error_messages
		end

		def check_form_control_text(source=@contents)
			error_messages = []
			labels = source.css("label")
			labels.each do |label|
				error_messages.push("Line #{label.line}: Missing label text for label with for attribute: #{label['for']}") if (label.text==nil or label.text=="")
			end

			%w{legend button}.each do |control|
				fields = source.css(control)
				fields.each do |field|
					error_messages.push("Line #{field.line}: Missing #{control} text for #{control}") if (field.text==nil or field.text=="")
				end
			end
			error_messages
		end

		def check_h1(source=@contents)
			h1_elements = source.css("h1")
			error_messages = []
			error_messages.push("Missing heading level 1. Provide atleast one level 1 heading for document content") if h1_elements.empty?
			error_messages
		end

		def check_heading_text(source=@contents)
			error_messages = []
			headings = []
			%w{h1 h2 h3 h4 h5 h6}.each do |heading|
				headings << source.css(heading)
			end
			headings.flatten!
			headings.each do |heading|
				error_messages.push("Line #{heading.line}: Missing text for #{heading.name} element") if(heading.text==nil or heading.text=="")
			end
			error_messages
		end

		def check_heading_structure(source=@contents)
			error_messages = []
			all_nodes = []
			source.at_css('body').traverse {|node| all_nodes << node.name }
			headings = all_nodes.select {|node| node =~ /^h\d/ }
			if headings.first != "h1"
				error_messages.push("First heading level should be h1") 
				return error_messages
			end

			prev_heading_level = 0
			headings.each do |heading|
				heading_level = heading[1]
				error_messages.push("Incorrect document heading structure") if (heading_level.to_i - prev_heading_level.to_i > 1)
				prev_heading_level = heading[1]
			end
			error_messages
		end

		def check_table_summary(source=@contents)
			error_messages = []
			tables = source.css("table")

			tables.each do |table|
				error_messages.push("Line #{table.line}: Missing table summary") if(table['summary'] == nil or table['summary'] == "")
			end
			error_messages
		end

		def check_table_headers(source=@contents)
			error_messages = []
			tables = source.css("table")

			tables.each do |table|
			 if table.css("th").empty?
				error_messages.push("#{table.line}: Missing table headers for table with summary: " + (table['summary'] || ""))
			 end
			end

			tables.each do |table|
				th_elements = table.css("th")
				th_elements.each do |th|
					error_messages.push("Line #{th.line}: Missing scope for table header") if (th['scope'] == nil || th['scope'] == "")
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
