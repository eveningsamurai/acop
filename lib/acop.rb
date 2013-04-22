require 'optparse'
require 'open-uri'

module Acop
   def self.run(*args)
		options = {}

		option_parser = OptionParser.new do |opts|
			opts.banner = 'Usage: acop -u URL'

			opts.on('-u', '--url URL', 'Url to be accessibility tested') do |tag|
				options[:url] = tag
			end
		end

		begin
			option_parser.parse!
			raise OptionParser::MissingArgument, "Url should be provided!" if options.keys.empty?
			raise OptionParser::InvalidArgument, "Url cannot be resolved!" unless valid_url?(options[:url])
		rescue OptionParser::ParseError => e
			puts e.message
			puts
			puts option_parser
			exit -1
		end
	end

   def self.valid_url?(url)
      begin
			url = "http://" + url unless url.include?("http")
         contents = open(url)
         return true
      rescue Exception => e
         return false
      end
   end

end
