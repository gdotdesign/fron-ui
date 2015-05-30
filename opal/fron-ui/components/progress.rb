module UI
  # Simple progressbar
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Progress < Base
    tag 'ui-progress'

    component :bar, 'ui-progress-bar'

    style borderRadius: -> { theme.border_radius.em },
          minWidth: -> { (theme.size * 6).em },
          background: -> { colors.input },
          height: -> { 0.8.em },
          'ui-progress-bar' => {
            borderRadius: -> { theme.border_radius.em },
            background: -> { colors.primary },
            transition: 'width 320ms',
            height: :inherit,
            display: :block
          }

    # Initializes the component and sets default value
    def initialize
      super
      self.value = 0
    end

    # Sets the color of the bar
    #
    # @param color [String, Symbol] The color
    def color=(color)
      @bar.style.backgroundColor = color
    end

    # Sets the value
    #
    # @param value [Float] The value (0..1)
    def value=(value)
      value = value.clamp(0, 1) * 100
      @bar.style.width = "#{value}%"
      self[:percent] = "#{value}%"
    end

    # Returns the value
    #
    # @return [Float] The value
    def value
      @bar.style.width.to_i / 100
    end
  end
end
