# frozen_string_literal: true

module Totoro
  class Config
    def initialize(prefix = nil)
      @data = Rails.application.config_for(:totoro).with_indifferent_access
      @data = @data[prefix] if prefix.present?
    end

    def reset_data
      @data = nil
    end

    def connect
      @data[:connect].merge(threaded: false)
    end

    def queue(id)
      name = @data[:queue][id][:name]
      settings = { durable: @data[:queue][id][:durable] }
      [name, settings]
    end
  end
end
