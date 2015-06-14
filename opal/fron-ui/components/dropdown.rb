require 'fron-ui/components/container'

module UI
  # Component for handling open / closed state
  # and stop events when clicking inside the
  # component to prevent closing.
  #
  # @author Gusztáv Szikszai
  # @since  0.1.0
  class Dropdown < Container
    include UI::Behaviors::Transition

    tag 'ui-dropdown[direction=column]'

    style boxShadow: '0 0.3em 0.625em -0.3em rgba(0,0,0,0.75)',
          transition: 'opacity 320ms, transform 320ms',
          borderRadius: -> { theme.border_radius.em },
          pointerEvents: :none,
          position: :absolute,
          display: :none,
          zIndex: 100,
          '&.open' => { display: :block, pointerEvents: :auto },
          '&[vertical=top]' => { marginBottom: -> { (theme.spacing / 2).em },
                                 bottom: '100%' },
          '&[vertical=bottom]' => { marginTop: -> { (theme.spacing / 2).em },
                                    top: '100%' },
          '&[horizontal=left]' => { right: 0 },
          '&[horizontal=right]' => { left: 0 }

    on :mousedown, :stop

    transition :show, duration: '320ms',
                      frames: { '0%' =>   { opacity: 0, transform: 'translateY(0.5em)' },
                                '100%' => { opacity: 1, transform: 'translateY(0)' } }

    transition :hide, duration: '320ms',
                      frames: { '0%' =>   { opacity: 1, transform: 'translateY(0)' },
                                '100%' => { opacity: 0, transform: 'translateY(0.5em)' } }

    # Stops the event on mousedown
    #
    # :reek:FeatureEnvy
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
      self[:vertical] =  position?(:top, :scroll_y, :innerHeight) ? :top : :bottom
      self[:horizontal] = position?(:left, :scroll_x, :innerWidth) ? :left : :right
      add_class 'open'
      transition! :show
    end

    # Closes the component
    def close
      transition! :hide do
        remove_class 'open'
      end
    end

    private

    # Returns which side to display the dropdown
    # to based on parameters.
    #
    # @param style [Symbol] Which style to use
    # @param scroll [Symbol] Which scroll position to use
    # @param size [Symbol] Which window size to use
    #
    # @return [Bollean] True or False
    def position?(style, scroll, size)
      parent && (parent.send(style) - DOM::Window.send(scroll)) > `window[#{size}] / 2`
    end
  end
end
