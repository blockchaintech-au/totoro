# frozen_string_literal: true

module Worker
  class ExampleQueue < Totoro::BaseWorker
    setup queue_name: 'example_queue'
    def process(payload, metadata, delivery_info)
      (1..10).each do |i|
        p i
        sleep 1
      end
    end
  end
end
