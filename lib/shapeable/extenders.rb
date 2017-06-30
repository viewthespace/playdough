module Shapeable
  module Extenders

    def acts_as_shapeable(**opts)
      define_method(:acts_as_shapeable_opts) do
        opts
      end
    end

  end
end
