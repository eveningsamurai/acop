require 'optparse'

module Acop
   def self.run(*args)
      options = {}

      option_parser = OptionParser.new do |opts|
         opts.banner = 'Usage: acop [URL]'

         opts.on('-u', '--url URL', 'Url to be accessibility tested') do |tag|
            options[:url] = tag
         end
      end

      begin
         option_parser.parse!
         raise OptionParser::MissingArgument, "Url to be accessibility tested should be provided!" if options.keys.empty?
         raise OptionParser::InvalidArgument, "Cannot resolve url!" unless valid_url(options[:url])?
      rescue OptionParser::ParseError => e
         puts e.message
         puts
         puts option_parser
         exit -1
      end
   end

   def valid_url?(url)
      begin
         contents = open(url)
         return true
      rescue
         return false
      end
   end
end
