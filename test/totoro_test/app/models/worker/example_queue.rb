# frozen_string_literal: true

module Worker
  class ExampleQueue < Totoro::BaseWorker
    setup queue_name: 'example_queue'
    def process(payload, _metadata, _delivery_info)
      p payload
    end
  end
end
