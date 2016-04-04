require 'spec_helper'

class Tab < UI::Tabs::Tab
  tag 'div'
  defaults tab_id: 'test',
           tab_title: 'test'
end

class Tab2 < UI::Tabs::Tab
  tag 'div'
  defaults tab_id: 'test2',
           tab_title: 'test2'
end

describe UI::Tabs do
  let(:tab) { Tab.new }
  let(:selected) { subject.find('[tab_id].selected') }

  before do
    subject << tab
  end

  it 'should create tabs' do
    subject.insert_before tab, nil
    subject.handles.children.count.should eq 1
  end

  it 'should select first tab' do
    selected.should_not be_nil
  end

  context 'Selecting an other tab' do
    it 'should deselect active one' do
      tab2 = Tab2.new
      subject << tab2
      expect {
        subject.select tab2
      }.to change { selected.has_class(:selected) }.from(true).to(false)
    end
  end

  context 'Removing an tab' do
    it 'should remove the handler' do
      subject
      expect {
        tab.remove!
      }.to change { subject.handles.children.count }.from(1).to(0)
    end
  end
end
