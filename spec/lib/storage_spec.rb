require 'spec_helper'

describe Storage do
  subject { described_class.new :test }

  describe '#set' do
    it 'should set record' do
      subject.set '0', test: 'data'
      subject.storage.get('test:0').should eq test: 'data'
    end
  end

  describe '#get' do
    it 'should get record' do
      subject.storage.set 'test:0', test: 'asd'
      subject.get('0').should eq test: 'asd'
    end
  end
end
