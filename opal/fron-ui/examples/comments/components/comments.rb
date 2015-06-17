require_relative 'header'
require_relative 'footer'
require_relative 'comment'
require_relative 'list'

module Examples
  class Comments < UI::Container
    # Includes
    include UI::Behaviors::Actions
    include UI::Behaviors::Rest

    # Extends
    extend Forwardable

    tag 'ui-comments'

    # REST
    rest url: 'http://localhost:3000/comments'

    # Style
    style margin: '2em auto',
          maxWidth: 42.em,
          fontSize: 16.px,
          '> ui-container' => { borderBottom: -> { "#{(theme.border_size / 1.5).em} dashed #{dampen colors.background, 0.05}" },
                                paddingBottom: -> { theme.spacing.em },
                                marginBottom: -> { theme.spacing.em },
                                'ui-button' => { maxWidth: 10.em,
                                                 alignSelf: 'flex-end' },
                                textarea: { border: -> { "#{(theme.border_size / 1.5).em} solid #{dampen colors.background, 0.05}" },
                                            boxSizing: 'border-box',
                                            minHeight: 7.em,
                                            flex: 1 } }

    # Components
    component :form, UI::Container do
      component :title, UI::Title, text: 'Leave a comment'
      component :box, UI::Container, direction: :row do
        component :image, UI::Image, src: Lorem.avatar, width: 4.em, height: 4.em
        component :input, UI::Textarea, spellcheck: false
      end
      component :button, UI::Button, text: 'Comment', action: :add
    end
    component :list, List, base: Comment

    # Delegations
    def_delegators :form, :box
    def_delegators :box, :image, :input

    # Events
    on :refresh, :load

    # Adds a new comment
    def add
      return if input.value.empty?

      data = {
        id: SecureRandom.uuid,
        date: Time.now,
        votes: 0,
        user: {
          name: name,
          image: image.src
        },
        body: input.value.split("\n").map { |paragraph| "<p>#{paragraph}</p>" }.join('')
      }

      create data do
        input.value = ''
        load
      end
    end

    # Starts to reply by focusing the input field
    def reply
      input.focus
    end

    # Returns the current users name
    #
    # @return [String] The name
    def name
      @name ||= Lorem.name
    end

    # Loads comments from the server
    def load
      all do |items|
        @list.items = items.reverse
      end
    end
  end
end
