module Totoro
  class Queue
    class <<self
      def connection
        @connection ||= Bunny.new(Totoro::Config.connect).tap(&:start)
      end

      def channel
        @channel ||= connection.create_channel
      end

      def exchange
        @exchanges ||= channel.default_exchange
      end

      # enqueue = publish to direct exchange
      def enqueue(id, payload)
        queue = channel.queue(*Totoro::Config.queue(id))
        payload = JSON.dump payload
        exchange.publish(payload, routing_key: queue.name)
      end

      def subscribe(id)
        queue = channel.queue(*Totoro::Config.queue(id))
        queue.subscribe do |delivery_info, metadata, payload|
          yield(delivery_info, metadata, payload)
        end
      end
    end
  end
end
