require 'spec_helper'

describe UI::Base do
  describe '#disabled=' do
    it 'should set disabled' do
      expect {
        subject.disabled = true
      }.to change { subject.attribute?(:disabled) }.from(false).to(true)
    end
  end
end
