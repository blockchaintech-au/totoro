# frozen_string_literal: true

require 'bunny'

module Totoro
  class BaseQueue
    class <<self
      def config
        @config ||= Totoro::Config.new
      end

      def connection
        @connection ||= Bunny.new(config.connect).tap(&:start)
      end

      def channel
        @channel ||= connection.create_channel
      end

      def exchange
        @exchange ||= channel.default_exchange
      end

      # enqueue = publish to direct exchange
      def enqueue(id, payload)
        queue = channel.queue(*config.queue(id))
        payload = JSON.dump payload
        Rails.logger.info "#{queue.name} Send: #{payload}"
        exchange.publish(payload, routing_key: queue.name)
      end

      def subscribe(id)
        queue = channel.queue(*config.queue(id))
        queue.subscribe do |delivery_info, metadata, payload|
          yield(delivery_info, metadata, payload)
        end
      end

      def get_worker(worker_class)
        ::Worker.const_get(worker_class.to_s.camelize).new
      end
    end
  end
end
