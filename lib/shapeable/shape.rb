require_relative 'errors'
module Shapeable
  module Shape

    def self.included base
      base.class_eval do
        def shape(shape_opts = {})
          return unless request.accept
          opts = merge_shapeable_options(
            Shapeable.configuration.as_json, acts_as_shapeable_opts, shape_opts
          )
          normalize_shapeable_options(opts)
          raise ArgumentError, 'Specify a path' unless opts[:path]
          shape = resolve_shape(request.accept, opts[:default_shape])
          if opts[:enforce_versioning]
            version = resolve_version(request.accept, opts[:default_version])
            raise Shapeable::Errors::UnresolvedShapeError unless version && shape if opts[:enforce_shape]
            constant = construct_constant(opts[:path], shape: shape, version: version)
          else
            raise Shapeable::Errors::UnresolvedShapeError unless shape if opts[:enforce_shape]
            constant = construct_constant(opts[:path], shape: shape)
          end
          constant
        end
      end
    end

    def normalize_shapeable_options(opts)
      opts.keep_if do |k, _v|
        [:path, :default_shape, :default_version, :enforce_versioning, :enforce_shape].include?(k)
      end
    end

    def merge_shapeable_options(*opts_array)
      opts_array.each_with_object({}) do |val, obj|
        obj.merge!(val)
      end
    end

    def resolve_version(accept_header, default)
      version_str = accept_header[/version\s?=\s?(\d+)/, 1]
      version_str.nil? ? default : version_str.to_i
    end

    def resolve_shape(accept_header, default)
      accept_header[/shape\s?=\s?(\w+)/, 1] || default
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
