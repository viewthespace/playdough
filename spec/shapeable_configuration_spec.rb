require 'spec_helper'

describe BarsController, type: :controller do
  describe '#show' do
    describe 'when only config file options specified' do
      #spec/fixtures/config/shapeable.rb

      it 'uses defaults specified in config file' do
        request.env['HTTP_ACCEPT'] = 'application/json'
        get :show, params: { id: 1 }
        expect(JSON.parse(response.body)['first_name']).to eq('Shawn v1 default')
      end
    end
  end
end
