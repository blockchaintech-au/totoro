# frozen_string_literal: true

module Totoro
  class EnqueueService
    def initialize(connection, config)
      @connection = connection
      @config = config
    end

    def enqueue(id, payload, attrs = {})
      @connection.start unless @connection.connected?
      queue = channel.queue(*@config.queue(id))
      payload = JSON.dump payload
      exchange.publish(payload, options(id, queue.name, attrs))
      Rails.logger.debug "send message to #{queue.name}"
      STDOUT.flush
      channel.close
    rescue Bunny::TCPConnectionFailedForAllHosts,
           Bunny::NetworkErrorWrapper,
           Bunny::ChannelAlreadyClosed,
           Bunny::ConnectionAlreadyClosed,
           AMQ::Protocol::EmptyResponseError => error
      @channel.close if @channel.present?
      raise(Totoro::ConnectionBreakError, "type: #{error.class}, message: #{error.message}")
    end

    private

    def options(queue_id, queue_name, attrs)
      { persistent: @config.queue_persistent?(queue_id), routing_key: queue_name }.merge(attrs)
    end

    def channel
      @channel ||= @connection.create_channel
    end

    # default exchange is a direct exchange
    def exchange
      @exchange ||= channel.default_exchange
    end
  end
end