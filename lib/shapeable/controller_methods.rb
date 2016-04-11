module Shapeable
  module ControllerMethods

    def acts_as_shapeable(**opts)
      normalize_shapeable_options(opts)
      acts_as_shapeable_opts = opts || {}

      define_method(:shape) do |opts={}|
        opts = Shapeable.configuration.as_json.merge(acts_as_shapeable_opts).merge(opts)
        opts = acts_as_shapeable_opts.merge(opts)
        default_shape = opts[:default_shape]
        default_version = opts[:default_version]
        path = opts[:path]
        raise ArgumentError, "Specify a path" unless path
        resource = path.name.split('::').last.constantize
        if request.accept
          version_str = request.accept[/version\s?=\s?(\d+)/, 1]
          version = version_str.nil? ? default_version : version_str.to_i
          shape = request.accept[/shape\s?=\s?(\w+)/, 1] || default_shape
          raise UnresolvedShapeError, "Unable to resolve shape. Try specifying a default version and shape." unless version && shape
          begin
            serializer = path.const_get("V#{version}").const_get("#{resource}#{shape.camelize}Serializer")
          rescue NameError
            raise InvalidShapeError, "Invalid shape. Tried to find version #{version} with shape #{shape}."
          end
        end
        serializer
      end
    end

    private

    def normalize_shapeable_options(opts)
      opts.keep_if do |k, _v|
        [:path, :default_shape, :default_version].include?(k)
      end
    end
  end

  class InvalidShapeError < NameError; end
  class UnresolvedShapeError < Exception; end
end
