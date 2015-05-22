require 'fron-ui/components/container'

module UI
  # Component for handling open / closed state
  # and stop events when clicking inside the
  # component to prevent closing.
  #
  # @author Gusztáv Szikszai
  # @since  0.1.0
  class Dropdown < Container
    tag 'ui-dropdown[direction=column]'

    style boxShadow: '0 0.3em 0.625em -0.3em rgba(0,0,0,0.75)',
          transition: 'opacity 320ms, transform 320ms',
          transform: 'translateY(0.5em)',
          pointerEvents: :none,
          position: :absolute,
          zIndex: 100,
          opacity: 0,
          '&.open' => {
            transform: 'translateY(0)',
            pointerEvents: :auto,
            opacity: 1
          },
          '&[vertical=top]' => {
            marginBottom: -> { (theme.spacing / 2).em },
            bottom: '100%'
          },
          '&[vertical=bottom]' => {
            marginTop: -> { (theme.spacing / 2).em },
            top: '100%'
          },
          '&[horizontal=left]' => {
            right: 0
          },
          '&[horizontal=right]' => {
            left: 0
          }

    on :mousedown, :stop

    # Stops the event on mousdown
    #
    # @param event [DOM::Event] The event
    def stop(event)
      event.prevent_default
    end

    # Opens the component:
    #
    # * adds the *open* class
    # * sets the *position* attribute to either top or bottom depending
    #   where is more space in the screen
    def open
      add_class 'open'
      self[:vertical] = parent && (parent.top - DOM::Window.scroll_y) > `window.innerHeight / 2` ? :top : :bottom
      self[:horizontal] = parent && (parent.left - DOM::Window.scroll_x) > `window.innerWidth / 2` ? :left : :right
    end

    # Closes the component
    def close
      remove_class 'open'
    end
  end
end
