# frozen_string_literal: true

module Worker
  class ShuQueue < Totoro::BaseWorker
    setup queue_name: 'shu_queue'
    def process(payload, metadata, delivery_info)
      p payload
    end
  end
end
