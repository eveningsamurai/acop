require './lib/acop/version.rb'

Gem::Specification.new do |s|
  s.name        = 'acop'
  s.version     = Acop::VERSION
  s.date        = '2013-04-22'
  s.summary     = "Accessibility Cop"
  s.description = "A gem to enforce accessibility testing of urls'"
  s.authors     = ["Avinash Padmanabhan"]
  s.email       = ['avinashpadmanabhan@gmail.com']
  s.files       = `git ls-files`.split("\n")
	s.test_files  = ['spec/acop_spec.rb']
  s.homepage    = "https://github.com/eveningsamurai/acop"

	s.add_development_dependency "OptionParser"
	s.add_development_dependency "rspec"
	s.require_paths = ["lib"]

	s.executables << 'acop'

	s.post_install_message = "Thanks for installing Accessibility Cop(acop)!"
end
