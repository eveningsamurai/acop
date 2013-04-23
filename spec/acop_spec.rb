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
	end
end
