module Serializers
  module Foo
    module V1

      class FooSerializer < ActiveModel::Serializer
        attributes :version

        def version
          'FooSerializer v1'
        end

      end

    end
  end
end