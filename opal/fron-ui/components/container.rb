module UI
  # Container
  class Container < Base
    tag 'ui-container'

    style display: :flex,
          fontFamily: -> { theme.font_family },
          color: -> { colors.font },
          '&[direction=column]' => {
            flexDirection: :column,

            '> * + *' => {
              marginTop: -> { theme.spacing.em }
            }
          },
          '&[direction=row] > * + *' => {
            marginLeft: -> { theme.spacing.em }
          }

    def initialize
      super
      self[:direction] ||= :column
    end

    def direction
      self[:direction]
    end

    def direction=(value)
      self[:direction] = value
    end
  end
end
