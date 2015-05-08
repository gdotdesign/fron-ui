module UI
  class Slider < Base
    tag 'ui-slider'

    component :knob, 'ui-knob' do
    end

    def initialize
      super
      self[:tabindex] ||= 0
    end

    private

    def drag
      @drag ||= Fron::Drag.new self
    end

    def range
      (@min - @max).abs
    end
  end
end
