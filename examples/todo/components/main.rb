# Main Component
class Main < Fron::Component
  # Styles
  style fontFamily: -> { theme.font_family },
        padding: -> { theme.spacing.em },
        paddingTop: -> { (theme.spacing * 2).em },
        margin: '0 auto',
        fontSize: 14.px,
        width: 600.px,
        small: {
          padding: -> { theme.spacing.em },
          textAlign: :center,
          display: :block,
          fontSize: 1.em,
          opacity: 0.5
        }

  # Components
  component :todos, Todos, direction: :column
  component :small, :small, text: 'Example application for Fron-UI.'
end
