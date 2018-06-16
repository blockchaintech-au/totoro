# frozen_string_literal: true

module Totoro
  class Initializer
    DEFAULT_CONFIG = %i[default connect queue].freeze
    def excute
      config = Rails.application.config_for(:totoro).with_indifferent_access
      # set default queue class
      Totoro.const_set('Queue', default_queue_class(config))
      # set custom queue class
      (config.symbolize_keys.keys - DEFAULT_CONFIG).each do |prefix|
        prefix_module(prefix, queue_class(prefix))
      end
    end

    private

    def default_queue_class(config)
      if config.key?(:default)
        queue_class(:default)
      else
        Class.new(Totoro::BaseQueue)
      end
    end

    def queue_class(prefix)
      custom_queue_class = Class.new(Totoro::BaseQueue)
      custom_queue_class.define_singleton_method('config') do
        @config ||= Totoro::Config.new(prefix)
      end
      custom_queue_class
    end

    def prefix_module(prefix, custom_queue_class)
      prefix_module = Totoro.const_set(prefix.camelize, Module.new)
      prefix_module.const_set('Queue', custom_queue_class)
    end
  end
end
