class FooController < ApplicationController

  versioner Serlizers::Foo

  def show
    render json: Foo.find(params[:id])
  end

  def index
    render json: Foo.all
  end

  def create
    Foo.create(params)
  end

end  