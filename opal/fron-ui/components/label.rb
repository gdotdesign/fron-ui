module UI
  # Label
  class Label < UI::Base
    tag 'ui-label'

    style color: -> { colors.font }
  end
end
