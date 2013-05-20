$:.push File.expand_path("../lib", __FILE__)
# Maintain your gem's version:
require "ovh_savoni/version"

Gem::Specification.new do |s|
   s.name = "ovh_savoni"
   s.summary = "OVH SoAPI wrapper"
   s.description = "Super easy access to OVH SoAPI for Ruby >1.9"
   s.version = OvhSavoni::VERSION
   s.authors = "Thibault Poncelet"
   s.email = "thibaultponcelet@gmail.com"
   s.platform = Gem::Platform::RUBY
   s.required_ruby_version = '>=1.9.2'
   s.files = Dir["{lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
   s.has_rdoc = true
   s.test_files  = Dir.glob("spec/**/*.rb")
   s.homepage    = "https://github.com/thibaultponcelet/ovh_savoni"
   s.add_development_dependency 'rspec', '~> 2.5'
   s.add_dependency 'savon', '~> 2.1.0'
   s.add_dependency 'httpclient', '~> 2.2.5'
end
