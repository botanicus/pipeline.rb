#!/usr/bin/env bundle exec ruby

require 'mail_queue'

# This is already loaded,
# but just to make it clear
# that the app is actually
# just another plugin.
require 'pipeline/plugin'

$receiver_email = (ARGV.shift || abort("Usage: #{$0} [receiver_email"))

class App < Pipeline::Plugin
  def run
    email = Mail.new do
      from    'james@101ideas.cz'
      to      $receiver_email
      subject "Hello World!"
      body    "Hello World!"
    end

    EM.add_periodic_timer(1.5) do
      puts "~ Publishing #{email.inspect}"
      client.publish(email.to_s, 'emails.random')
    end
  end
end

App.run(Dir.pwd)
