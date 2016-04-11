module Shapeable
  class Configuration

    attr_accessor :path, :default_version, :default_shape

    def initialize
      @path = nil
      @default_version = nil
      @default_shape = nil
    end

    def as_json
      {
        path: path,
        default_version: default_version,
        default_shape: default_shape
      }
    end
  end
end
