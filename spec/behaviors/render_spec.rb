require 'spec_helper'

module TestClasses
  class Render < Fron::Component
    include UI::Behaviors::Render

    render :render_things

    def render_things
    end
  end
end

describe TestClasses::Render do
  describe '#render' do
    it 'should call orginial method' do
      subject.render
    end
  end
end
