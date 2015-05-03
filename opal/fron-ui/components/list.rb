module UI
  # List
  class List < Collection
    tag 'ui-list'

    style overflow: :auto,
          '> *' => {
            display: :block,
            '&:nth-child(even)' => {
              background: -> { colors.background_lighter }
            }
          },
          '&:empty' => {
            padding: -> { theme.spacing.em },
            textAlign: :center,
            display: :flex,
            justifyContent: :center,
            alignItems: :center
          },
          '&:empty:after' => {
            content: 'attr(empty_message)',
            fontSize: 2.em,
            opacity: 0.25
          }

    def flex=(value)
      @style.flex = value
    end
  end
end
