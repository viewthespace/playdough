module Serializers
  module Foo
    module V1

      class FooBarBazSerializer < ActiveModel::Serializer
        attributes :first_name, :last_name

        def first_name
          "#{object.first_name} v1 bar baz"
        end
      
      end
    end
  end
end
