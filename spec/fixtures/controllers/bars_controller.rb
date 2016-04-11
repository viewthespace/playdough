class BarsController < ActionController::Base
  include Rails.application.routes.url_helpers

  acts_as_shapeable(path: Serializers::Bar)

  def show
    render json: Bar.new(first_name: 'Shawn'), serializer: shape
  end

  def index
    puts shape
    render json: Bar.new(first_name: 'Shawn'), serializer: shape
    puts 'cow'
  end
end
