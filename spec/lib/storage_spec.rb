require 'spec_helper'

describe Storage do
  subject { described_class.new :test }

  describe '#set' do
    it 'should set record' do
      subject.set '0', test: 'data'
      subject.storage.get('test:0').should eq test: 'data'
    end
  end

  context 'With record' do
    before do
      subject.storage.set 'test:0', test: 'asd'
    end

    describe '#get' do
      it 'should get record' do
        subject.get('0').should eq test: 'asd'
      end
    end

    describe '#remove' do
      it 'should remove record' do
        expect {
          subject.remove '0'
        }.to change { subject.storage.keys.count }.by(-1)
      end
    end

    describe '#all' do
      it 'should return all values' do
        subject.all.count.should eq 1
        subject.all[0].should eq(test: 'asd')
      end
    end
  end
end
