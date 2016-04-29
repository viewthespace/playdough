module Shapeable
  module Extenders

    def acts_as_shapeable(**opts)
      require_relative 'controller_methods'
      include Shapeable::ControllerMethods

      class_eval do
        define_method(:acts_as_shapeable_opts) do
          opts
        end
      end

    end

  end

end
