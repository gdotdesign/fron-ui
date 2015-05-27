require 'spec_helper'

describe UI::Title do
  describe '#align=' do
    it 'should set the align' do
      expect {
        subject.align = :center
      }.to change { subject.style.textAlign }.from('').to(:center)
    end
  end
end
