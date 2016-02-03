# -*- encoding: utf-8 -*-

require File.expand_path('../lib/ph_model/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = 'ph_model'
  gem.version = PhModel::VERSION
  gem.authors = ['Piotr Banasik']
  gem.email = 'piotr@payrollhero.com'

  gem.summary = 'ph-model -- active_model, active_attr brought together at last'
  gem.description = 'Because why do less if you can do more with non db models'
  gem.homepage = 'https://github.com/payrollhero/ph_model'
  gem.license = 'MIT'

  gem.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  gem.bindir = 'exe'
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'activesupport', '> 3.2'
  gem.add_runtime_dependency 'activemodel', '> 3.2'
  gem.add_runtime_dependency 'active_attr', '~> 0.8'

  gem.add_development_dependency 'faraday'
  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'pry', '> 0'
  gem.add_development_dependency 'github_changelog_generator', '~> 1.6'

  # static analysis gems
  gem.add_development_dependency 'rubocop', '~> 0.36.0'
  gem.add_development_dependency 'reek', '~> 3.10'
end
