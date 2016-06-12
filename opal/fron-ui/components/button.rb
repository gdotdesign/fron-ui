require 'fron-ui/components/action'

module UI
  # Button component.
  #
  # It has the following types:
  # * primary
  # * success
  # * danger
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Button < Action
    tag 'ui-button'

    style padding: -> { "0 #{(theme.spacing * 1.4).em}" },
          borderRadius: -> { theme.border_radius.em },
          fontFamily: -> { theme.font_family },
          lineHeight: -> { theme.size.em },
          height: -> { theme.size.em },
          textOverflow: :ellipsis,
          display: 'inline-block',
          whiteSpace: :nowrap,
          textAlign: :center,
          userSelect: :none,
          fontWeight: '600',
          overflow: :hidden,
          '&[type]:focus' => { boxShadow: -> { theme.focus_box_shadow.call } },
          '&[shape=square]' => { minWidth: -> { theme.size.em },
                                 height: -> { theme.size.em },
                                 justifyContent: :center,
                                 display: 'inline-flex',
                                 alignItems: :center,
                                 padding: '0' },
          '> *' => { pointerEvents: :none }

    Fron::Sheet.helper.colors.to_h.keys.each do |type|
      style "&[type=#{type}]" => { color: -> { readable_color(colors[type]) },
                                   background: -> { colors[type] } }
    end

    # Initializes the button by setting
    # the type to primary.
    def initialize
      super
      self[:type] ||= :primary
    end

    def loading!(text = '')
      @_text = self.text
      self.text = text
      self.disabled = true
    end

    def reset!
      self.disabled = false
      self.text = @_text
      @_text = nil
    end
  end
end
