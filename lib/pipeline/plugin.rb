require 'json'
require 'pathname'
require 'pipeline/client'

module Pipeline
  class Plugin
    def self.run(root)
      plugin = self.new(root)

      Dir.chdir(plugin.root.to_s) do
        EM.run do
          EM.next_tick do
            plugin.run
          end
        end
      end
    end

    attr_reader :root
    def initialize(root)
      @root = Pathname.new(root)
      @config = Hash.new
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
  end
end
