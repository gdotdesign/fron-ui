require 'fron-ui/components/container'

module UI
  class Dropdown < Container
    tag 'ui-dropdown[direction=column]'

    style position: :absolute,
          transition: 'opacity 320ms, transform 320ms',
          transform: 'translateY(0.5em)',
          boxShadow: '0 5px 10px -5px rgba(0,0,0,0.75)',
          pointerEvents: :none,
          zIndex: 100,
          opacity: 0,
          left: 0,
          '&.open' => {
            transform: 'translateY(0)',
            pointerEvents: :auto,
            opacity: 1
          },
          '&[position=top]' => {
            marginBottom: -> { (theme.spacing / 2).em },
            bottom: '100%'
          },
          '&[position=bottom]' => {
            marginTop: -> { (theme.spacing / 2).em },
            top: '100%'
          }

    on :mousedown, :stop

    def stop(event)
      event.prevent_default
    end

    def open
      add_class 'open'
      self[:position] = parent && (parent.top - DOM::Window.scroll_y) > `window.innerHeight / 2` ? :top : :bottom
    end

    def close
      remove_class 'open'
    end
  end
end
