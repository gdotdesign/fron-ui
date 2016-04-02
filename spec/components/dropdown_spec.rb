require 'spec_helper'

describe UI::Dropdown do
  describe '#open' do
    it 'should add open class' do
      expect {
        subject.open
      }.to change { subject.has_class(:open) }.from(false).to(true)
    end

    it 'should set vertical attribute' do
      expect {
        subject.open
      }.to change { subject[:vertical] }.from(nil).to(:bottom)
    end

    it 'should set horizontal attribute' do
      expect {
        subject.open
      }.to change { subject[:horizontal] }.from(nil).to(:right)
    end
  end

  describe '#close' do
    it 'should remove open class' do
      subject.add_class :open
      expect {
        subject.close
        subject.trigger :animationend, animationName: 'ui-dropdown-hide'
      }.to change { subject.has_class(:open) }.from(true).to(false)
    end
  end
end
