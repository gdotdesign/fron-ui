module UI
  # Time component to display static times or
  # times that counts upwards (fromNow), using [Moment.js](http://momentjs.com/).
  #
  # @attr from_now [Bolean] The use the fromNow or not
  # @attr format [String] The format to display
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Time < Fron::Component
    tag 'ui-time'

    attr_accessor :from_now, :format

    # Initializes the component
    def initialize
      super
      render
    end

    # Sets the value (time) of the component
    #
    # @param value [Date, String] The value
    def value=(value)
      @value = if value.is_a? Date
                 Native(`moment(#{value}.date)`)
               else
                 Native(`moment(#{value})`)
               end
    rescue
      @value = nil
    ensure
      render
    end

    # Returns the value
    #
    # @return [Native] The moment wrapped value
    def value
      (@value || Native(`moment()`))
    end

    # Renders the component
    def render
      clear_timeout @id
      request_animation_frame do
        self.text = if @from_now
                      value.fromNow
                    else
                      value.format(@format || 'YYYY-MM-DD')
                    end
      end
      recall
    end

    private

    # Periodically calls render
    def recall
      @id = timeout 1000 do
        render
      end
    end
  end
end
