# frozen_string_literal: true

require 'delayed_job_recurring'

module Totoro
  class MessageResender
    include Delayed::RecurringJob
    run_every 10.second
    queue 'totoro'
    def perform
      Totoro::ResendService.new.resend_all_messages
    rescue StandardError => error
      Rails.logger.error error.message
      STDOUT.flush
    end
  end
end
