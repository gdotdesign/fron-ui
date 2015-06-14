require 'spec_helper'

describe UI::Tabs do
  let(:tab) { UI::Tabs::Tab.new('div[tab=test]') }
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
      tab2 = UI::Tabs::Tab.new('div[tab=test2]')
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
