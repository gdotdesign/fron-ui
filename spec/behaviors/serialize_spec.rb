require 'spec_helper'

module TestClasses
  class Serialize < Fron::Component
    include UI::Behaviors::Serialize

    component :test, :test, name: 'something'
    component :input, :input, name: 'other'
  end
end

describe TestClasses::Serialize do
  let(:data) { subject.data }

  before do
    subject.input.value = 'Test'
  end

  describe '#data' do
    it 'should return data' do
      data.should have_key(:something)
      data.should have_key(:other)
      data[:other].should eq 'Test'
    end
  end

  describe '#load' do
    it 'should set data' do
      expect {
        subject.load other: 'some data'
      }.to change { subject.input.value }.from('Test').to('some data')
    end
  end
end
