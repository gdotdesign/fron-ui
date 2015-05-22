require 'spec_helper'

describe UI::Box do
  it 'should inherit from container' do
    subject.should be_a UI::Container
  end
end
