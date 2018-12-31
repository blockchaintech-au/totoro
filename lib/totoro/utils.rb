# frozen_string_literal: true

module Totoro
  class Utils
    def underscore_hash_keys(value)
      case value
      when Array
        value.map { |v| underscore_hash_keys(v) }
      when Hash
        Hash[value.map { |k, v| [underscorize(k), underscore_hash_keys(v)] }]
      else
        value
      end
    end

    private

    def underscorize(hash_key)
      hash_key.to_s.underscore.to_sym
    end
  end
end