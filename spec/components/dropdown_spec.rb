require 'spec_helper'

describe UI::Dropdown do
  describe '#stop' do
    let(:event) { double }
    it 'should stop the event' do
      event.should receive(:prevent_default)
      subject.stop event
    end
  end

  describe '#open' do
    it 'should add open class' do
      expect {
        subject.open
      }.to change { subject.has_class(:open) }.from(false).to(true)
    end

    it 'should set position' do
      expect {
        subject.open
      }.to change { subject[:position] }.from(nil).to(:bottom)
    end
  end

  describe '#close' do
    it 'should remove open class' do
      subject.add_class :open
      expect {
        subject.close
      }.to change { subject.has_class(:open) }.from(true).to(false)
    end
  end
end
