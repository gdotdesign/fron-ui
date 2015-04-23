require 'fron-ui/components/container'

module UI
  class Box < Container
    tag 'ui-box'

    style padding: -> { (Config.spacing * 1.75).em },
          borderRadius: -> { Config.border_radius.em },
          display: :block,
          background: -> { Config.colors.background }
  end
end
