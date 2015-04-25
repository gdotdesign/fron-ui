# Main Component
class Main < Fron::Component
  stylesheet '//fonts.googleapis.com/css?family=Open+Sans:400,600,700'

  style fontFamily: -> { UI::Config.font_family },
        padding: -> { UI::Config.spacing.em },
        paddingTop: -> { (UI::Config.spacing * 2).em },
        margin: '0 auto',
        fontSize: 14.px,
        width: 600.px,
        small: {
          padding: -> { UI::Config.spacing.em },
          textAlign: :center,
          display: :block,
          fontSize: 1.em,
          opacity: 0.5
        }

  component :todos, Todos, direction: :column
  component :small, :small, text: 'Example application for Fron-UI.'
end
