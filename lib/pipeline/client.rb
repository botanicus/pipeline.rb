require 'eventmachine'
require 'amq/client'
require 'json'

# We aren't handling TCP connection lost, since this is running on the same machine.
# It means, however, that if we restart the broker, we have to restart all the services manually.
module Pipeline
  class Client
    def self.boot(config)
      client = self.new

      # Next tick, so we can use it with Thin.
      EM.next_tick do
        client.connect(config.merge(adapter: 'eventmachine'))

        # Set up signals.
        ['INT', 'TERM'].each do |signal|
          Signal.trap(signal) do
            puts "~ Received #{signal} signal, terminating."
            client.disconnect { EM.stop }
          end
        end
      end

      client
    end

    attr_reader :connection, :channel, :exchange, :on_open_callbacks
    def connect(opts)
      @connection = AMQ::Client.connect(opts)
      @channel = AMQ::Client::Channel.new(@connection, 1)
      @on_open_callbacks = Array.new

      @connection.on_open do
        puts "~ Connected to RabbitMQ."

        @channel.open do
          self.on_open_callbacks.each do |callback|
            callback.call
          end
        end
      end
    end

    def exchange
      @exchange ||= AMQ::Client::Exchange.new(@connection, @channel, 'amq.topic')
    end

    def declare_queue(name, routing_key)
      queue = AMQ::Client::Queue.new(@connection, @channel, name)

      queue.declare(false, true, false, true) do
        # puts "~ Queue #{queue.name.inspect} is ready"
      end

      queue.bind(self.exchange.name, routing_key) do
        puts "~ Queue #{queue.name} is now bound to #{self.exchange.name} with #{routing_key}"
      end

      queue
    end

    def consumer(name, routing_key = name, &block)
      queue = self.declare_queue(name, routing_key)

      queue.consume(true) do |consume_ok|
        puts "Subscribed for messages routed to #{queue.name}, consumer tag is #{consume_ok.consumer_tag}, using no-ack mode"

        queue.on_delivery do |basic_deliver, header, payload|
          block.call(payload, header, basic_deliver)
        end
      end
    end

    # This runs after the channel is open.
    def on_open(&block)
      self.on_open_callbacks << block
    end

    def publish(*args)
      self.exchange.publish(*args)
    end

    def disconnect(&block)
      @connection.disconnect(&block)
    end
  end
end
