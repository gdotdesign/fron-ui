module UI
  # Simple Icon component
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Icon < Fron::Component
    tag 'ui-icon.fa'

    stylesheet '//code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css'

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
      self[:class] = "ion-#{value}"
    end
  end
end
