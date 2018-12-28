# frozen_string_literal: true

require 'bunny'

module Totoro
  class BaseQueue
    class <<self
      def config
        @config ||= Totoro::Config.new
      end

      def connection
        @connection ||= Bunny.new(config.connect.merge(threaded: false))
      end

      def broadcast(id, payload)
        Totoro::BroadcastService.new(connection, config).broadcast(id, payload)
      rescue Totoro::ConnectionBreakError => error
        handle_failed_msg(id, payload, error, :broadcast)
      end

      def enqueue(id, payload)
        Totoro::EnqueueService.new(connection, config).enqueue(id, payload)
      rescue Totoro::ConnectionBreakError => error
        handle_failed_msg(id, payload, error, :enqueue)
      end

      private

      def handle_failed_msg(id, payload, error, group)
        Rails.logger.error error.message
        Rails.logger.info 'Add failed message to resend list'
        STDOUT.flush
        @connection = nil
        Totoro::TotoroFailedMessage.create(
          class_name: to_s,
          queue_id: id,
          group: group,
          payload: payload
        )
      end
    end
  end
end
