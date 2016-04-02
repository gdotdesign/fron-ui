require 'spec_helper'
require 'fron-ui/examples/todos/components/todos'

describe Examples::Todos do
  let(:items) { [{ done: false, id: 1, test: 'Todo Item #1' }] }
  let(:item) { subject.find('ui-todo-item') }

  before do
    allow(subject).to receive(:request).with(:get, '').and_yield items
    subject.refresh
  end

  it 'should display items' do
    item.should_not be_nil
  end

  context 'Clicking on item' do
    it 'should destroy it' do
      expect(item).to receive(:request).with(:delete, 1).and_yield
      item.find('[action="confirm_destroy!"]').trigger :click
    end
  end

  context 'Checking an item' do
    it 'should update it' do
      expect(item).to receive(:request).with(:patch, 1, done: true).and_yield
      item.checkbox.trigger :click
    end
  end

  context 'Adding an item' do
    it 'should create it' do
      data = hash_including text: 'Test', done: false
      expect(subject).to receive(:request).with(:post, '', data).and_yield
      subject.header.input.value = 'Test'
      subject.header.button.trigger :click
    end
  end
end
