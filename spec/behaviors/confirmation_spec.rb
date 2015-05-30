require 'spec_helper'

module TestClasses
  class Confirmation < Fron::Component
    include UI::Behaviors::Confirmation

    confirmation :remove!, 'Are you sure?'
  end
end

describe TestClasses::Confirmation do
  it 'should have confirmed method' do
    subject.should respond_to(:confirm_remove!)
  end

  context 'Calling the confirmation' do
    it 'should call the method' do
      subject.should receive(:confirm).with('Are you sure?').and_return true
      subject.should receive(:remove!)
      subject.confirm_remove!
    end
  end
end
