require 'spec_helper'

describe UI::Drag do
  before do
    allow(subject).to receive(:width).and_return 100
    allow(subject).to receive(:height).and_return 100
  end

  context 'Dragging on the component' do
    let(:expectation) { expect { mock_drag subject.drag, 10, 10 } }

    it 'should move the handle horizontally' do
      expectation.to change { subject.handle.style.top }.from('').to('10px')
    end

    it 'should move the handle vertically' do
      expectation.to change { subject.handle.style.left }.from('').to('10px')
    end
  end
end
