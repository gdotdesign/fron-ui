require 'spec_helper'

describe UI::Checkbox do
  it 'should have tabindex' do
    subject[:tabindex].should eq '0'
  end

  describe '#action' do
    it 'should toggle' do
      expect {
        subject.action
      }.to change { subject.checked }.from(false).to(true)
    end

    it 'should trigger change' do
      expect(subject).to receive(:trigger).with :change
      subject.action
    end
  end
end
