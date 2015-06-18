module Examples
  class Contacts < UI::Container
    # Details
    class Details < UI::Box
      include UI::Behaviors::Confirmation
      include UI::Behaviors::Serialize
      include UI::Behaviors::Actions
      include UI::Behaviors::Rest

      tag 'ui-details'

      rest url: 'http://localhost:3000/contacts'

      style 'ui-image' => { margin: -> { theme.spacing.em },
                            height: 15.em,
                            width: 15.em },
            'ui-container' => { padding: -> { theme.spacing.em } },
            'ui-container ui-container' => { maxWidth: 30.em },
            'ui-label' => { fontWeight: 600 },
            'input' => { fontSize: 1.2.em },
            'ui-loader' => { fontSize: 2.em },
            '&.empty' => {
              '> ui-container, > ui-button' => {
                display: :none
              },
              '&:after' => {
                content: "'No contact selected!'",
                padding: -> { (theme.spacing * 3).em },
                textAlign: :center,
                fontSize: 2.em,
                opacity: 0.25
              }
            }

      component :title, UI::Title, text: 'Contact Details'

      component :box, UI::Container, flex: 1, direction: :row do
        component :image, UI::Image
        component :form, UI::Container, flex: 1 do
          component :label, UI::Label, text: 'Full Name:'
          component :input, UI::Input, placeholder: 'Tony Stark', name: :name
          component :label, UI::Label, text: 'E-mail:'
          component :input, UI::Input, placeholder: 'tony@stark-industries.com', name: :email
          component :label, UI::Label, text: 'Address:'
          component :input, UI::Input, placeholder: '10880 Malibu Point, Malibu, Calif', name: :address
          component :label, UI::Label, text: 'Phone:'
          component :input, UI::Input, placeholder: '+1-202-555-0160', name: :phone
        end
      end

      component :button, UI::Button, type: 'danger', text: 'Remove Contact', action: :confirm_destroy!

      confirmation :destroy!, 'Are you sure you want to remove this contact?'

      on :change, :save

      # Loads the contact with the given id
      #
      # @param id [String] The ID
      def load(id)
        return add_class :empty if id.empty?
        request :get, id do |data|
          break add_class :empty unless data
          super data
          remove_class :empty
          render
        end
      end

      # Saves the contact
      def save
        update data do
          @data.merge! data
          render
          trigger :refresh
        end
      end

      # Destroys the contact
      def destroy!
        destroy do
          trigger :destroyed
        end
      end

      # Renders the contact image
      def render
        @box.image.src = 'http://www.gravatar.com/avatar/' + `md5(#{data[:email] || ''})` + '?s=200&d=identicon'
      end
    end
  end
end
