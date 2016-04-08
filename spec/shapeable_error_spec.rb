require 'spec_helper'

describe BarsController, type: :controller do

  describe '#show' do

    it 'rases an error if no headers and no default serialzer have been specified' do
      request.env['HTTP_ACCEPT'] = 'application/json'
      expect{get :show, id: 1}.to raise_error(Shapeable::UnresolvedShapeError)
    end

  end

end
