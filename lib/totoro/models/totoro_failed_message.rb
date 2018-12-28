# frozen_string_literal: true

require 'active_record/railtie'
module Totoro
  class TotoroFailedMessage < ActiveRecord::Base
  end
end
# Totoro.constants.select {|c| Totoro.const_get(c).is_a? Class}