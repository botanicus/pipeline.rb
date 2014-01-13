#!/usr/bin/env gem build

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'pipeline/version'

Gem::Specification.new do |s|
  s.name = 'pipeline.rb'
  s.version = Pipeline::VERSION
  s.authors = ['@botanicus']
  s.homepage = 'http://github.com/botanicus/pipeline.rb'
  s.summary = "Plugin pipeline infrastructure connected through RabbitMQ."
  s.description = "#{s.summary}. Asynchronous and robust. Also contains configuration system."
  s.email = 'james@101ideas.cz'
  s.files = Dir.glob('**/*')
  s.license = 'MIT'
  s.require_paths = ['lib']

  s.add_dependency 'amq-client'
end
