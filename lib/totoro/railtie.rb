# frozen_string_literal: true

require 'totoro'
require 'rails'

module Totoro
  class Railtie < Rails::Railtie
    railtie_name :totoro

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/*.rake").each { |f| load f }
    end
  end
end