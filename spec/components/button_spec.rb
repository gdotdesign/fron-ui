require 'spec_helper'

# Test Container
class TestContainer < UI::Container
  component :button1, UI::Button, text: '01'
  component :button2, UI::Button, text: '02'
end

describe TestContainer do
  it { expect(subject.button1).to be_left_of(subject.button2) }
end

describe UI::Button do
  before do
    subject.text = 'ads'
  end

  it { is_expected.to be_size_of(26, 21) }
  it { subject[:type].should eq :primary }

  describe 'Bigger font size' do
    before do
      subject.style.fontSize = 18.px
    end

    it { is_expected.to be_size_of(29, 24) }
  end
end
