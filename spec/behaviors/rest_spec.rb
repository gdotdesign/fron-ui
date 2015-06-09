require 'spec_helper'

module TestClasses
  class Rest < Fron::Component
    include Record
    include UI::Behaviors::Rest

    rest url: '//test'
  end
end

describe TestClasses::Rest do
  let(:request) { double :request }
  let(:resp) { double :response, status: 200, json: {} }

  before do
    subject.data = { id: 0 }
  end

  context 'Requests' do
    before do
      subject.should receive(:create_request).and_return request
    end

    describe '#update' do
      it 'should update the model' do
        request.should receive(:request).with(:PUT,
                                              name: 'test').and_yield resp
        subject.update name: 'test'
      end
    end

    describe '#destroy' do
      it 'should destroy the model' do
        request.should receive(:request).with(:DELETE, {}).and_yield resp
        subject.destroy {}
      end
    end

    describe '#create' do
      it 'should create the model' do
        request.should receive(:request).with(:POST, name: 'test').and_yield resp
        subject.create name: 'test'
      end
    end
  end
end
