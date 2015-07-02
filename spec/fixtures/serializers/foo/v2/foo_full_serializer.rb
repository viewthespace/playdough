module Serializers
  module Foo
    module V2

      class FooFullSerializer < ActiveModel::Serializer
        attributes :first_name, :last_name

        def first_name
          "#{object.first_name} v2 full"
        end

      end

    end
  end
end