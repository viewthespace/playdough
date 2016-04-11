require 'spec_helper'

describe BarsController, type: :controller do

  describe '#index should use default as defined in configuration' do

    it 'should use version and shape specified in config file' do
      request.env['HTTP_ACCEPT'] = 'application/json'
      get :index
      expect(JSON.parse(response.body)['bar_default']['first_name']).to eq('Shawn v1 default')
    end

  end

end
