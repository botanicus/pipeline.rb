require 'json'
require 'pathname'
require 'pipeline/client'

module Pipeline
  class Plugin
    def self.plugins
      @@plugins ||= Array.new
    end

    def self.inherited(subclass)
      Pipeline::Plugin.plugins << subclass
    end

    def self.run(root)
      plugin = self.new(root)

      Dir.chdir(plugin.root.to_s) do
        EM.run do
          # First runs next tick from Client.boot.
          EM.next_tick do
            plugin.run!
          end
        end
      end
    end

    attr_reader :root
    def initialize(root)
      @root = Pathname.new(root)
      @config = Hash.new

      self.client
    end

    def config(key)
      @config[key] ||= begin
        path = self.root.join("config/#{key}.json")
        data = JSON.parse(path.read)

        path = self.root.join("config/#{key}.local.json")
        data.merge!(JSON.parse(path.read)) if path.exist?

        data.reduce(Hash.new) do |buffer, (key, value)|
          buffer.merge!(key.to_sym => value)
        end
      end
    end

    def client
      @client ||= Pipeline::Client.boot(self.config('amqp'))
    end

    def run!
      self.client.on_open do
        EM.add_timer(0.1) do # Oh my, yeah, whatever, it's for now only, dammit!
          puts "~ Running #{self.class}#run."
          self.run
        end
      end
    end
  end
end
