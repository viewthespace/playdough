module Shapeable
  module Errors
    class InvalidShapeError < NameError
      def initialize(path, version, shape)
        super("Invalid shape #{path}::V#{version}::#{shape.camelize}Serializer")
      end
    end

    class UnresolvedShapeError < Exception
      def initialize(msg = 'Unable to resolve shape.' \
                     ' Try specifying a default version and shape.'
                    )
        super
      end
    end
  end
end
