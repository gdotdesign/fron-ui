module UI
  class Icon < Fron::Component
    tag 'ui-icon'

    stylesheet '//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css'

    style pointerEvents: :none,
          display: 'flex !important',
          justifyContent: :center,
          alignItems: :center

    def glyph=(value)
      self[:class] = "fa fa-#{value}"
    end
  end
end
