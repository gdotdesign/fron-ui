require 'spec_helper'

describe UI::Calendar do
  before do
    allow(Date).to receive(:today).and_return Date.parse('2015-05-01')
  end

  context 'This year' do
    it 'should display the active month name' do
      expect(subject.header.label.text).to equal('May')
    end
  end

  context 'Next year' do
    before do
      subject.render(Date.parse('2016-05-01'))
    end

    it 'should display the active month name and year' do
      expect(subject.header.label.text).to equal('May 2016')
    end
  end

  context 'Table' do
    let(:cells) { subject.find_all('tbody td').map(&:text) }
    let(:padding) { 4 }

    it 'should display days' do
      cells[padding..-1].count.should eq 31
    end

    it 'should pad cells' do
      cells[0...padding].should eq ['', '', '', '']
    end
  end

  context 'Clicking on the next month icon' do
    it 'should render the next month' do
      expect {
        subject.find('[action=next_month]').trigger :click
      }.to change { subject.header.label.text }.from('May').to('June')
    end
  end

  context 'Clicking on the previous month icon' do
    it 'should render the previous month' do
      expect {
        subject.find('[action=prev_month]').trigger :click
      }.to change { subject.header.label.text }.from('May').to('April')
    end
  end

  describe '#render' do
    it 'should yield for every day' do
      expect { |b| subject.render(&b) }.to yield_control.exactly(31).times
    end
  end
end
