require 'spec_helper'

describe UI::Checkbox do
  it 'should have tabindex' do
    subject[:tabindex].should eq '0'
  end

  it 'should have unique id' do
    subject.input[:id].should_not be_nil
    subject.input[:id].should eq subject.label[:for]
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
