require 'spec_helper'

module TestClasses
  class Rest < Fron::Component
    include Record
    include UI::Behaviors::Rest

    rest url: '//test'
  end
end

describe TestClasses::Rest do
  let(:request) { double :request, url: 'test' }
  let(:resp) { double :response, status: 200, json: {} }
  let(:error_resp) { double :response, status: 0, json: {} }

  before do
    subject.data = { id: 0 }
  end

  context 'Real request' do
    xit 'should return request' do
      subject.create_request('/').should be_a(FakeRequest)
    end
  end

  context 'Requests' do
    before do
      subject.should receive(:create_request).and_return request
    end

    context 'Wrong request' do
      xit 'should raise error' do
        subject.should receive(:warn)
        request.should receive(:request).and_yield error_resp
        subject.request :get, '', {}
        nil
      end
    end

    describe '#all' do
      it 'should return all records' do
        request.should receive(:request).with(:GET, {}).and_yield resp
        subject.all
      end
    end

    describe '#update' do
      it 'should update the model' do
        request.should receive(:request).with(:PATCH,
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
