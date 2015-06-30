module Serializers
  module Foo
    module V1

      class FooFullSerializer < ActiveModel::Serializer
        attributes :version

        def version
          'FooFullSerializer v1'
        end

      end

    end
  end
end