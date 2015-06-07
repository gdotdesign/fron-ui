require 'fron-ui/utils/theme_roller'

# Main Component
class Main < Fron::Component
  # Styles
  style fontFamily: -> { theme.font_family },
        padding: -> { theme.spacing.em },
        paddingTop: -> { (theme.spacing * 2).em },
        margin: '0 auto',
        fontSize: 14.px,
        width: 42.em

  # Components
  component :todos, Todos
  component :theme, ThemeRoller
end
