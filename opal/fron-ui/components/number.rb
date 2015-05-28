require 'fron/utils/drag'

module UI
  # Range input element. This element is editable just like a normal
  # input element can, the difference is that this element is draggable.
  # When dragging the value is incremeted or decremented depending on the
  # direction of the drag. The element can be limited to an upper and a lower value.
  #
  # Attributes:
  # * label   [String] - The label to be displayed
  # * affix   [String] - The affix (px, %, em, ...)
  # * step    [Float]  - The step modifier to apply to the step, default to 1
  # * min     [Float]  - The minimal possible value, defaults to -infinity
  # * max     [Float]  - The maximum possible value, defaults to infinity
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class NumberRange < Fron::Component
    class Input < Fron::Component
      tag 'ui-number-range-input'

      attribute_accessor :label
      attribute_accessor :affix

      style borderRadius: -> { theme.border_radius.em },
            lineHeight: -> { theme.size.em },
            background: -> { colors.input },
            height: -> { theme.size.em },
            color: -> { colors.font },
            textAlign: :center,
            display: :block,
            fontWeight: 600,
            '&:before' => { content: 'attr(label)',
                            marginRight: 0.2.em,
                            fontWeight: :normal },
            '&:after' => { content: 'attr(affix)' },
            '&:focus' => { boxShadow: -> { theme.focus_box_shadow },
                           outline: :none }
    end

    extend Forwardable

    attr_reader :drag

    tag 'ui-number-range'

    component :input, Input, contenteditable: true

    def_delegators :@input, :affix=, :affix, :label=, :label

    on :keydown,   :keydown
    on :input,     :input
    on :mousemove, :on_mouse_move
    on :mousedown, :on_mouse_down
    on 'attribute:changed', :reset_value

    attribute_accessor :step,  default: 1,                coerce: :to_f
    attribute_accessor :round, default: 1,                coerce: :to_f
    attribute_accessor :max,   default: Float::INFINITY,  coerce: :to_f
    attribute_accessor :min,   default: -Float::INFINITY, coerce: :to_f

    style minWidth: -> { (theme.size * 5).em },
          display: 'inline-block',
          position: :relative,
          '&:after, &:before' => { borderStyle: :solid,
                                   position: :absolute,
                                   marginTop: -0.3.em,
                                   content: "''",
                                   top: '50%',
                                   height: 0,
                                   width: 0 },
          '&:after' => { borderColor: 'transparent currentColor transparent transparent',
                         borderWidth: '0.35em 0.4em 0.35em 0',
                         left: 0.75.em },
          '&:before' => { borderColor: 'transparent transparent transparent currentColor',
                          borderWidth: '0.35em 0 0.35em 0.4em',
                          right: 0.75.em }

    # Creates a new instance
    def initialize
      super
      @input.on :blur do blur end
      self.value = 0
      setup_drag
    end

    # Returns the value of the field
    #
    # @return [Float] The value of the field
    def value
      @value.to_f
    end

    # Sets the value of the field
    #
    # @param value [Float] The value
    def value=(value)
      @value = value.to_f.clamp(min, max)
      @input.text = format "%.#{round}f", @value
      trigger 'change'
    end

    private

    # Resets the value when attribute changes
    def reset_value
      self.value = value
    end

    # Sets up dragging.
    def setup_drag
      @drag = Fron::Drag.new self, 0

      @drag.on('start') { @start_value = value }
      @drag.on('move')  { on_drag_move  }
      @drag.on('end')   { on_drag_end   }
    end

    # Runs when drag end
    def on_drag_end
      DOM::Document.body.style.cursor = ''
      blur
    end

    # Runs when drag moves
    def on_drag_move
      DOM::Document.body.style.cursor = 'move'
      value = (@start_value - @drag.diff.x * step).round(round)
      self.value = value if @value != value
    end

    # Runs when input changes. It sets the value if the emelement
    # is not empty, otherwise it inserts a non-width space to prevent
    # caret jumping in chrome.
    def input
      @input.html = '&#xfeff;' if text.strip == ''
    end

    # Runs when key is pressed. Prevents hitting the enter key.
    #
    # :reek:FeatureEnvy
    #
    # @param event [Event] The event
    def keydown(event)
      event.prevent_default if event.keyCode == 13
    end

    # Runs when the element is blurred. Sets the value form
    # the elements text.
    def blur
      self.value = text
    end

    # Runs on pointer move. Sets the cursor to move when not
    # in the center of the element
    #
    # @param event [Event] The event
    def on_mouse_move(event)
      @style.cursor = in_select_region?(event.page_x) ? '' : 'move'
    end

    # Runs on pointer down. Prevents propagation so dargging
    # cannot start.
    #
    # :reek:FeatureEnvy
    #
    # @param event [Event] The event
    def on_mouse_down(event)
      @input.focus
      if in_select_region?(event.page_x)
        event.stop_immediate_propagation
      else
        event.prevent_default
      end
    end

    # Returns form to position if it is in the region that
    # allow selection.
    #
    # @param position [type] The position (horizontal) to be checked
    #
    # @return [Boolean] True if the position is in the region otherwise false.
    def in_select_region?(position)
      (left + width / 2 - position).abs <= 50
    end
  end
end
