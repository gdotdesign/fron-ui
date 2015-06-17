require 'spec_helper'
require 'fron-ui/examples/comments/components/comments'

describe Examples::Comments do
  let(:user) { { name: 'Test Joe', image: '//placehold.it/250/f9f9f9/333' } }
  let(:items) {
    [
      { id: '0', date: Time.now, user: user, body: '<p>test</p>', votes: 0 }
    ]
  }

  before do
    allow(subject).to receive(:request).with(:get, '').and_yield items
    subject.load
  end

  let(:comment) { subject.find('ui-comment') }

  it 'should display comments' do
    comment.should_not be_nil
  end

  context 'Filling the textarea and clicking on the button' do
    it 'should add a comment' do
      subject.should receive(:request).with(:post,
                                            '',
                                            hash_including(body: '<p>testasd</p>')).and_yield
      subject.input.value = 'testasd'
      expect {
        subject.find('[action=add]').trigger :click
      }.to change { subject.input.value }.from('testasd').to(nil)
    end
  end

  context 'Clicking on reply' do
    it 'should focus the textarea' do
      subject.input.should receive(:focus)
      subject.find('[action=reply]').trigger :click
    end
  end

  context 'Voting up' do
    let(:item) { comment.find('[action=vote_up]') }
    it 'should increase the count' do
      comment.should receive(:request).with(:put,
                                            '0',
                                            hash_including(votes: 1)).and_yield(items[0].merge(votes: 1))
      expect {
        item.trigger :click
      }.to change { item.label.text }.from('0').to('1')
    end
  end

  context 'Voting down' do
    let(:item) { comment.find('[action=vote_down]') }
    it 'should decrease the count' do
      comment.should receive(:request).with(:put,
                                            '0',
                                            hash_including(votes: -1)).and_yield(items[0].merge(votes: -1))
      expect {
        item.trigger :click
      }.to change { comment.find('[action=vote_up]').label.text }.from('0').to('-1')
    end
  end

  context 'Clicking on remove icon' do
    it 'should remove the comment' do
      comment.should receive(:request).with(:delete, '0').and_yield
      comment.find('[action="confirm_destroy!"]').trigger :click
    end
  end
end
