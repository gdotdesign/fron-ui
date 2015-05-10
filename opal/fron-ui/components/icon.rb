module UI
  # Icon
  class Icon < Fron::Component
    tag 'ui-icon.fa'

    stylesheet '//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css'

    style '&.fa' => { display: 'inline-flex',
                      justifyContent: :center,
                      alignItems: :center,
                      fontWeight: :normal,
                      '&:not([clickable])' => { pointerEvents: :none },
                      '&[clickable]' => {
                        cursor: :pointer,
                        '&:hover' => { color: -> { colors.focus } }
                      } }

    def glyph=(value)
      self[:class] = "fa fa-#{value}"
    end
  end
end
