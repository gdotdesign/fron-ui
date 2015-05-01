require 'fron-ui/components/container'

module UI
  # Box component
  class Box < Container
    tag 'ui-box'

    style padding: -> { (theme.spacing * 1.75).em },
          borderRadius: -> { (theme.border_radius * 2).em },
          background: -> { colors.background }
  end
end
