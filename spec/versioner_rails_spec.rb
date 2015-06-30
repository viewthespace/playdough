require 'spec_helper'

describe FoosController, type: :controller do

  it 'uses the v1 default serializer' do
    request.env["HTTP_ACCEPT"] = 'application/json; version=1'
    get :index
    expect(JSON.parse(response.body)['foo']['version']).to eq('FooSerializer v1')
  end

  it 'uses the v1 foo full serializer' do
    request.env["HTTP_ACCEPT"] = 'application/json; version=1 shape=full'
    get :index
    expect(JSON.parse(response.body)['foo_full']['version']).to eq('FooFullSerializer v1')
  end

  it 'uses the v2 default serializer' do
    request.env["HTTP_ACCEPT"] = 'application/json; version=2'
    get :index
    expect(JSON.parse(response.body)['foo']['version']).to eq('FooSerializer v2')
  end

  it 'uses the v2 foo full serializer' do
    request.env["HTTP_ACCEPT"] = 'application/json; version=2 shape=full'
    get :index
    expect(JSON.parse(response.body)['foo_full']['version']).to eq('FooFullSerializer v2')
  end
  
end