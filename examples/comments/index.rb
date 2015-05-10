require 'fron_ui'

class Header < UI::Container
  style 'ui-label' => { fontWeight: 600 },
        'ui-time, span' => {
          fontSize: 0.85.em,
          lineHeight: 1.5,
          opacity: 0.4
        },
        '&[direction=row]' => {
          '> * + *' => {
            marginLeft: -> { (theme.spacing / 2).em }
          }
        }

  component :user, UI::Label
  component :separator, 'span', html: '-'
  component :date, UI::Time, from_now: true
end

class Footer < UI::Container
  style fontSize: 0.8.em,
        span: { opacity: 0.8 },
        color: -> { dampen colors.font, 0.5 },
        'ui-label' => {
          color: :inherit,
          marginRight: -> { theme.spacing.em }
        },
        'ui-action' => {
          fontWeight: 600
        },
        '&[direction=row]' => {
          '> * + *' => {
            marginLeft: -> { (theme.spacing / 2).em }
          }
        }

  component :vote_up, UI::Action, direction: :row, action: :vote_up do
    component :label, UI::Label, text: 0
    component :icon, UI::Icon, glyph: 'chevron-up'
  end
  component :span, :span, text: '|'
  component :vote_down, UI::Action, action: :vote_down do
    component :icon, UI::Icon, glyph: 'chevron-down'
  end
  component :span, :span, text: '|'
  component :reply, UI::Action, text: 'Reply', action: :reply
end

class Comment < UI::Container
  include UI::Behaviors::Actions
  include ::Record

  tag 'ui-comment'

  style 'ui-image' => { width: 4.em, height: 4.em },
        'ui-comment-body' => {
          paddingBottom: -> { theme.spacing.em },
          borderBottom: -> { "#{(theme.border_size / 2).em} solid #{colors.background}" }
        },
        'ui-comment-body p' => {
          margin: 0,
          '& + p' => {
            marginTop: -> { theme.spacing.em }
          }
        }

  component :image, UI::Image
  component :box, UI::Container, flex: 1 do
    component :header, Header, direction: :row

    component :body, 'ui-comment-body'

    component :footer, Footer, direction: :row
  end

  def initialize
    super
    self[:direction] = :row
  end

  def vote_up
    @data[:votes] = @data[:votes] + 1
    render
  end

  def vote_down
    @data[:votes] = @data[:votes] - 1
    render
  end

  def render
    @box.footer.vote_up.label.text = @data[:votes]
    @image.src = @data[:user][:image]
    @box.body.html = @data[:body]
    @box.header.date.value = @data[:date]
    @box.header.user.text = @data[:user][:name]
  end
end

class List < Collection
  style '> * + *' => { marginTop: -> { (theme.spacing * 2).em } }
end

class Main < UI::Container
  include UI::Behaviors::Actions

  style maxWidth: 42.em,
        margin: '1em auto',
        fontSize: 16.px,
        '> ui-container' => {
          borderBottom: -> { "#{(theme.border_size / 1.5).em} dashed #{colors.border}" },
          paddingBottom: -> { theme.spacing.em },
          marginBottom: -> { theme.spacing.em },
          'ui-button' => {
            maxWidth: 10.em,
            alignSelf: 'flex-end'
          },
          textarea: {
            border: -> { "#{(theme.border_size / 1.5).em} solid #{colors.border}" },
            boxSizing: 'border-box',
            minHeight: 7.em,
            flex: 1
          }
        }

  component :form, UI::Container do
    component :title, UI::Title, text: 'Leave a comment'
    component :box, UI::Container, direction: :row do
      component :image, UI::Image, src: Lorem.avatar, width: 4.em, height: 4.em
      component :input, UI::Textarea
    end
    component :button, UI::Button, text: 'Comment', action: :add
  end

  component :list, List, base: Comment

  def add
    return if @form.box.input.value.empty?

    @items.unshift id: SecureRandom.uuid,
                   date: Time.now,
                   votes: 0,
                   user: {
                     name: name,
                     image: @form.box.image.src
                   },
                   body: @form.box.input.value.split("\n").map { |paragraph| "<p>#{paragraph}</p>" }.join('')

    @form.box.input.value = ''

    render
  end

  def reply
    @form.box.input.focus
  end

  def render
    @list.items = @items
  end

  def name
    @name ||= Lorem.name
  end

  def items=(items)
    @items = items
    render
  end
end

data = (1..3).map do
  {
    id: SecureRandom.uuid,
    votes: rand(0..5),
    date: Date.today - rand(100),
    voted: false,
    user: {
      name: Lorem.name,
      image: Lorem.avatar
    },
    body: Lorem.paragraphs(rand(1..2))
  }
end

main = Main.new
main.items = data

DOM::Document.body << main
