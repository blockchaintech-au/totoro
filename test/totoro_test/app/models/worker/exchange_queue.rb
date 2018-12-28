# frozen_string_literal: true

module Worker
  class ExchangeQueue < Totoro::BaseWorker
    setup queue_name: 'exchange_queue'
    def process(payload, metadata, delivery_info)
      p payload
    end
  end
end
