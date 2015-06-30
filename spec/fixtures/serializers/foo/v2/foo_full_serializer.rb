module Serializers
  module Foo
    module V2

      class FooFullSerializer < ActiveModel::Serializer
        attributes :version

        def version
          'FooFullSerializer v2'
        end

      end

    end
  end
end