require 'spec_helper'

describe UI::Slider do
  before do
    allow(subject).to receive(:width).and_return 100
  end

  it 'should have tabindex' do
    subject.tabindex.should eq '0'
  end

  describe '#value' do
    it 'should return value' do
      subject.value.should eq 0
    end
  end

  describe '#value=' do
    it 'should set the value' do
      expect {
        subject.value = 0.5
      }.to change { subject.handle.style.left }.from('').to('50px')
    end
  end
end
