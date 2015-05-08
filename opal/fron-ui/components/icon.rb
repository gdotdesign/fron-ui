module UI
  # Icon
  class Icon < Fron::Component
    tag 'ui-icon'

    stylesheet '//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css'

    style display: 'flex !important',
          justifyContent: :center,
          alignItems: :center,
          '&:not([clickable])' => { pointerEvents: :none },
          '&[clickable]' => {
            cursor: :pointer,
            '&:hover' => { color: -> { colors.focus } }
          }

    def glyph=(value)
      self[:class] = "fa fa-#{value}"
    end
  end
end
