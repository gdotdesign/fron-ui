require 'spec_helper'

describe UI::Progress do
  it 'should have a default value' do
    subject.value.should eq 0
  end

  describe '#value=' do
    it 'should set the value' do
      expect {
        subject.value = 0.1
      }.to change { subject.bar.style.width.to_i }.from(0).to(10)
    end
  end

  describe '#color=' do
    it 'should set the color' do
      expect {
        subject.color = :red
      }.to change { subject.bar.style.backgroundColor }.to('red')
    end
  end
end
