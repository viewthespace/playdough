require 'spec_helper'

describe FoosController, type: :controller do
  describe '#show' do
    before do
      Shapeable.configuration.default_version = 1
      Shapeable.configuration.default_shape = 'default'
      Shapeable.configuration.path = Serializers::Bar
    end

    describe 'when request headers are sent' do
      it 'uses the v1 default serializer' do
        request.env['HTTP_ACCEPT'] = 'application/json;'
        get :show, params: { id: 1 }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn v1 default')
      end

      it 'uses the v1 foo full serializer' do
        request.env['HTTP_ACCEPT'] = 'application/json; version=1 shape=full'
        get :show, params: { id: 1 }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn v1 full')
      end

      it 'uses the v2 default serializer' do
        request.env['HTTP_ACCEPT'] = 'application/json; version=2'
        get :show, params: { id: 1 }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn v2 default')
      end

      it 'uses the v2 foo full serializer' do
        request.env['HTTP_ACCEPT'] = 'application/json; version=2 shape=full'
        get :show, params: { id: 1 }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn v2 full')
      end

      it 'uses the v1 foo bar baz serializer' do
        request.env['HTTP_ACCEPT'] = 'application/json; version=1 shape=bar_baz'
        get :show, params: { id: 1 }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn v1 bar baz')
      end
    end

    describe 'when query params are sent' do
      it 'uses the v1 foo full serializer' do
        get :show, params: { id: 1, version: 1, shape: 'full' }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn v1 full')
      end

      it 'uses the v2 default serializer' do
        get :show, params: { id: 1, version: 2 }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn v2 default')
      end

      it 'uses the v2 foo full serializer' do
        get :show, params: { id: 1, version: 2, shape: 'full' }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn v2 full')
      end

      it 'uses the v1 foo bar baz serializer' do
        get :show, params: { id: 1, version: 1, shape: 'bar_baz' }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn v1 bar baz')
      end
    end

    describe 'when no query params or headers are sent' do
      it 'uses the default options' do
        get :show, params: { id: 1 }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn v1 default')
      end
    end

    describe 'when both query params and headers are sent' do
      it 'gives precedence to headers' do
        request.env['HTTP_ACCEPT'] = 'application/json; version=1 shape=bar_baz'
        get :show, params: { id: 1, version: 2, shape: 'full' }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn v1 bar baz')
      end
    end

    describe 'without versioning or shape enforced' do
      before do
        Shapeable.configuration_data.enforce_versioning = false
        Shapeable.configuration_data.enforce_shape = false
        Shapeable.configuration_data.default_shape = nil
      end

      it 'uses the foo full serializer when shape is specified' do
        request.env['HTTP_ACCEPT'] = 'application/json; shape=full'
        get :show, params: { id: 1 }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn full')
      end

      it 'uses the foo (default) serializer when nothing is specified' do
        request.env['HTTP_ACCEPT'] = 'application/json;'
        get :show, params: { id: 1 }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn')
      end
    end

    describe 'with version only' do
      before do
        Shapeable.configuration_data.default_version = 1
        Shapeable.configuration_data.enforce_shape = false
        Shapeable.configuration_data.enforce_versioning = true
        Shapeable.configuration_data.default_shape = nil
        get :show, params: { id: 1 }
      end

      it 'uses the v1 foo serializer' do
        expect(JSON.parse(response.body)['first_name']).to eq('V1 Shawn')
      end
    end

    describe 'overriding attrs' do
      before do
        Shapeable.configuration.default_version = 1
        Shapeable.configuration.default_shape = 'default'
        Shapeable.configuration.path = Serializers::Bar
        Shapeable.configuration.enforce_shape = true
        Shapeable.configuration.enforce_versioning = true
        Shapeable.configuration.shape_attr_override = 'shape_attr'
        Shapeable.configuration.version_attr_override = 'version_attr'
      end

      describe 'when using headers' do
        it 'uses the v1 foo full serializer' do
          request.env['HTTP_ACCEPT'] = 'application/json; version_attr=1 shape_attr=full'
          get :show, params: { id: 1 }
          expect(JSON.parse(response.body)['first_name']).to eq('Shawn v1 full')
        end
      end

      describe 'when using query params' do
        it 'uses the v1 foo full serializer' do
          get :show, params: { id: 1, version_attr: 1, shape_attr: 'full' }
          expect(JSON.parse(response.body)['first_name']).to eq('Shawn v1 full')
        end
      end
    end

    describe 'when default shape is a blank string with no version' do
      before do
        Shapeable.configuration.default_shape = ''
        Shapeable.configuration.enforce_versioning = false
      end

      it 'uses the foo serializer' do
        get :show, params: { id: 1 }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn')
      end
    end
  end
end
