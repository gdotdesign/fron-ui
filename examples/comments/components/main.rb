require 'fron-ui/utils/theme_roller'

class Main < UI::Base
  # Style
  style margin: '2em auto',
        maxWidth: 42.em,
        fontSize: 16.px

  # Components
  component :feed, Feed
  component :theme, ThemeRoller

  # Initializes the component
  # by loading the comments
  def initialize
    super
    @feed.load
  end
end
