require 'spec_helper'

module TestClasses
  class Action < Fron::Component
    include UI::Behaviors::Action
  end
end

describe TestClasses::Action do
  describe '#action' do
    it 'should trigger click' do
      subject.should receive(:trigger).with(:click)
      subject.action
    end
  end

  context 'Keys' do
    before do
      subject.should receive(:action)
    end

    context 'Enter' do
      it 'should call action' do
        subject.trigger :keydown, keyCode: 13
      end
    end

    context 'Space' do
      it 'should call action' do
        subject.trigger :keydown, keyCode: 32
      end
    end
  end
end
