module UI
  # Simple Icon component
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Icon < Fron::Component
    tag 'ui-icon.fa'

    stylesheet '//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css'

    style '&.fa' => { justifyContent: :center,
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
      self[:class] = "fa fa-#{value}"
    end
  end
end
