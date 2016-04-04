module Serializers
  module Foo
    module V2

      class FooDefaultSerializer < ActiveModel::Serializer
        attributes :first_name

        def first_name
          "#{object.first_name} v2 default"
        end

      end

    end
  end
end
