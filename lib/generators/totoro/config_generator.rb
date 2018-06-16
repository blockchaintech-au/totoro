# frozen_string_literal: true

module Totoro
  class ConfigGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    desc 'Generate totoro config file'

    def copy_config_file
      template 'totoro.yml', File.join('config', 'totoro.yml')
    end
  end
end
