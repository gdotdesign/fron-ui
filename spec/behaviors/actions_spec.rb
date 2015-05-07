require 'spec_helper'

module TestClasses
  class Actions < Fron::Component
    include UI::Behaviors::Actions

    component :span, :span, action: :test

    def test
    end
  end
end

describe TestClasses::Actions do
  context 'Has method' do
    let(:event) { double :event, target: { action: 'test' } }

    it 'should handle actions with events' do
      subject.should receive(:test).with kind_of(DOM::Event)
      subject.span.trigger :click
    end

    it 'should stop event' do
      subject.should receive(:test).with event
      event.should receive(:stop)
      subject.handle_action event
    end
  end

  context 'Does not have method' do
    let(:event) { double :event, target: { action: 'boo' } }

    it 'should not stop event if no method exists' do
      event.should_not receive(:stop)
      subject.handle_action event
    end
  end
end
