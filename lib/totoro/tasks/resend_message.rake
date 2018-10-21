# frozen_string_literal: true

namespace :totoro do
  desc 'resend failed message'
  task resend_msg: :environment do
    Totoro::MessageResender.schedule!
  end
end