require 'spec_helper'

describe UI::ColorPanel do
  before do
    subject
  end

  context 'Layout' do
    context 'Saturation / Value field' do
      async 'should be right of hue field' do
        timeout do
          run_async do
            subject.hued.should be_right_of(subject.rect).by(12)
          end
        end
      end
    end

    context 'Hue field' do
      async 'should be left of saturation / value field' do
        timeout do
          run_async do
            subject.rect.should be_left_of(subject.hued).by(12)
          end
        end
      end
    end

    context 'Fields' do
      async 'should have same height' do
        timeout do
          run_async do
            subject.rect.should aligned_horizontally_top(subject.hued)
            subject.rect.should aligned_horizontally_bottom(subject.hued)
          end
        end
      end
    end
  end
end
