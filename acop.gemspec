require './lib/tagfu/version.rb'

Gem::Specification.new do |s|
  s.name        = 'tagfu'
  s.version     = Tagfu::VERSION
  s.date        = '2012-09-22'
  s.summary     = "tagfu"
  s.description = "A gem to manipulate tags in cucumber feature files"
  s.authors     = ["Avinash Padmanabhan"]
  s.email       = ['avinashpadmanabhan@gmail.com']
  s.files       = `git ls-files`.split("\n")
	s.test_files  = ['spec/tagger_spec.rb']
  s.homepage    = "https://github.com/eveningsamurai/tagfu"

	s.add_development_dependency "OptionParser"
	s.add_development_dependency "rspec"
	s.require_paths = ["lib"]

	s.executables << 'tagfu'

	s.post_install_message = "Thanks for installing Tagfu!"
end
