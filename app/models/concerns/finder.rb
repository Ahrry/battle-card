require "active_support/concern"

module Finder
  extend ActiveSupport::Concern

  included do
    def self.find_by_name(name)
      self.where(name: name).first
    end
  end

end
