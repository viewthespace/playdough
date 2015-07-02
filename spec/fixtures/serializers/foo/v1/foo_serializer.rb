module Serializers
  module Foo
    module V1

      class FooSerializer < ActiveModel::Serializer
        attributes :first_name, :last_name

        def first_name
          "#{object.first_name} v1 default"
        end

      end

    end
  end
end