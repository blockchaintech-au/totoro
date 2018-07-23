# frozen_string_literal: true

module Worker
  class ExampleQueue < Totoro::BaseWorker
    setup queue_name: 'example_queue'
    def process(payload, metadata, delivery_info)
      # worker process
    end
  end
end
