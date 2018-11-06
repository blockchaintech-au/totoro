# frozen_string_literal: true

require 'bunny'

module Totoro
  class BaseQueue
    class <<self
      def config
        @config ||= Totoro::Config.new
      end

      def connection
        @connection ||= Bunny.new(config.connect.merge(threaded: false)).tap(&:start)
      end

      def channel
        @channel ||= connection.create_channel
      end

      def subscribe_channel
        @subscribe_channel ||= Bunny.new(config.connect).tap(&:start).create_channel
      end

      def exchange
        @exchange ||= channel.default_exchange
      end

      # enqueue = publish to direct exchange
      def enqueue(id, payload)
        queue = channel.queue(*config.queue(id))
        payload = JSON.dump payload
        exchange.publish(payload, routing_key: queue.name)
        Rails.logger.info "send message to #{queue.name}"
        STDOUT.flush
      rescue Bunny::TCPConnectionFailedForAllHosts,
             Bunny::NetworkErrorWrapper,
             AMQ::Protocol::EmptyResponseError => error
        handle_failed_msg(id, payload, error)
      end

      def subscribe(id)
        queue = subscribe_channel.queue(*config.queue(id))
        queue.subscribe do |delivery_info, metadata, payload|
          yield(delivery_info, metadata, payload)
        end
      end

      def get_worker(worker_class)
        ::Worker.const_get(worker_class.to_s.camelize).new
      end

      private

      def handle_failed_msg(id, payload, error)
        Rails.logger.error error.message
        Rails.logger.info 'Add failed message to resend list'
        STDOUT.flush
        @connection = nil
        Totoro::TotoroFailedMessage.create(
          class_name: to_s,
          queue_id: id,
          payload: payload
        )
      end
    end
  end
end
