module UI
  class Dropdown < Box
    tag 'ui-dropdown[direction=column]'

    style position: :absolute,
          boxShadow: '0 5px 10px -5px rgba(0,0,0,0.75)',
          background: -> { colors.background_lighter },
          marginTop: -> { (theme.spacing / 2).em },
          zIndex: 100,
          '&[position=bottom]' => {
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
    end

    def close
      hide
    end
  end
end
