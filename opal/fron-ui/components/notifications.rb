module UI
  class Notifications < Base
    class Notification < Base
      include UI::Behaviors::Transition

      tag 'ui-notification'

      style background: -> { rgba colors.primary, 0.85 },
            borderRadius: -> { theme.border_radius.em },
            color: -> { readable_color colors.primary },
            fontSize: 1.2.em,
            fontWeight: 600,
            display: :block,
            lineHeight: 1,
            span: {
              display: :block,
              padding: -> { theme.spacing.em },
              paddingBottom: -> { (theme.spacing * 1.2).em }
            }

      component :span, :span

      transition :show, duration: '500ms',
                        frames: { '0%' =>   { opacity: 0 },
                                  '100%' => { opacity: 1 } },
                        callback: :hide
      transition :hide, duration: '500ms',
                        delay: '3s',
                        frames: { '0%' => { opacity: 1 },
                                  '100%' => { opacity: 0 } },
                        callback: :remove!

      def initialize
        super
        transition! :show
      end

      def hide
        transition! :hide
      end
    end

    tag 'ui-notifications'

    style position: :absolute,
          bottom: 1.5.em,
          left: 1.5.em,
          '> * + *' => { marginTop: -> { (theme.spacing / 1.5).em } }

    def push(notification)
      noti = Notification.new
      noti.span.text = notification
      noti >> self
    end
  end
end
