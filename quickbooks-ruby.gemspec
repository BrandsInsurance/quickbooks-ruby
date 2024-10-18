$:.unshift File.expand_path('../lib', __FILE__)

require 'quickbooks/version'

Gem::Specification.new do |gem|
  gem.authors = ['Brands Insurance', 'Cody Caughlan']
  gem.files = Dir['lib/**/*']
  gem.name = 'quickbooks-ruby'
  gem.summary = 'REST API to Quickbooks Online'
  gem.version = Quickbooks::VERSION

  gem.description = 'QBO V3 REST API to Quickbooks Online'
  gem.email = ['noreply@wcpermit.com']
  gem.homepage = 'https://github.com/BrandsInsurance/quickbooks-ruby/tree/2-stable'
  gem.license = 'MIT'
  gem.required_ruby_version = '>= 3.1.6', '< 3.5.0'

  gem.metadata['bug_tracker_uri'] = 'https://github.com/BrandsInsurance/quickbooks-ruby/issues'
  gem.metadata['changelog_uri'] = 'https://github.com/BrandsInsurance/quickbooks-ruby/blob/2-stable/HISTORY.md'
  gem.metadata['documentation_uri'] = 'https://github.com/BrandsInsurance/quickbooks-ruby/blob/2-stable/README.md'
  gem.metadata['homepage_uri'] = gem.homepage

  gem.add_dependency 'oauth2', '~> 2.0', '< 3'
  gem.add_dependency 'roxml', '~> 4.2'
  gem.add_dependency 'activemodel', '> 4.0', '< 8'
  gem.add_dependency 'net-http-persistent'
  gem.add_dependency 'nokogiri' # promiscuous mode
  gem.add_dependency 'multipart-post' # promiscuous mode
  gem.add_dependency 'faraday', '< 3.0'
  gem.add_dependency 'faraday-multipart', '~> 1.0', '>= 1.0.4'
  gem.add_dependency 'faraday-gzip', '>= 1.0'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'rr'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'dotenv'
end
