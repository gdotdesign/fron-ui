module UI
  class Dropdown < Box
    tag 'ui-dropdown[direction=column]'

    style position: :absolute,
          boxShadow: '0 5px 10px -5px rgba(0,0,0,0.75)',
          background: -> { colors.input },
          zIndex: 100,
          left: 0,
          '&[position=top]' => {
            marginBottom: -> { (theme.spacing / 2).em },
            bottom: '100%'
          },
          '&[position=bottom]' => {
            marginTop: -> { (theme.spacing / 2).em },
            top: '100%'
          }

    on :mousedown, :stop

    def initialize
      super
      hide
    end

    def stop(event)
      event.prevent_default
    end

    def open
      show
      self[:position] = parent && (parent.top - DOM::Window.scroll_y) > `window.innerHeight / 2` ? :top : :bottom
    end

    def close
      hide
    end
  end
end
