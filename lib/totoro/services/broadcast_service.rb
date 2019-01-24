# frozen_string_literal: true

module Totoro
  class BroadcastService
    def initialize(connection, config)
      @connection = connection
      @config = config
    end

    def broadcast(exchange_id, payload)
      @connection.start unless @connection.connected?
      exchange = channel.fanout(@config.exchange(exchange_id))
      payload = JSON.dump payload
      exchange.publish(payload)
      Rails.logger.debug "send message to exchange #{@config.exchange(exchange_id)}"
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

    def channel
      @channel ||= @connection.create_channel
    end
  end
end