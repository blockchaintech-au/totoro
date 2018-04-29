module Totoro
  class Config
    class <<self
      def data
        @data ||= Rails.application.config_for(:totoro).with_indifferent_access
      end

      def reset_data
        @data = nil
      end

      def connect
        data[:connect]
      end

      def queue(id)
        name = data[:queue][id][:name]
        settings = { durable: data[:queue][id][:durable] }
        [name, settings]
      end

      def get_worker(worker_class)
        ::Worker.const_get(worker_class.to_s.camelize).new
      end
    end
  end
end
