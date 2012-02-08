Gem::Specification.new {|s|
	s.name         = 'dm-unlazy'
	s.version      = '0.0.1.2'
	s.author       = 'meh.'
	s.email        = 'meh@paranoici.org'
	s.homepage     = 'http://github.com/meh/dm-unlazy'
	s.platform     = Gem::Platform::RUBY
	s.summary      = 'Get unlazy collections, for when you know you are going to use all that data anyway.'
	s.files        = Dir.glob('lib/**/*.rb')
	s.require_path = 'lib'

	s.add_dependency 'dm-core'

	s.add_development_dependency 'rake'
	s.add_development_dependency 'rspec'
}
