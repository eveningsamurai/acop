require '../lib/acop/accessibility.rb'
require 'rspec/expectations'
require 'webmock/rspec'
require 'open-uri'

RSpec.configure do |config|
	config.before(:all) do
	end

	config.after(:all) do
	end

	describe Acop::Enforcer do
		it "should not return error messages when no issues with image tags" do
			stub_request(:any, "www.example.com").to_return(:body => "<html><body><input type='image' alt='alt text'/></body></html>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_image_input_alt
			error_messages.should be_empty
		end

		it "should return error messages when alt tags absent from input image elements" do
			stub_request(:any, "www.example.com").to_return(:body => "<html><body><input type='image'/></body></html>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_image_input_alt
			error_messages.should_not be_empty
			error_messages[0].should match("Missing alt text/attribute for image button")
		end

		it "should return error messages when alt tags empty in input image elements" do
			stub_request(:any, "www.example.com").to_return(:body => "<html><body><input type='image' alt=''/></body></html>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_image_input_alt
			error_messages.should_not be_empty
			error_messages[0].should match("Missing alt text/attribute for image button")
		end

		it "should return error messages when alt tags absent from image elements" do
			stub_request(:any, "www.example.com").to_return(:body => "<html><body><img src='www.intuit.com'></body></html>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_image_alt
			error_messages.should_not be_empty
			error_messages[0].should match("Missing alt text/attribute for image with src")
		end

		it "should return error messages when alt tags empty in image elements" do
			stub_request(:any, "www.example.com").to_return(:body => "<html><body><img alt='' src='www.intuit.com'></body></html>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_image_alt
			error_messages.should_not be_empty
			error_messages[0].should match("Missing alt text/attribute for image with src")
		end

		it "should return error messages when alt tags absent from image links" do
			stub_request(:any, "www.example.com").to_return(:body => "<html><body><img src='www.intuit.com'></body></html>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_image_alt
			error_messages.should_not be_empty
			error_messages[0].should match("Missing alt text/attribute for image with src")
		end

		it "should have alt tags empty in image links" do
			stub_request(:any, "www.example.com").to_return(:body => "<a class='visually-hidden'><img id='img_link' src='\/try_qbo_free.png' alt=''/>Try QuickBooks Online for Free</a>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_image_links
			error_messages.should be_empty
		end

		it "should return error messages when alt tags not empty in image links" do
			stub_request(:any, "www.example.com").to_return(:body => "<a class='visually-hidden'><img id='img_link' src='\/try_qbo_free.png' alt='bla bla'/>Try QuickBooks Online for Free</a>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_image_links
			error_messages.should_not be_empty
			error_messages[0].should match("Alt Text not empty or nil for image link with src")
		end

		it "should return error messages when alt tags nil in image links" do
			stub_request(:any, "www.example.com").to_return(:body => "<a class='visually-hidden'><img id='img_link' src='\/try_qbo_free.png' alt='bla bla'/>Try QuickBooks Online for Free</a>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_image_links
			error_messages.should_not be_empty
			error_messages[0].should match("Alt Text not empty or nil for image link with src")
		end

		it "should return error messages when alt tags not present in area elements" do
			stub_request(:any, "www.example.com").to_return(:body => "<area shape='rect' coords='0,0,82,126' href='sun.htm'>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_areas
			error_messages.should_not be_empty
			error_messages[0].should match("Missing alt text/attribute for area element")
		end

		it "should return error messages when alt tags empty in area elements" do
			stub_request(:any, "www.example.com").to_return(:body => "<area shape='rect' coords='0,0,82,126' href='sun.htm' alt=''>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_areas
			error_messages.should_not be_empty
			error_messages[0].should match("Missing alt text/attribute for area element")
		end

		it "should not return error messages when alt tags present in area elements" do
			stub_request(:any, "www.example.com").to_return(:body => "<area shape='rect' coords='0,0,82,126' href='sun.htm' alt='Sun'>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_areas
			error_messages.should be_empty
		end

		it "should return error messages when title not present" do
			stub_request(:any, "www.example.com").to_return(:body => "<html><head></head></html>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_page_title
			error_messages.should_not be_empty
			error_messages[0].should match("Missing title element")
		end

		it "should return error messages when title element empty" do
			stub_request(:any, "www.example.com").to_return(:body => "<html><head><title></title></head></html>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_page_title
			error_messages.should_not be_empty
			error_messages[0].should match("Empty title element")
		end

		it "should return error messages when more than 1 title element" do
			stub_request(:any, "www.example.com").to_return(:body => "<html><head><title>Some Title</title><title>Another title</title></head></html>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_page_title
			error_messages.should_not be_empty
			error_messages[0].should match("More than 1 title element")
		end

		it "should return no error messages when frameset is not present" do
			stub_request(:any, "www.example.com").to_return(:body => "<frame src='frame_a.htm' title=''><frame src='frame_b.htm' title='bla'>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_frame_title
			error_messages.should be_empty
		end

		it "should return error messages when frame/iframe present but no doctype" do
			stub_request(:any, "www.example.com").to_return(:body => "<!DOCTYPE Resource SYSTEM 'foo.dtd'><frameset cols='50%,50%'><frame src='frame_a.htm'/><frame src='frame_b.htm'/></frameset>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_doctype
			puts error_messages
			error_messages.should be_empty
		end

		it "should return error messages when frame does not have a title" do
			stub_request(:any, "www.example.com").to_return(:body => "<frameset cols='50%,50%'><frame src='frame_a.htm'><frame src='frame_b.htm'></frameset>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_frame_title
			error_messages.should_not be_empty
			error_messages[0].should match("Missing frame title element")
		end

		it "should return error messages when frame title is empty" do
			stub_request(:any, "www.example.com").to_return(:body => "<frameset cols='50%,50%'><frame src='frame_a.htm' title=''><frame src='frame_b.htm' title='bla'></frameset>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_frame_title
			error_messages.should_not be_empty
			error_messages[0].should match("Empty frame title element")
		end

		it "should return error messages when iframe does not have a title" do
			stub_request(:any, "www.example.com").to_return(:body => "<iframe src='www.google.com'></iframe>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_iframe_title
			error_messages.should_not be_empty
			error_messages[0].should match("Missing iframe title element")
		end

		it "should return error messages when iframe title is empty" do
			stub_request(:any, "www.example.com").to_return(:body => "<iframe title='' src='www.google.com'></iframe>", :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_iframe_title
			error_messages.should_not be_empty
			error_messages[0].should match("Empty iframe title element")
		end

		it "should not return error messages when form elements have labels" do
			stub_request(:any, "www.example.com").to_return(:body => '<form><textarea id="area" rows="3" cols="10" /><label for="area" /></form>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_form_labels
			error_messages.should be_empty
		end

		it "should return error messages when form elements have labels" do
			stub_request(:any, "www.example.com").to_return(:body => '<form><textarea id="area" rows="3" cols="10" /></form>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_form_labels
			error_messages.should_not be_empty
		end

		it "should not return error messages when form input (submit|reset|button) elements have value attribs and no labels" do
			stub_request(:any, "www.example.com").to_return(:body => '<form><input id="in" type="button" value="input_value"/></form>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_form_inputs
			error_messages.should be_empty
		end

		it "should return error messages when form input (submit|reset|button) elements have value attribs and labels" do
			stub_request(:any, "www.example.com").to_return(:body => '<form><input id="in" type="button" value="input_value"/><label for="in" /></form>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_form_inputs
			error_messages.should_not be_empty
			error_messages[0].should match("Missing value attribute/label present for input element")
		end

		it "should return error messages when form input (submit|reset|button) elements have no value attribs and labels" do
			stub_request(:any, "www.example.com").to_return(:body => '<form><input id="in" type="button" /><label for="in" /></form>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_form_inputs
			error_messages.should_not be_empty
			error_messages[0].should match("Missing value attribute/label present for input element")
		end

		it "should return error messages when form input (submit|reset|button) elements have no value attribs and no labels" do
			stub_request(:any, "www.example.com").to_return(:body => '<form><input id="in" type="button" /><label for="in" /></form>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_form_inputs
			error_messages.should_not be_empty
			error_messages[0].should match("Missing value attribute/label present for input element")
		end

		it "should not return error messages when form input other than (submit|reset|button) elements have no value attribs and no labels" do
			stub_request(:any, "www.example.com").to_return(:body => '<form><input id="in" type="text" /><label for="in" /></form>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_form_inputs
			error_messages.should be_empty
		end

		it "should not return error messages when labels have text" do
			stub_request(:any, "www.example.com").to_return(:body => '<label for="label1">Label 1</label><label for="label2">Label 2</label>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_form_control_text
			error_messages.should be_empty
		end

		it "should return error messages when labels do not have text" do
			stub_request(:any, "www.example.com").to_return(:body => '<label for="label1">Label 1</label><label for="label2"></label>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_form_control_text
			error_messages.should_not be_empty
			error_messages[0].should match("Missing label text for label")
		end

		it "should not return error messages when legends have text" do
			stub_request(:any, "www.example.com").to_return(:body => '<legend>Legend 1</legend>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_form_control_text
			error_messages.should be_empty
		end

		it "should return error messages when legends do not have text" do
			stub_request(:any, "www.example.com").to_return(:body => '<legend></legend>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_form_control_text
			error_messages.should_not be_empty
			error_messages[0].should match("Missing legend text for legend")
		end

		it "should not return error messages when buttons have text" do
			stub_request(:any, "www.example.com").to_return(:body => '<button type="button">Button 1</button>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_form_control_text
			error_messages.should be_empty
		end

		it "should return error messages when buttons do not have text" do
			stub_request(:any, "www.example.com").to_return(:body => '<button type="button"></button>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_form_control_text
			error_messages.should_not be_empty
			error_messages[0].should match("Missing button text for button")
		end

		it "should return error_messages when document does not have level 1 heading" do
			stub_request(:any, "www.example.com").to_return(:body => '<h2>Heading 2</h2><p><h3>Heading 3</h3></p>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_h1
			error_messages.should_not be_empty
			error_messages[0].should match("Missing heading level 1")
		end

		it "should return error_messages when headings do not have text" do
			stub_request(:any, "www.example.com").to_return(:body => '<p><h1></h1></p><h2>Heading 2</h2><h3></h3>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_heading_text
			error_messages.should_not be_empty
			error_messages[0].should match("Missing text for h1 element")
			error_messages[1].should match("Missing text for h3 element")
		end

		it "should not return error_messages when document has correct heading structure" do
			stub_request(:any, "www.example.com").to_return(:body => '<body><p><h1>Heading 1</h1><h2>Heading 2</h2><p><h3>Heading 3</h3></p></body>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_heading_structure
			error_messages.should be_empty
		end

		it "should return error_messages when document has incorrect heading structure" do
			stub_request(:any, "www.example.com").to_return(:body => '<p><h2>Heading 2</h2><h1>Heading 1</h1><p><h3>Heading 3</h3></p>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_heading_structure
			error_messages.should_not be_empty
			error_messages[0].should match("First heading level should be h1")
		end

		it "should return error_messages when document has incorrect heading structure" do
			stub_request(:any, "www.example.com").to_return(:body => '<p><h1>Heading 1</h1><h3>Heading 3</h3><p><h4>Heading 4</h4></p><h2>Heading 2</h2>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_heading_structure
			error_messages.should_not be_empty
			error_messages[0].should match("Incorrect document heading structure")
		end

		it "should return error_messages when table is missing table headers" do
			stub_request(:any, "www.example.com").to_return(:body => '<table summary="summary"><tr><td>Data 1</td></tr></table>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_table_headers
			error_messages.should_not be_empty
			error_messages[0].should match("Missing table headers for table with summary: summary")
		end

		it "should return error_messages when table headers are missing scope" do
			stub_request(:any, "www.example.com").to_return(:body => '<table summary="summary"><th>Table Heading</th><tr><td>Data 1</td></tr></table>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_table_headers
			error_messages.should_not be_empty
			error_messages[0].should match("Missing scope for table header")
		end

		it "should not return error_messages when table headers has scope" do
			stub_request(:any, "www.example.com").to_return(:body => '<table summary="summary"><th scope="row">Table Heading</th><tr><td>Data 1</td></tr></table>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_table_headers
			error_messages.should be_empty
		end

		it "should return error_messages when table is missing summary" do
			stub_request(:any, "www.example.com").to_return(:body => '<table><th>Table Heading</th><tr><td>Data 1</td></tr></table>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_table_summary
			error_messages.should_not be_empty
			error_messages[0].should match("Missing table summary")
		end

		it "should return error_messages when html lang attribute is not specified" do
			stub_request(:any, "www.example.com").to_return(:body => '<html></html>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_html_lang
			error_messages.should_not be_empty
			error_messages[0].should match("Missing lang attribute for html")
		end

		it "should not return error_messages when html lang attribute is specified" do
			stub_request(:any, "www.example.com").to_return(:body => '<html lang="en"></html>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_html_lang
			error_messages.should be_empty
		end

		it "should return error_messages when html visual formatting elements are used" do
			stub_request(:any, "www.example.com").to_return(:body => '<body><b>Bold text</b><p><i>Italicized Text</i></p></body>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_visual_formatting
			error_messages.should_not be_empty
			error_messages[0].should match("HTML visual formatting elements being used")
		end

		it "should return error_messages when html flashing elements are used" do
			stub_request(:any, "www.example.com").to_return(:body => '<body><blink>Blinking text</blink><p><marquee>Marquee Text</marquee></p></body>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_flashing_content
			error_messages.should_not be_empty
			error_messages[0].should match("Flashing elements")
		end

		it "should return error messages when link text is absent" do
			stub_request(:any, "www.example.com").to_return(:body => '<body><a href="www.google.com"></a></body>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_hyperlinks
			error_messages.should_not be_empty
			error_messages[0].should match("Missing link text for link")
		end

		it "should return error messages when there is duplicate link text" do
			stub_request(:any, "www.example.com").to_return(:body => '<body><a href="www.google.com">Go to Google</a><p><a href="www.google.com">Go to Google</a></p></body>', :status => 200)
			enf = Acop::Enforcer.new({:url => "www.example.com"})
			error_messages = enf.check_hyperlinks
			error_messages.should_not be_empty
			error_messages[0].should match("Links should not have duplicate text")
		end
	end
end
