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

    def queue_persistent?(id)
      !!@data[:queue][id][:persistent]
    end

    def exchange_persistent?(id)
      !!@data[:exchange][id][:persistent]
    end

    def clean_start?(id)
      !!@data[:queue][id][:clean_start]
    end

    def manual_ack?(id)
      !!@data[:queue][id][:manual_ack]
    end

    def force_ack?(id)
      manual_ack?(id) && !!@data[:queue][id][:force_ack]
    end

    def queue(id)
      name = @data[:queue][id][:name]
      settings = { durable: @data[:queue][id][:durable] }
      [name, settings]
    end
  end
end
