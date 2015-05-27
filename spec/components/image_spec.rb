require 'spec_helper'

describe UI::Image do
  it 'should listen on load' do
    subject.should receive(:loaded)
    subject.img.trigger :load
  end

  describe '#width=' do
    it 'should set the width of the image' do
      expect {
        subject.width = '100px'
      }.to change { subject.style.width }.from('').to('100px')
    end
  end

  describe '#height=' do
    it 'should set the height of the image' do
      expect {
        subject.height = '100px'
      }.to change { subject.style.height }.from('').to('100px')
    end
  end

  describe '#src=' do
    it 'should set the src of the image' do
      expect {
        subject.src = '//placehold.it/250/f9f9f9/333'
      }.to change { subject.src }.from(nil).to('//placehold.it/250/f9f9f9/333')
    end
  end
end
