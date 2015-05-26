require 'spec_helper'

describe UI::DatePicker do
  before do
    allow(Date).to receive(:today).and_return Date.parse('2015-01-01')
  end

  it 'should set default value' do
    subject.value.should eq Date.today
  end

  it 'should set selected td' do
    subject.find('.selected')[:date].should eq '2015-01-01'
  end

  context 'Changing the input' do
    it 'should set the value' do
      expect {
        subject.input.value = '2015-05-05'
        subject.input.trigger :change
      }.to change { subject.find('.selected')[:date] }.from('2015-01-01').to('2015-05-05')
    end
  end

  context 'Pressing down' do
    it 'should select next day' do
      expect {
        subject.trigger :keydown, keyCode: 40, shiftKey: false
      }.to change { subject.value }.from(Date.today).to(Date.today + 1)
    end
  end

  context 'Pressing down with shift' do
    it 'should select next day' do
      expect {
        subject.trigger :keydown, keyCode: 40, shiftKey: true
      }.to change { subject.value }.from(Date.today).to(Date.today.next_month)
    end
  end

  context 'Pressing up' do
    it 'should select next day' do
      expect {
        subject.trigger :keydown, keyCode: 38, shiftKey: false
      }.to change { subject.value }.from(Date.today).to(Date.today - 1)
    end
  end

  context 'Pressing up with shift' do
    it 'should select next day' do
      expect {
        subject.trigger :keydown, keyCode: 38, shiftKey: true
      }.to change { subject.value }.from(Date.today).to(Date.today.prev_month)
    end
  end

  context 'Selecting a date' do
    it 'should set the value' do
      expect {
        subject.find('[date="2015-01-21"]').trigger :click
      }.to change { subject.value }.from(Date.today).to(Date.parse('2015-01-21'))
    end
  end
end
