$:.unshift File.expand_path('../lib', __FILE__)

require 'quickbooks/version'

Gem::Specification.new do |gem|
  gem.name = 'quickbooks-ruby-2'
  gem.version = Quickbooks::VERSION

  gem.authors = ['Brands Insurance', 'Cody Caughlan']
  gem.email = ['westchesterpermitit@gmail.com']
  gem.homepage = 'https://github.com/BrandsInsurance/quickbooks-ruby/tree/master'
  gem.summary = 'REST API to Quickbooks Online'
  gem.license = 'MIT'
  gem.description = 'QBO V3 REST API to Quickbooks Online'

  gem.files = Dir['lib/**/*']
  gem.required_ruby_version = Gem::Requirement.new('>= 2.5.3')

  gem.add_dependency 'oauth2', '~>1.4'
  gem.add_dependency 'roxml', '~> 4.2'
  gem.add_dependency 'activemodel', '> 4.0'
  gem.add_dependency 'net-http-persistent'
  gem.add_dependency 'nokogiri' # promiscuous mode
  gem.add_dependency 'multipart-post' # promiscuous mode
  gem.add_dependency 'faraday', '< 2.0'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'rr'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'dotenv'
end
