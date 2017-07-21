source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gem 'librarian-puppet-simple'

# rake >= 11 does not support ruby 1.8.7
if RUBY_VERSION >= '1.8.7' and RUBY_VERSION < '1.9'
  gem 'rake', '~> 10.0'
else
  gem 'rake'
end
