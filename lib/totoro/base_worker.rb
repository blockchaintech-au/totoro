# frozen_string_literal: true

module Totoro
  class BaseWorker
    def self.setup(attrs)
      prefix = attrs[:prefix]
      queue_name = attrs[:queue_name]
      define_method('setup') do
        raise(Totoro::NeedQueueNameError) if queue_name.nil?

        @prefix = prefix
        @queue_name = queue_name
      end
    end

    def initialize
      setup
    end

    def execute
      Rails.logger.info 'Listening to the Rabbitmq'
      STDOUT.flush
      subscribe_service.subscribe(@queue_name) do |delivery_info, metadata, payload|
        Rails.logger.info "#{@queue_name} received message"
        STDOUT.flush
        payload_hash = JSON.parse(payload).with_indifferent_access
        process(payload_hash, metadata, delivery_info)
      end
      subscribe_service.channel.work_pool.join
    rescue SignalException
      puts 'Terminating process ..'
      subscribe_service.channel.work_pool.shutdown(true)
      puts 'Stopped.'
    end

    def process; end

    private

    def config
      @config ||= Totoro::Config.new(@prefix)
    end

    def subscribe_service
      @subscribe_service ||= Totoro::SubscribeService.new(config)
    end
  end
end
