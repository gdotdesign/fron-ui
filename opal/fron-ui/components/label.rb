module UI
  class Label < UI::Base
    tag 'ui-label'

    style color: -> { colors.font }
  end
end
