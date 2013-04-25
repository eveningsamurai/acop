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
	end
end
