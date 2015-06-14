require 'spec_helper'

module TestClasses
  class Dropdown < Fron::Component
    include UI::Behaviors::Dropdown

    component :input, :input
    component :dropdown, UI::Dropdown

    dropdown :input, :dropdown
  end
end

describe TestClasses::Dropdown do
  context 'Focusing the input' do
    it 'should open the dropdown' do
      expect {
        subject.input.trigger :focus
      }.to change { subject.dropdown.has_class(:open) }.from(false).to(true)
    end
  end

  context 'Bluring the input' do
    it 'should close the dropdown' do
      subject.dropdown.open
      expect {
        subject.input.trigger :blur
        subject.dropdown.trigger :animationend, animationName: 'ui-dropdown-hide'
      }.to change { subject.dropdown.has_class(:open) }.from(true).to(false)
    end
  end
end
