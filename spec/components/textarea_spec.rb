require 'spec_helper'

describe UI::Textarea do
  it 'should be an textarea' do
    subject.tag.should eq :textarea
  end
end
