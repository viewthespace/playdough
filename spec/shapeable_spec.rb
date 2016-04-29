require 'spec_helper'

describe FoosController, type: :controller do


  describe '#show' do

    before do
      Shapeable.configuration.default_version = 1
      Shapeable.configuration.default_shape = 'default'
      Shapeable.configuration.path = Serializers::Bar
    end

    it 'uses the v1 default serializer' do
      request.env['HTTP_ACCEPT'] = 'application/json;'
      get :show, id: 1
      expect(JSON.parse(response.body)['foo_default']['first_name']).to eq('Shawn v1 default')
    end

    it 'uses the v1 foo full serializer' do
      request.env['HTTP_ACCEPT'] = 'application/json; version=1 shape=full'
      get :show, id: 1
      expect(JSON.parse(response.body)['foo_full']['first_name']).to eq('Shawn v1 full')
    end

    it 'uses the v2 default serializer' do
      request.env['HTTP_ACCEPT'] = 'application/json; version=2'
      get :show, id: 1
      expect(JSON.parse(response.body)['foo_default']['first_name']).to eq('Shawn v2 default')
    end

    it 'uses the v2 foo full serializer' do
      request.env['HTTP_ACCEPT'] = 'application/json; version=2 shape=full'
      get :show, id: 1
      expect(JSON.parse(response.body)['foo_full']['first_name']).to eq('Shawn v2 full')
    end

    it 'uses the no serializer' do
      get :show, id: 1
      expect(JSON.parse(response.body)['first_name']).to eq('Shawn')
    end

    it 'uses the v1 foo bar baz serializer' do
      request.env['HTTP_ACCEPT'] = 'application/json; version=1 shape=bar_baz'
      get :show, id: 1
      expect(JSON.parse(response.body)['foo_bar_baz']['first_name']).to eq('Shawn v1 bar baz')
    end

  end

  describe '#show without versioning or shape enforced' do

    before do
      Shapeable.configuration_data.enforce_versioning = false
      Shapeable.configuration_data.enforce_shape = false
      Shapeable.configuration_data.default_shape = nil
    end

    it 'uses the foo full serializer' do
      request.env['HTTP_ACCEPT'] = 'application/json; shape=full'
      get :show, id: 1
      expect(JSON.parse(response.body)['foo_full']['first_name']).to eq('Shawn full')
    end

    it 'uses the foo full serializer' do
      request.env['HTTP_ACCEPT'] = 'application/json;'
      get :show, id: 1
      expect(JSON.parse(response.body)['foo']['first_name']).to eq('Shawn')
    end

  end

end
