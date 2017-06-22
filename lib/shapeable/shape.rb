require_relative 'errors'
module Shapeable
  module Shape

    def self.included base
      base.class_eval do
        def shape(default_shape_opts = {})
          opts = merge_shapeable_options(
            Shapeable.configuration.as_json,
            acts_as_shapeable_opts,
            default_shape_opts,
            request_shape_options(request)
          )
          normalize_shapeable_options!(opts)
          validate_and_resolve_shape(opts)
        end
      end
    end

    def merge_shapeable_options(*opts)
      opts.each_with_object({}) do |val, obj|
        obj.merge!(val)
      end
    end

    def normalize_shapeable_options!(opts)
      opts.keep_if do |k, _|
        [
          :path,
          :default_shape,
          :default_version,
          :shape,
          :version,
          :enforce_versioning,
          :enforce_shape
        ].include?(k)
      end
    end

    def validate_and_resolve_shape(opts)
      version = opts[:default_version] || opts[:version]
      shape = opts[:default_shape] || opts[:shape]

      if opts[:path].blank?
        raise Shapeable::Errors::UnresolvedPathError
      elsif opts[:enforce_versioning] && version.blank?
        raise Shapeable::Errors::UnresolvedVersionError
      elsif opts[:enforce_shape] && shape.blank?
        raise Shapeable::Errors::UnresolvedShapeError
      end

      if opts[:enforce_versioning]
        construct_constant(opts[:path], shape: shape, version: version)
      else
        construct_constant(opts[:path], shape: shape)
      end
    end

    def request_shape_options(request)
      {
        version: resolve_version(request.accept),
        shape: resolve_shape(request.accept)
      }.delete_if { |_, v| v.blank? }
    end

    def resolve_version(accept_header)
      if accept_header
        version_str = accept_header[/version\s?=\s?(\d+)/, 1]
        version_str.nil? ? nil : version_str.to_i
      end
    end

    def resolve_shape(accept_header)
      accept_header[/shape\s?=\s?(\w+)/, 1] if accept_header
    end

    def construct_constant(path, shape: nil, version: nil)
      resource = infer_resource_name(path)
      if shape
        return path.const_get("#{resource}#{shape.camelize}Serializer") unless version
        path_with_version = path.const_get("V#{version}")
        return path_with_version.const_get("#{resource}#{shape.camelize}Serializer")
      else
        return path.const_get("#{resource}Serializer") unless version
        return path_with_version.const_get("#{resource}Serializer")
      end
    rescue NameError
      raise Shapeable::Errors::InvalidShapeError.new(path, shape, version: version)
    end

    def infer_resource_name(path)
      path.name.split('::').last.constantize
    end
  end
end
