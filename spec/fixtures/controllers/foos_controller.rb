class FoosController < ActionController::Base
  include Rails.application.routes.url_helpers

  acts_as_shapeable(path: Serializers::Foo)

  def show
    render json: Foo.new(first_name: 'Shawn'), serializer: shape(default_version: 1, default_shape: 'foo')
  end

  def index
    render json: [Foo.new], each_serializer: shape(default_version: 1, default_shape: 'short')
  end

end
