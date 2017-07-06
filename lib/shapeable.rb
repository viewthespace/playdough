require 'shapeable/version'
require 'shapeable/configuration'
require 'shapeable/shape'
require 'shapeable/errors'
require 'shapeable/extenders'

module Shapeable
  CONFIG_FILE = './config/shapeable.rb'

  class << self
    attr_accessor :configuration_data

    def configure(file = nil)
      configuration
      if block_given?
        yield(configuration)
      else
        if File.exists?(CONFIG_FILE)
          file ||= CONFIG_FILE
          require file
        else
          raise ArgumentError, "Configure requires a block or the existance of a #{CONFIG_FILE} in your project"
        end
      end
    end

    def configuration
      self.configuration_data ||= Shapeable::Configuration.new
    end
  end
end

ActionController::Base.include Shapeable::Shape if defined? ActionController::Base
