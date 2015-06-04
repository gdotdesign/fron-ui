module UI
  # List component
  #
  # Features:
  # * Empty message display in an :after element
  # * Striped backgrounds for items
  # * Overflow auto
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class List < Collection
    tag 'ui-list'

    style overflow: :auto,
          '> *' => { display: :block,
                     '&:nth-child(even)' => { background: -> { dampen colors.background, 0.025 } } },
          '&:empty' => { padding: -> { theme.spacing.em },
                         justifyContent: :center,
                         alignItems: :center,
                         textAlign: :center,
                         display: :flex },
          '&:empty:after' => { content: 'attr(empty_message)',
                               fontSize: 2.em,
                               opacity: 0.25 }

    # Sets the flex value
    #
    # @param value [Numeric] The value
    def flex=(value)
      @style.flex = value
    end
  end
end
