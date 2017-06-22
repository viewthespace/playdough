class BarsController < ActionController::Base
  include Rails.application.routes.url_helpers

  acts_as_shapeable(path: Serializers::Bar)

  def show
    render json: shape.new(Bar.new(first_name: 'Shawn'))
  end
end
