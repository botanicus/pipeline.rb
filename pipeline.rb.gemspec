#!/usr/bin/env gem build

Gem::Specification.new do |s|
  s.name = 'pipeline.rb'
  s.version = '0.0.1'
  s.authors = ['@botanicus']
  s.homepage = 'http://github.com/botanicus/pipeline.rb'
  s.summary = "Plugin pipeline infrastructure connected through RabbitMQ."
  s.description = "" # TODO: long description
  # s.cert_chain = nil
  # s.email = Base64.decode64('c3Rhc3RueUAxMDFpZGVhcy5jeg==\n')
  # s.has_rdoc = true

  # files
  s.files = Dir.glob('**/*')

  s.require_paths = ['lib']

  # Ruby version

  # Dependencies
  # RubyGems has runtime dependencies (add_dependency) and
  # development dependencies (add_development_dependency)
  # Rango isn't a monolithic framework, so you might want
  # to use just one specific part of it, so it has no sense
  # to specify dependencies for the whole gem. If you want
  # to install everything what you need for start with Rango,
  # just run gem install rango --development

  s.add_dependency 'amq-client'

  # RubyForge
  s.rubyforge_project = 'pipeline.rb'
end
