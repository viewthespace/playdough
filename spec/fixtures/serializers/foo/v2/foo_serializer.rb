module Serializers
  module Foo
    module V2

      class FooSerializer < ActiveModel::Serializer
        attributes :version

        def version
          'FooSerializer v2'
        end

      end

    end
  end
end