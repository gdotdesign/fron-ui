module UI
  class Time < Fron::Component
    tag 'ui-time'

    attr_accessor :from_now, :format

    def initialize
      super
      render
    end

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

    def value
      (@value || Native(`moment()`))
    end

    def render
      clear_timeout @id
      self.text = if @from_now
                    value.fromNow
                  else
                    self.text = value.format(@format || 'YYYY-MM-DD')
                  end
      @id = timeout 1000 do
        render
      end
    end
  end
end
