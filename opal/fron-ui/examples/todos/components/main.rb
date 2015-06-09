require_relative 'todos'

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
  component :notifications, UI::Notifications

  on :notification, :test

  def test(event)
    @notifications.push event.message
  end

  def initialize
    super
    UI::Behaviors::Rest.on :error do |args|
      @notifications.push args[1]
    end
    @todos.refresh
  end
end
