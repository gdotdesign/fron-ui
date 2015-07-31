module UI
  # Component for layout out children either
  # vertically or horizontally using flexbox.
  #
  # Attributes:
  # * *direction*:
  #   * *column* - lays out chilren vertically
  #   * *row* (default) - lays out children horizontally
  # * *compact*:
  #   * *true* - no spacing between the children
  #   * *false* (default) - there is spacing between the children
  #
  # @example
  #   component :box, UI::Container, compact: true, direction: :column
  #
  # @author Gusztáv Szikszai
  # @since  0.1.0
  class Container < Base
    tag 'ui-container'

    style display: :flex,
          fontFamily: -> { theme.font_family },
          '&[direction=column]' => {
            flexDirection: :column,
            '&:not([compact]) > * + *' => {
              marginTop: -> { theme.spacing.em }
            }
          },
          '&[align=center]' => {
            justifyContent: 'center'
          },
          '&[align=end]' => {
            justifyContent: 'flex-end'
          },
          '&[direction=row]:not([compact]) > * + *' => {
            marginLeft: -> { theme.spacing.em }
          }

    attribute_accessor :direction
    attribute_accessor :align

    # Initializes the container by setting
    # default value for direction to column.
    def initialize
      super
      self[:direction] ||= :column
    end

    # Sets / removes the compact attribute
    # based on the value.
    #
    # @param value [Boolean] The value
    def compact=(value)
      if !value
        remove_attribute :compact
      else
        self[:compact] = ''
      end
    end
  end
end
