require 'spec_helper'

describe UI::Chooser do
  before do
    subject.items = [{ id: 0, value: 'Test' }, { id: 1, value: 'Asd' }]
  end

  it 'should render items' do
    subject.find_all('ui-chooser-item').count.should eq 2
  end

  context 'Focusing the input' do
    let(:expectation) { expect { subject.input.trigger :focus } }

    it 'should set focused attribute' do
      expectation.to change { subject.attribute?(:focused) }.from(false).to(true)
    end

    it 'should empty the input' do
      subject.input.value = 'test'
      expectation.to change { subject.input.value }.from('test').to(nil)
    end
  end

  context 'Bluring the input' do
    let(:expectation) { expect { subject.input.trigger :blur } }

    it 'should remove focused attribute' do
      subject[:focused] = true
      expectation.to change { subject.attribute?(:focused) }.from(true).to(false)
    end

    it 'should update the input field' do
      subject.select_first
      subject.input.value = ''
      expectation.to change { subject.input.value }.from(nil).to('Test')
    end
  end

  context 'Selecting inteded item' do
    it 'should select it' do
      expect {
        subject.intend_next
        subject.select_intended
        subject.intend_previous
      }.to change { subject.value }.from(nil).to('Test')
    end
  end

  describe '#value' do
    context 'Nothing selected' do
      it 'should return nil' do
        subject.value.should eq nil
      end
    end

    context 'One selected' do
      it 'should return single value' do
        expect {
          subject.select_first
        }.to change { subject.value }.from(nil).to('Test')
      end
    end

    context 'Multiple selected' do
      it 'should return single value' do
        expect {
          subject.multiple = true
          subject.select_last
          subject.select_first
        }.to change { subject.value }.from(nil).to(%w(Test Asd))
      end
    end
  end
end
