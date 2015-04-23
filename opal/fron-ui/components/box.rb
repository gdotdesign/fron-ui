require 'fron-ui/components/container'

module UI
  class Box < Container
    tag 'ui-box'

    style padding: -> { (Config.spacing * 1.75).em },
          borderRadius: -> { (Config.border_radius * 2).em },
          background: -> { Config.colors.background }
  end
end
