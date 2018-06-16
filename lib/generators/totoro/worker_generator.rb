# frozen_string_literal: true

module Totoro
  class WorkerGenerator < Rails::Generators::Base
    desc 'Generate totoro worker file'

    source_root File.expand_path('../templates', __FILE__)
    argument :name, type: :string
    argument :queue, type: :string, required: false
    argument :prefix, type: :string, required: false

    def copy_config_file
      template 'worker.rb.erb',
               File.join('app/models/worker', "#{name.underscore}.rb")
    end
  end
end
