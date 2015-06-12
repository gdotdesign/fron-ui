require 'spec_helper'

describe State do
  subject { described_class.decode(described_class.encode(data)).should eq data }

  context 'Recursive structures' do
    it 'should decode' do
      data = described_class.decode '(key1:value,key2:[value,value2,(key3:value2,key4:[value7])])'
      data.should eq key1: 'value', key2: ['value', 'value2', { key3: 'value2', key4: ['value7'] }]
    end
  end

  context 'Integer' do
    let(:data) { 120 }
    it 'should encode / decode' do
      subject
    end
  end

  context 'Float' do
    let(:data) { 1.221523523 }
    it 'should encode / decode' do
      subject
    end
  end

  context 'Illegal characters' do
    let(:data) { '[[[[())),,,,::]]]]$' }
    it 'should encode them' do
      subject
    end
  end

  context 'Unkown' do
    it 'should throw error' do
      expect {
        described_class.encode(/asd/)
      }.to raise_error('Cannot serialize Regexp, there is no implementation!')
    end
  end

  context 'Full test' do
    let(:data) {
      {
        key1: 'asd',
        key2: 1,
        key3: 1.2,
        key10: '[[[[())),,,,::]]]]@*/+',
        key4: { key5: ['array1', 0.5], key6: { key8: 'asd' } },
        key7: ['asdasd', ['asd'], ['asdasd']]
      }
    }

    it 'should encode & decode' do
      subject
    end
  end
end
