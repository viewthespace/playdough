class FoosController < ActionController::Base
  include Rails.application.routes.url_helpers

  versioner Serializers::Foo

  def show
    render json: Foo.new(first_name: 'Shawn'), serializer: versioner_serializer
  end

  def index
    render json: [Foo.new], each_serializer: versioner_serializer
  end

end  