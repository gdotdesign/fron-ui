class Footer < UI::Container
  # Tagname
  tag 'comment-footer'

  # Style
  style color: -> { dampen colors.background, 0.3 },
        span: { opacity: 0.8 },
        fontSize: 0.8.em,
        '&[direction=row]:not([compact]) > * + *' => { marginLeft: -> { (theme.spacing / 2).em } },
        'ui-label' => { marginRight: -> { (theme.spacing / 2).em } },
        'ui-action' => { fontWeight: 600 }

  # Components
  component :vote_up, UI::Action, direction: :row, action: :vote_up do
    component :label, UI::Label, text: 0
    component :icon,  UI::Icon, glyph: 'chevron-up'
  end
  component :span, :span, text: '|'
  component :vote_down, UI::Action, action: :vote_down do
    component :icon, UI::Icon, glyph: 'chevron-down'
  end
  component :span, :span, text: '|'
  component :reply, UI::Action, text: 'Reply', action: :reply

  # Renders the component
  #
  # @param data [Hash] The data
  def render(data)
    @vote_up.label.text = data[:votes]
  end
end
