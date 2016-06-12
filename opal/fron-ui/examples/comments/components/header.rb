module Examples
  class Comments < UI::Container
    # Comment header
    class Header < UI::Container
      # Tagname
      tag 'ui-comment-header'

      # Style
      style 'ui-time' => { fontSize: 0.85.em,
                           lineHeight: 1.5,
                           opacity: 0.4,
                           '&:before' => { content: '"-"',
                                           marginRight: -> { (theme.spacing / 2).em } } },
            '&[direction=row]:not([compact]) > * + *' => { marginLeft: -> { (theme.spacing / 2).em } },
            'ui-label' => { fontWeight: 600 },
            'ui-action' => { display: :none }

      # Components
      component :user,   UI::Label
      component :date,   UI::Time, from_now: true
      component :spacer, UI::Base, flex: 1
      component :action, UI::Action, action: :confirm_destroy! do
        component :icon, UI::Icon, glyph: 'android-close'
      end

      # Renders the component
      #
      # @param data [Hash] The data
      def render(data)
        @date.value = data[:date]
        @user.text = data[:user][:name]
      end
    end
  end
end
