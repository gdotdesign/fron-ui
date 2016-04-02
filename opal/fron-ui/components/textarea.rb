module UI
  # Textarea component.
  #
  # @author Gusztáv Szikszai
  # @since  0.1.0
  class Textarea < Input
    tag 'textarea'

    style padding: -> { (theme.spacing / 2).em },
          lineHeight: -> { 1.5.em },
          boxSizing: 'border-box'
  end
end
