module Serializers
  module Foo
    module V1

      class FooSerializer < ActiveModel::Serializer
        attributes :first_name, :last_name

        def first_name
          "V1 #{object.first_name}"
        end
      end

    end
  end
end
