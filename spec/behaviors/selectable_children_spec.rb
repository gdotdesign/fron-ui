require 'spec_helper'

module TestClasses
  class SelectableChildren < Fron::Component
    include UI::Behaviors::SelectableChildren

    component :first, 'span First'
    component :second, 'span Second'
    component :third, 'span Third'
  end
end

describe TestClasses::SelectableChildren do
  describe '#select' do
    it 'should select children' do
      expect(subject).to receive(:trigger).with :selected_change
      expect {
        subject.select_first
      }.to change { subject.children.first.has_class(:selected) }.from(false).to(true)
    end
  end

  context 'Clicking on a child' do
    let(:first) { subject.children.first }
    let(:last) { subject.children.last }

    it 'should select child' do
      expect {
        first.trigger :click
      }.to change { first.has_class(:selected) }.from(false).to(true)
    end

    it 'should de select previous selection' do
      first.trigger :click
      expect {
        last.trigger :click
      }.to change { first.has_class(:selected) }.from(true).to(false)
    end
  end
end
