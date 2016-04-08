module Serializers
  module Bar
    module V1

      class BarDefaultSerializer < ActiveModel::Serializer
        attributes :first_name, :last_name

        def first_name
          "#{object.first_name} v1 default"
        end

      end

    end
  end
end
