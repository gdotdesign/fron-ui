module UI
  class Container < Base
    tag 'ui-container'

    style display: :flex,
          color: -> { Config.colors.font },
          '&[direction=column]' => {
            flexDirection: :column,

            '> * + *' => {
              marginTop: -> { Config.spacing.em }
            }
          },
          '&[direction=row] > * + *' => {
            marginLeft: -> { Config.spacing.em }
          }

    def initialize
      super
      self[:direction] ||= :row
    end
  end
end
