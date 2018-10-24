# frozen_string_literal: true

require 'delayed_job_recurring'

module Totoro
  class MessageResender
    include Delayed::RecurringJob
    run_every 10.second
    queue 'totoro'
    def perform
      Totoro::Queue.connection
      Totoro::TotoroFailedMessage.find_in_batches(batch_size: 100) do |message_group|
        message_group.each do |m|
          m.class_name.constantize.enqueue(m.queue_id, m.payload)
          m.destroy
        end
      end
    rescue StandardError => error
      Rails.logger.error error.message
      STDOUT.flush
    end
  end
end