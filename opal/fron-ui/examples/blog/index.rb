require 'fron_ui'

class Item < UI::Container
  include UI::Behaviors::Rest
  include ::Record

  style padding: -> { theme.spacing.em },
        '> span' => { fontWeight: 600 },
        small: { opacity: 0.5 },
        '&.selected' => {
          color: -> { colors.focus }
        }

  component :span, :span
  component :small, :small do
    component :span, :span, text: 'Created '
    component :time, UI::Time, from_now: true
  end

  def render
    @span.text = @data[:title]
  end
end

class List < UI::List
  include UI::Behaviors::SelectableChildren
  include UI::Behaviors::Rest

  rest url: 'http://localhost:3000/posts'

  def refresh
    request :get, '' do |items|
      self.items = items
      yield
    end
  end
end

class Header < UI::Container
  tag 'ui-header[direction=row]'

  style height: -> { 3.em },
        lineHeight: -> { 3.em },
        background: -> { colors.primary },
        color: -> { readable_color(colors.primary) },
        '> *' => {
          padding: -> { "0 #{theme.spacing.em}" }
        }

  component :brand, 'ui-brand', text: 'Blog'
  component :posts, UI::Action, text: 'Content', action: :content
  component :posts, UI::Action, text: 'New Post', action: :create
end

class Posts < UI::Container
  extend Forwardable

  tag 'posts[direction=row]'

  style padding: -> { (theme.spacing * 2).em },
        'ui-container:last-of-type ui-icon' => { marginRight: -> { theme.spacing.em } },
        'ui-container:last-of-type' => {
          marginLeft: -> { (theme.spacing * 2).em }
        },
        'ui-title' => {
          flex: '0 0 2em',
          '> span' => {
            overflow: :hidden,
            textOverflow: :ellipsis,
            whiteSpace: :nowrap
          }
        }

  component :box, UI::Container, flex: '0 0 15em' do
    component :title, UI::Title, text: 'Posts', direction: :row do
      component :button, UI::Button, type: :success, shape: :square do
        component :icon, UI::Icon, glyph: :plus
      end
    end
    component :list, List, base: Item, flex: 1
  end

  component :preview, UI::Container, flex: 1 do
    component :title, UI::Title, direction: :row  do
      component :button, UI::Button, action: :edit do
        component :icon, UI::Icon, glyph: :edit
        component :span, :span, text: 'Edit'
      end
    end
    component :body, 'ui-body'
  end

  on :selected_change, :select

  def_delegators :box, :list
  def_delegators :list, :selected, :select_first

  def refresh
    list.refresh do
      break if selected
      select_first
    end
  end

  def select
    self.selected = selected.data
  end

  def selected=(data)
    @preview.title.text = data[:title]
    @preview.body.html = `marked(#{data[:body]})`
  end
end

class Form < UI::Container
  include UI::Behaviors::Serialize
  include UI::Behaviors::Rest

  extend Forwardable

  rest url: 'http://localhost:3000/posts'

  component :title, UI::Input, name: :title
  component :container, UI::Container, flex: 1, direction: :row, compact: true do
    component :textarea, UI::Textarea, name: :body
    component :preview, UI::Base, flex: 1 do
      component :div, :div
    end
  end

  style 'input' => { fontSize: 2.em,
                     flex: '0 0 auto',
                     borderBottom: -> { "#{theme.border_size.em} solid #{dampen colors.background, 0.05}" } },
        'ui-container' => {
          position: :relative,
          paddingLeft: '50%'
        },
        'base, textarea' => {
          boxSizing: 'border-box',
          fontSize: 16.px,
          padding: 20.px
        },
        'base' => {
          borderLeft: -> { "#{theme.border_size.em} solid #{dampen colors.background, 0.05}" },
          overflow: :auto,
          div: {
            maxWidth: 800.px,
            margin: '0 auto',
            '> *' => {
              margin: 0,
              marginBottom: 0.6.em
            }
          }
        },
        'input, textarea' => {
          '&:focus' => {
            boxShadow: :none
          }
        },
        textarea: {
          position: :absolute,
          resize: :none,
          top: 0,
          left: 0,
          width: '50%',
          height: '100%'
        }

  def_delegators :container, :preview, :textarea

  on :change, :save
  on :keyup, :render

  def initialize
    super
    textarea.on :scroll do
      sync
    end
  end

  def sync
    preview.scroll_top = preview.scroll_height * (textarea.scroll_top / textarea.scroll_height)
  end

  def load(id)
    request :get, id do |data|
      super data
      render
    end
  end

  def save
    update data do
      trigger :refresh
    end
  end

  def render
    preview.div.html = `marked(#{data[:body].to_s})`
  end
end

class Main < UI::Container
  extend Forwardable
  include UI::Behaviors::Actions
  include UI::Behaviors::Rest

  rest url: 'http://localhost:3000/posts'

  tag 'main[compact=true]'

  style height: '100vh',
        boxSizing: 'border-box',
        fontSize: 14.px

  component :header, Header
  component :content, UI::Container, direction: :row, flex: 1, compact: true do
    component :posts, Posts, flex: 1
    component :form, Form, flex: 1, compact: true
  end

  def initialize
    super
    @content.children.each(&:hide)
    content
  end

  def content
    @content.posts.refresh
    @content.posts.show
    @content.form.hide
  end

  def edit
    load @content.posts.selected.data[:id]
  end

  def load(id)
    @content.form.load id
    @content.posts.hide
    @content.form.show
  end

  def create
    data = { title: '', body: '' }
    request :post, '', data do |item|
      load item[:id]
    end
  end
end

DOM::Document.body << Main.new
