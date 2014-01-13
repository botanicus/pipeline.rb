#!/usr/bin/env bundle exec ruby

require 'nake/runner'

# Load all the plugins.
Bundler.require(:plugins)

# Tasks: declare.
require 'pipeline/tasks'

Nake.run
