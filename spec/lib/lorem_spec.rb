require 'spec_helper'

describe Lorem do
  subject { described_class }

  describe '#name' do
    it 'should return a name' do
      first, last = subject.name.split(' ')
      subject::FIRST_NAMES.should include(first)
      subject::LAST_NAMES.should include(last)
    end
  end

  describe '#paragraph' do
    it 'should return a paragraph' do
      paragraph = subject.paragraph
      paragraph.should start_with('<p>')
      paragraph.should end_with('</p>')
    end
  end

  describe '#sentence' do
    it 'return a sentence' do
      sentence = subject.sentence((1..1), '?')
      sentence.should end_with('?')
      sentence[0].should match(/[A-Z]/)
    end
  end

  describe '#sentences' do
    it 'should call sentence count times' do
      subject.should receive(:sentence).twice
      subject.sentences(2)
    end
  end

  describe '#paragraphs' do
    it 'should call paragraph count times' do
      subject.should receive(:paragraph).twice
      subject.paragraphs(2)
    end
  end

  describe '#avatar' do
    it 'should return an avatar' do
      subject.avatar('men', 0).should eq 'https://randomuser.me/api/portraits/men/0.jpg'
    end
  end

  describe '#image' do
    it 'should return an image' do
      subject.image(100, 100).should eq 'http://lorempixum.com/100/100'
    end
  end
end
