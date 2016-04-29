module Serializers
  module Foo

    class FooSerializer < ActiveModel::Serializer
      attributes :first_name, :last_name

      def first_name
        "#{object.first_name}"
      end

    end

  end
end
