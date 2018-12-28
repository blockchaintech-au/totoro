# frozen_string_literal: true

module Totoro
  class UpdateGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    desc 'Update totoro to 1.0.0'

    def copy_config_file
      template 'update_totoro_failed_messages.rb', File.join('db/migrate', "#{Time.now.strftime('%Y%m%d%H%M%S')}_update_totoro_failed_messages.rb")
    end
  end
end
