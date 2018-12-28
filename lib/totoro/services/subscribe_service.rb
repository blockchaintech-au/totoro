# frozen_string_literal: true

module Totoro
  class SubscribeService
    def initialize(config)
      @config = config
    end

    def subscribe(id)
      queue = bind_queue(id)
      queue.subscribe do |delivery_info, metadata, payload|
        yield(delivery_info, metadata, payload)
      end
    end

    def channel
      @channel ||= Bunny.new(@config.connect).tap(&:start).create_channel
    end

    private

    def bind_queue(id)
      exchange_name = @config.exchange_name_for_queue(id)
      if exchange_name.nil?
        channel.queue(*@config.queue(id))
      else
        channel.queue(*@config.queue(id)).bind(exchange_name)
      end
    end
  end
end