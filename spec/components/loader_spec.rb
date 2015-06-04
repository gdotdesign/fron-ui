require 'spec_helper'

describe UI::Loader do
  describe '#loading' do
    it 'should return false if not loading' do
      subject.loading.should eq false
    end
  end
end
