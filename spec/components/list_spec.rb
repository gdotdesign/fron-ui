require 'spec_helper'

describe UI::List do
  describe '#flex=' do
    it 'should set flex' do
      # Phantomjs cannot work with flex...
      subject.flex = 1
    end
  end
end
