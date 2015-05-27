module UI
  # Simple label component
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Label < UI::Base
    tag 'ui-label'

    style color: -> { colors.font }
  end
end
