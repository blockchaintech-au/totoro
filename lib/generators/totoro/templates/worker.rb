# frozen_string_literal: true

module Worker
  class <%= name.camelcase %>
    QUEUE = '<%= queue || name.underscore %>'.freeze
    def process(payload, _metadata, _delivery_info)
      # worker process
    end
  end
end
