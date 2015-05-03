require 'spec_helper'

describe Collection do
  let(:data) { [{ id: 0 }, { id: 1 }] }
  let(:new_data) { [{ id: 2 }, { id: 0 }, { id: 3 } ] }

  before do
    subject.items = data
  end

  context 'Initial state' do
    it 'should create items first time' do
      subject.children.count.should eq 2
    end

    it 'should keep order' do
      subject.items.map { |item| item.data[:id] }.should eq [0, 1]
    end
  end

  context 'Updated state' do
    let(:item1) { subject.items.find { |item| item.data[:id] == 1 } }
    let(:item0) { subject.items.find { |item| item.data[:id] == 0 } }
    let(:expectation) { expect { subject.items = new_data } }

    it 'should remove items' do
      expectation.to change { item1.parent }.to nil
    end

    it 'should reposition items' do
      expectation.to change { item0.index }.from(0).to(1)
    end

    it 'should add new items' do
      expectation.to change { subject.children.count }.from(2).to(3)
    end
  end
end
