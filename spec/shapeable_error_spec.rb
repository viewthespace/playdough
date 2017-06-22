require 'spec_helper'

describe BarsController, type: :controller do

  context 'Shapeable Errors' do
    describe 'when version is enforced but no version is specified' do
      before do
        Shapeable.configuration.default_version = nil
        Shapeable.configuration.default_shape = 'default'
        Shapeable.configuration.path = 'path'
      end

      it 'raises an error' do
        request.env['HTTP_ACCEPT'] = 'application/json'
        expect{get :show, params: { id: 1 }}.to raise_error(Shapeable::Errors::UnresolvedVersionError)
      end
    end

    describe 'when shape is enforced by no shape is specified' do
      before do
        Shapeable.configuration.default_version = 1
        Shapeable.configuration.default_shape = nil
        Shapeable.configuration.path = 'path'
      end

      it 'raises an error' do
        request.env['HTTP_ACCEPT'] = 'application/json'
        expect{get :show, params: { id: 1 }}.to raise_error(Shapeable::Errors::UnresolvedShapeError)
      end
    end

    describe 'when no path is specified' do
      before do
        allow(controller).to receive(:acts_as_shapeable_opts).and_return({})
        Shapeable.configuration.default_version = 1
        Shapeable.configuration.default_shape = 'default'
        Shapeable.configuration.path = nil
      end

      it 'raises an error' do
        request.env['HTTP_ACCEPT'] = 'application/json'
        expect{get :show, params: { id: 1 }}.to raise_error(Shapeable::Errors::UnresolvedPathError)
      end
    end
  end
end
