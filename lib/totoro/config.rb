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
      @data[:connect]
    end

    def exchange(id)
      @data[:exchange][id][:name]
    end

    def exchange_name_for_queue(queue_id)
      @data[:queue][queue_id][:exchange]
    end

    def clean_start?
      @data[:queue][id][:clean_start]
    end

    def queue(id)
      name = @data[:queue][id][:name]
      settings = { durable: @data[:queue][id][:durable] }
      [name, settings]
    end
  end
end
