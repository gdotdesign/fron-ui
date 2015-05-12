module UI
  # Container
  class Container < Base
    tag 'ui-container'

    style display: :flex,
          fontFamily: -> { theme.font_family },
          color: -> { colors.font },
          '&[direction=column]' => {
            flexDirection: :column,

            '&:not([compact]) > * + *' => {
              marginTop: -> { theme.spacing.em }
            }
          },
          '&[direction=row]:not([compact]) > * + *' => {
            marginLeft: -> { theme.spacing.em }
          }

    attribute_accessor :direction

    def initialize
      super
      self[:direction] ||= :column
    end

    def compact=(value)
      if !value
        remove_attribute :compact
      else
        self[:compact] = ''
      end
    end
  end
end
