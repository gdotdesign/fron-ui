require 'spec_helper'

describe UI::Base do
  describe '#disabled=' do
    it 'should set disabled' do
      expect {
        subject.disabled = true
      }.to change { subject.attribute?(:disabled) }.from(false).to(true)
    end
  end

  describe '#readonly=' do
    it 'should set readonly' do
      expect {
        subject.readonly = true
      }.to change { subject.attribute?(:readonly) }.from(false).to(true)
    end
  end
end
