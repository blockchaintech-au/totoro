# frozen_string_literal: true

module Totoro
  class InitGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    desc 'Generate totoro config file'

    def copy_config_file
      template 'totoro.yml', File.join('config', 'totoro.yml')
      template 'initializer.rb', File.join('config/initializers', 'totoro.rb')
    end
  end
end
