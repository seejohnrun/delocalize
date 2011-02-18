require File.dirname(__FILE__) + '/lib/delocalize/version'

spec = Gem::Specification.new do |s|
  
  s.name = 'delocalize'
  s.author = 'John Crepezzi'
  s.add_dependency('nokogiri')
  s.add_dependency('activesupport', '3.0.3')
  s.add_dependency('actionpack', '3.0.3')
  s.add_development_dependency('actionpack')
  s.add_development_dependency('rspec-core')
  s.add_development_dependency('rspec-mocks')
  s.add_development_dependency('rspec-expectations')
  s.description = 'Write views in your native language without sacrificing i18n'
  s.email = 'john.crepezzi@gmail.com'
  s.files = Dir['lib/**/*.rb']
  s.has_rdoc = true
  s.homepage = 'http://seejohnrun.github.com/delocalize/'
  s.platform = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.summary = 'Write views in your native language'
  s.test_files = Dir.glob('spec/*.rb')
  s.version = Delocalize::VERSION
  s.rubyforge_project = 'delocalize'

end
