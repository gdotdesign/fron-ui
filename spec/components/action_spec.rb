require 'spec_helper'

describe UI::Action do
  it 'should have tabindex' do
    subject[:tabindex].should eq "0"
  end
end
