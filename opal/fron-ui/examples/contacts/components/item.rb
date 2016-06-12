module Examples
  class Contacts < UI::Container
    # Item
    class Item < UI::Container
      include UI::Behaviors::Action
      include ::Record

      tag 'ui-item'

      component :image, UI::Image, width: 2.em, height: 2.em
      component :name, UI::Label

      style padding: -> { (theme.spacing / 2).em },
            lineHeight: 2.em,
            transition: 'border 200ms',
            borderLeft: '0em solid transparent',
            'ui-loader' => { fontSize: 0.6.em },
            '&.selected' => {
              borderLeft: -> { "0.4em solid #{colors.primary}" }
            },
            '&:focus' => {
              borderLeft: -> { "0.4em solid #{colors.focus}" }
            }

      # Initializes the item by setting the direction
      def initialize
        super
        self[:tabindex] = 0
        self[:direction] = :row
      end

      # Returns the id of the item
      #
      # @return [String] The ID
      def id
        @data[:id]
      end

      # Renders the component
      def render
        @image.src = 'http://www.gravatar.com/avatar/' + `md5(#{data[:email] || ''})` + '?s=100&d=identicon'
        @name.text = data[:name] || ' '
      end
    end
  end
end
