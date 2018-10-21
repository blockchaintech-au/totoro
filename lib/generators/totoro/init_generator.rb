# frozen_string_literal: true

module Totoro
  class InitGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    desc 'Generate totoro config file'

    def copy_config_file
      template 'create_totoro_failed_messages.rb', File.join('db/migrate', "#{Time.now.strftime('%Y%m%d%H%M%S')}_create_totoro_failed_messages.rb")
      template 'totoro.yml', File.join('config', 'totoro.yml')
      template 'initializer.rb', File.join('config/initializers', 'totoro.rb')
    end
  end
end
