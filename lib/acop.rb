require 'optparse'
require 'open-uri'
require_relative 'acop/accessibility.rb'

module Acop
   def self.run(*args)
		options = {}

		option_parser = OptionParser.new do |opts|
			opts.banner = 'Usage: acop [options] [values]'

			opts.on('-u', '--url URL', 'Url to be accessibility tested') do |tag|
				options[:url] = tag
				options[:url] = "http://" + options[:url] unless options[:url].include?("http")
			end

			opts.on('-f', '--file FILEPATH', "File with a list of urls' to be accessibility tested") do |tag|
				options[:file] = tag
			end
		end

		begin
			option_parser.parse!
			raise OptionParser::MissingArgument, "Either Url or FilePath should be provided!" if options.keys.empty?
			raise OptionParser::InvalidArgument, "Both Url and FilePath cannot be specified!" if(options[:url]!=nil and options[:file]!=nil)
			
			if(options[:url]!=nil)
				raise OptionParser::InvalidArgument, "Url cannot be resolved!" unless valid_url?(options[:url])
			end
			if(options[:file]!=nil)
				raise OptionParser::InvalidArgument, "File does not exist or empty!" unless (file_exists?(options[:file]) and file_has_urls?(options[:file]))
			end
		rescue OptionParser::ParseError => e
			puts e.message
			puts
			puts option_parser
			exit -1
		end

		Enforcer.new(options).accessibility_checks
	end

   def self.valid_url?(url)
      begin
         contents = open(url)
         return true
      rescue Exception => e
         return false
      end
   end

	def self.file_exists?(file)
		return File.exists?(file)
	end

	def self.file_has_urls?(file)
		urls = File.readlines(file, 'r')
		return urls.size > 0
	end
end
