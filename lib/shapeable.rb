require 'shapeable/version'

module Shapeable

  def acts_as_shapeable(**opts)

    normalize_options(opts)
    acts_as_shapeable_opts = opts || {}

    define_method(:shape) do |opts|
      opts = acts_as_shapeable_opts.merge(opts)
      default_shape = opts[:default_shape]
      default_version = opts[:default_version]
      path = opts[:path]
      raise ArgumentError, "specify a default shape" unless default_shape
      raise ArgumentError, "specify a default version" unless default_version
      raise ArgumentError, "specify a path" unless path
      resource = path.name.split('::').last.constantize
      if request.accept
        version = request.accept[/version\s?=\s?(\d+)/, 1].to_i.presence || default_version
        shape = request.accept[/shape\s?=\s?(\w+)/, 1] || default_shape
        begin
          serializer = path.const_get("V#{version}").const_get("#{resource}#{shape.camelize}Serializer")
        rescue NameError
          # raise InvalidShapeError.new(version, shape)
          raise InvalidShapeError, 'invalid'
        end
      end
      serializer
    end
  end

  private

  def normalize_options(opts)
    opts.keep_if do |k, _v|
      [:path, :default_shape, :default_version].include?(k)
    end
  end

  class InvalidShapeError < NameError; end

end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    extend Shapeable
  end
end
