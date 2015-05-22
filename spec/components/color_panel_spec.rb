require 'spec_helper'

describe UI::ColorPanel do
  it 'should have a default value' do
    subject.color.hex.should eq 'ffffff'
  end

  context 'Changing the fields' do
    it 'should update the color' do
      expect(subject.hued).to receive(:value_y).and_return 0.5
      expect(subject.rect).to receive(:value_y).and_return 0.5
      expect(subject.rect).to receive(:value_x).and_return 0.5

      subject.hued.trigger :change

      subject.hue.should eq 180
      subject.saturation.should eq 50
      subject.value.should eq 50
    end
  end

  describe '#hue=' do
    it 'should set the value_y of hued' do
      subject.hued.should receive(:value_y=).with(0.5)
      subject.hue = 180
    end
  end

  describe '#value=' do
    it 'should set the value_y of rect' do
      subject.rect.should receive(:value_y=).with(0.5)
      subject.value = 50
    end
  end

  describe '#saturation=' do
    it 'should set the value_y of rect' do
      subject.rect.should receive(:value_x=).with(0.5)
      subject.saturation = 50
    end
  end

  describe '#color=' do
    it 'should set color from CSS' do
      subject.color = :red
      subject.color.hex.should eq 'ff0000'
    end
  end
end
