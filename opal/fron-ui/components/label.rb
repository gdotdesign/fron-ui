module UI
  class Label < UI::Base
    tag 'ui-label'

    style color: -> { Config.colors.font }
  end
end
