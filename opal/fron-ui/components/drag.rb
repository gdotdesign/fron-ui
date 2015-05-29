module UI
  # Bi-directoional input component.
  #
  # @see UI::ColorPanel
  # @see UI::Slider
  #
  # @attr value_x [Float] The value of the x axis (0..1)
  # @attr value_y [Float] The value of the y axis (0..1)
  # @attr vertical [Boolean] Whether or not to allow vertical drag
  # @attr horizontal [Boolean] Whether or not to allow horizontal drag
  # @attr_reader drag [Fron::Drag] The drag instance
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  # @abstract
  class Drag < Base
    tag 'ui-drag'

    attr_accessor :vertical, :horizontal
    attr_reader :drag

    component :handle, 'ui-drag-handle'

    style background: -> { colors.input },
          display: 'inline-block',
          position: :relative,
          'ui-drag-handle' => {
            background: -> { rgba(readable_color(colors.input), 0.5) },
            transform: 'translateX(-50%) translateY(-50%)',
            pointerEvents: :none,
            position: :absolute,
            borderRadius: '50%',
            height: 1.em,
            width: 1.em
          }

    # Axes for the drag
    AXES = {
      horizontal: { coord: :x, style: :left, side: :width },
      vertical: { coord: :y, style: :top, side: :height }
    }

    # Initializes the component
    def initialize
      super
      AXES.keys.each { |axis| send("#{axis}=", true) }

      @drag = Fron::Drag.new self, 0
      @drag.on(:move) { |position| on_drag_move position }
    end

    # Moves the handle from the position in each axis
    #
    # @param position [Fron::Point] The point
    def on_drag_move(position)
      point = position - Fron::Point.new(left, top)

      AXES.each do |key, axis|
        next unless send(key)
        @handle.style[axis[:style]] = point.send(axis[:coord]).clamp(0, send(axis[:side])).px
      end

      trigger 'change'
    end

    AXES.values.each do |axis|
      define_method "value_#{axis[:coord]}" do
        @handle.style.send(axis[:style]).to_i / send(axis[:side])
      end

      define_method "value_#{axis[:coord]}=" do |position|
        @handle.style[axis[:style]] = (position.clamp(0, 1) * send(axis[:side])).px
      end
    end
  end
end
