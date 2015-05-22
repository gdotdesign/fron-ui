require 'fron-ui/components/container'

module UI
  # Box component with background, padding
  # and border radius
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Box < Container
    tag 'ui-box'

    style borderRadius: -> { (theme.border_radius * 2).em },
          padding: -> { (theme.spacing * 1.75).em },
          background: -> { colors.background }
  end
end
