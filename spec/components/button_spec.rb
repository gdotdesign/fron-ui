require 'spec_helper'

describe UI::Button do
  before do
    subject.text = 'ads'
  end

  it { subject[:type].should eq :primary }
end
