# frozen_string_literal: true

module Totoro
  class BaseWorker
    def self.setup(attrs)
      prefix = attrs[:prefix].present? ? attrs[:prefix] : :default
      queue_name = attrs[:queue_name]
      define_method('setup') do
        raise(Totoro::NeedQueueNameError) if queue_name.nil?
        @prefix = prefix
        @queue_name = queue_name
      end
    end

    def initialize
      setup
      @queue_class = queue_class
    end

    def execute
      @queue_class.subscribe(@queue_name) do |delivery_info, metadata, payload|
        Rails.logger.info "#{@queue_name} received message"
        payload_hash = JSON.parse(payload).with_indifferent_access
        process(payload_hash, metadata, delivery_info)
      end
      Rails.logger.info 'Listening to the Rabbitmq'
      @queue_class.channel.work_pool.join
    end

    def process; end

    private

    def queue_class
      if @prefix == :default
        Totoro::Queue
      else
        "Totoro::#{@prefix.to_s.camelize}::Queue".constantize
      end
    end
  end

  class NeedQueueNameError < RuntimeError; end
end