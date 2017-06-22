class FoosController < ActionController::Base
  include Rails.application.routes.url_helpers

  acts_as_shapeable(path: Serializers::Foo)

  def show
    render json: shape.new(Foo.new(first_name: 'Shawn'))
  end
end
