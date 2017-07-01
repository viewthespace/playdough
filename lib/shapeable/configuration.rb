module Shapeable
  class Configuration

    attr_accessor :path,
      :default_version,
      :default_shape,
      :enforce_versioning,
      :enforce_shape,
      :shape_attr_override,
      :version_attr_override

    def initialize
      @path = nil
      @default_version = nil
      @default_shape = nil
      @enforce_versioning = true
      @enforce_shape = true
      @shape_attr_override = nil
      @version_attr_override = nil
    end

    def as_json
      {
        path: path,
        default_version: default_version,
        default_shape: default_shape,
        enforce_versioning: enforce_versioning,
        enforce_shape: enforce_shape,
        shape_attr_override: shape_attr_override,
        version_attr_override: version_attr_override
      }
    end
  end
end
