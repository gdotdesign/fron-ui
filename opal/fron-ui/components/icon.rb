module UI
  # Simple Icon component
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Icon < UI::Base
    tag 'ui-icon'

    style '&[class^=ion]' => { justifyContent: :center,
                               display: 'inline-flex',
                               alignItems: :center,
                               fontWeight: :normal,
                               '&:not([clickable])' => { pointerEvents: :none },
                               '&[clickable]' => { cursor: :pointer,
                                                   '&:hover' => { color: -> { colors.focus } } } }

    # Sets the glyph
    #
    # @param value [String] The glyph
    def glyph=(value)
      self[:glyph] = value
      self[:class] = "ion-#{value}"
    end

    def glyph
      self[:glyph]
    end
  end
end
