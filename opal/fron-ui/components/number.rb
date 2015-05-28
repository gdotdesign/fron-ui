require 'fron/utils/drag'

module UI
  # Range input element. This element is editable just like a normal
  # input element can, the difference is that this element is draggable.
  # When dragging the value is incremeted or decremented depending on the
  # direction of the drag. The element can be limited to an upper and a lower value.
  #
  # Options:
  # * label   [String] - The label to be displayed
  # * affix   [String] - The affix (px, %, em, ...)
  # * step    [Float]  - The step modifier to apply to the step, default to 1
  # * default [Float]  - The default value, defaults to 0
  # * min     [Float]  - The minimal possible value, defaults to -infinity
  # * max     [Float]  - The maximum possible value, defaults to infinity
  class NumberRange < Fron::Component
    attr_reader :drag

    tag 'ui-number-range'

    on :keydown,   :keydown
    on :blur,      :blur
    on :input,     :input
    on :mousemove, :on_mouse_move
    on :mousedown, :on_mouse_down

    style position: :relative,
          display: 'inline-block',
          background: -> { colors.input },
          borderRadius: -> { theme.border_radius.em },
          textAlign: :center,
          lineHeight: -> { theme.size.em },
          color: -> { colors.font },
          height: -> { theme.size.em },
          width: -> { (theme.size * 5).em },
          fontWeight: 600,
          '&:focus' => {
            outline: :none,
            boxShadow: -> { theme.focus_box_shadow }
          },
          '&:after, &:before' => {
            borderStyle: :solid,
            position: :absolute,
            marginTop: -0.3.em,
            content: "''",
            top: '50%',
            height: 0,
            width: 0
          },
          '&:after' => {
            borderColor: 'transparent currentColor transparent transparent',
            borderWidth: '0.35em 0.4em 0.35em 0',
            left: 0.75.em
          },
          '&:before' => {
            borderColor: 'transparent transparent transparent currentColor',
            borderWidth: '0.35em 0 0.35em 0.4em',
            right: 0.75.em
          }

    # Creates a new instance
    def initialize
      super

      self['contenteditable'] = true
      self.value = options[:default]

      setup_drag
    end

    # Changes the affix of the input field
    #
    # @param value [String] The new affix
    def affix=(value)
      options[:affix] = value
      self['affix'] = value
    end

    def label=(value)
      self['label'] = value
    end

    def min=(value)
      @options[:min] = value
      reset_value
    end

    def max=(value)
      @options[:max] = value
      reset_value
    end

    def step=(value)
      @options[:step] = value
    end

    def options
      @options ||= { label:   '',
                     affix:   '',
                     step:    1,
                     default: 0,
                     min:     -Float::INFINITY,
                     max:      Float::INFINITY }
    end

    # Returns the value of the field
    #
    # @return [Float] The value of the field
    def value
      @value.to_f
    end

    # Sets the value of the field
    # @param value [type] [description]
    #
    # @return [type] [description]
    def value=(value)
      self.text = @value = value.to_f.clamp(options[:min], options[:max])
      trigger 'change'
    end

    private

    def reset_value
      puts @value, @min
      self.value = @value
    end

    # Sets up dragging.
    def setup_drag
      @drag = Fron::Drag.new self

      @drag.on 'start' do
        @start_value = @value
      end

      @drag.on 'move' do
        DOM::Document.body.style.cursor = 'move'
        value = (@start_value - @drag.diff.x * options[:step]).round(2)
        self.value = value if @value != value
      end

      @drag.on 'end' do
        DOM::Document.body.style.cursor = ''
        blur
      end
    end

    # Runs when input changes. It sets the value if the emelement
    # is not empty, otherwise it inserts a non-width space to prevent
    # caret jumping in chrome.
    def input
      self.html = '&#xfeff;' if text.strip == ''
      @value = text.strip
    end

    # Runs when key is pressed. Prevents hitting the enter key.
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
    # @param event [Event] The event
    def on_mouse_down(event)
      focus
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
