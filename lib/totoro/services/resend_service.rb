# frozen_string_literal: true

module Totoro
  class ResendService
    def resend_all_messages
      Totoro::TotoroFailedMessage.find_in_batches(batch_size: 100) do |message_group|
        message_group.each { |m| resend_message(m) }
      end
    end

    private

    def resend_message(failed_message)
      queue_class = failed_message.class_name.constantize
      queue_class.method(failed_message.group).call(failed_message.queue_id, failed_message.payload)
      failed_message.destroy
    end
  end
end