require 'spec_helper'

describe UI::Input do
  it 'should be an input' do
    subject.tag.should eq :input
    subject[:type].should eq :text
  end
end
