require 'spec_helper'

describe UI::Container do
  it 'should set defaults' do
    subject.direction.should eq :column
  end

  describe '#compact' do
    context 'false' do
      it 'should remvoe compact attribute' do
        subject.compact = false
        expect {
          subject.compact = true
        }.to change { subject.attribute?(:compact) }.from(false).to(true)
      end
    end

    context 'true' do
      it 'should add compact attribute' do
      end
    end
  end
end
