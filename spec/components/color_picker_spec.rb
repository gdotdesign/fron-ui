require 'spec_helper'

describe UI::ColorPicker do
  it 'should have a default value' do
    subject.value.should eq '#FFFFFF'
  end

  describe '#value=' do
    context 'Valid' do
      it 'should set the value' do
        expect {
          subject.value = :orangered
        }.to change { subject.input.value }.from('#FFFFFF').to(:orangered)
      end
    end

    context 'Invalid' do
      it 'should_not set the value' do
        expect {
          subject.value = :asd
        }.not_to change { subject.input.value }
      end
    end
  end

  context 'Focusing on the input' do
    it 'should update the dropdown' do
      subject.should receive(:update_dropdown)
      subject.input.trigger :focus
    end
  end

  context 'Setting value' do
    it 'should update dropdown' do
      expect {
        subject.input.value = :orangered
        subject.input.trigger :change
      }.to change { subject.input.value }.from('#FFFFFF').to(:orangered)
    end
  end
end
