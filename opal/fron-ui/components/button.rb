require 'fron-ui/components/action'

module UI
  # Simple Button Component
  class Button < Action
    tag 'ui-button'

    style fontFamily: -> { theme.font_family },
          display: 'inline-block',
          padding: -> { "0 #{(theme.spacing * 1.4).em}" },
          borderRadius: -> { theme.border_radius.em },
          whiteSpace: :nowrap,
          textAlign: :center,
          userSelect: :none,
          height: -> { theme.size.em },
          lineHeight: -> { theme.size.em },
          fontWeight: '600',
          overflow: :hidden,
          textOverflow: :ellipsis,
          '&[type]:focus' => {
            boxShadow: -> { theme.focus_box_shadow }
          },
          '&[shape=square]' => {
            justifyContent: :center,
            alignItems: :center,
            display: :flex,
            height: -> { theme.size.em },
            minWidth: -> { theme.size.em },
            padding: '0'
          },
          '&[disabled]' => {
            opacity: 0.4
          },
          '> *' => {
            pointerEvents: :none
          }

    Fron::Sheet.helper.colors.to_h.keys.each do |type|
      style "&[type=#{type}]" => { color: -> { readable_color(colors[type]) },
                                   background: -> { colors[type] } }
    end

    def initialize
      super
      self[:type] ||= :primary
    end
  end
end
