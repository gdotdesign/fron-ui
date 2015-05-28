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
      drag.on(:move) { |position| on_drag_move position }
    end

    def on_drag_move(position)
      point = position - Fron::Point.new(left, top)
      @handle.style.left = point.x.clamp(0, width).px if @horizontal
      @handle.style.top = point.y.clamp(0, height).px if @vertical
      trigger 'change'
    end

    {
      x: [:left, :width],
      y: [:top, :height]
    }.each do |name, args|
      style, side = args
      define_method "value_#{name}" do
        @handle.style.send(style).to_i / send(side)
      end

      define_method "value_#{name}=" do |position|
        @handle.style[style] = (position.clamp(0, 1) * send(side)).px
      end
    end
  end
end
