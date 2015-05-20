module UI
  class Drag < Base
    tag 'ui-drag'

    attr_accessor :vertical, :horizontal

    component :handle, 'ui-drag-handle'

    style position: :relative,
          background: -> { colors.input },
          display: 'inline-block',
          'ui-drag-handle' => {
            background: -> { rgba(readable_color(colors.input), 0.5) },
            transform: 'translateX(-50%) translateY(-50%)',
            pointerEvents: :none,
            position: :absolute,
            borderRadius: '50%',
            height: 1.em,
            width: 1.em
          }

    def initialize
      super
      @vertical = true
      @horizontal = true

      drag = Fron::Drag.new self, 0
      drag.on :move do |position|
        point = position - Fron::Point.new(left, top)
        @handle.style.left = point.x.clamp(0, width).px if @horizontal
        @handle.style.top = point.y.clamp(0, height).px if @vertical
        trigger 'change'
      end
    end

    def value_y
      @handle.style.top.to_i / height
    end

    def value_y=(position)
      @handle.style.top = (position.clamp(0, 1) * height).px
    end

    def value_x
      @handle.style.left.to_i / width
    end

    def value_x=(position)
      @handle.style.left = (position.clamp(0, 1) * width).px
    end
  end
end
