require 'spec_helper'

describe UI::NumberRange do
  let(:input) { subject.find('ui-number-range-input') }

  before do
    allow(subject).to receive(:width).and_return 200
  end

  it 'should have a default value' do
    subject.value.should eq 0
  end

  describe '#on_mouse_move' do
    it 'should set the cursor' do
      expect {
        subject.trigger :mousemove, pageX: 10
      }.to change { subject.style.cursor }.from('').to('move')
    end
  end

  describe '#input' do
    it 'should set placeholder character' do
      expect {
        subject.text = ''
        subject.input
      }.to change { input.html }.from('0.0').to(`'\ufeff'`)
    end
  end

  describe '#keydown' do
    let(:event) { double key: :enter }
    it 'should prevent the event' do
      event.should receive(:prevent_default)
      subject.keydown event
    end
  end

  context 'Changing the maximum value' do
    it 'should reset the value' do
      subject.value = 100
      expect {
        subject.max = 10
      }.to change { subject.value }.from(100).to(10)
    end
  end

  context 'Bluring the input' do
    it 'should set the value' do
      input.text = 10
      expect {
        input.trigger :blur
      }.to change { subject.value }.from(0).to(10)
    end
  end

  context 'Dragging horizontally' do
    it 'should increase the value' do
      expect {
        mock_drag subject.drag, 10, 10
      }.to change { subject.value }.from(0).to(10)
    end
  end
end
