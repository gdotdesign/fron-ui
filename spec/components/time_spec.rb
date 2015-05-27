require 'spec_helper'

module UI
  # Stub timeout so we don't go into recursion
  class Time < Fron::Component
    def timeout
    end
  end
end

describe UI::Time do
  describe '#recall' do
    it 'should call render' do
      subject.should receive(:render)
      subject.should receive(:timeout).and_yield
      subject.recall
    end
  end

  describe '#value=' do
    it 'should set value' do
      subject.value = Date.parse('2015-01-01')
      subject.text.should eq '2015-01-01'
    end
  end

  context 'From now' do
    before do
      subject.from_now = true
      subject.render
    end

    it 'should render time' do
      subject.text.should eq 'a few seconds ago'
    end
  end
end
