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

class Header < UI::Box
  tag 'ui-header[direction=row]'

  style '> *' => { padding: -> { "0 #{theme.spacing.em}" } }

  component :brand, 'ui-brand', text: 'Blog'
  component :posts, UI::Action, text: 'Content', action: :content
  component :posts, UI::Action, text: 'New Post', action: :create
end

class Posts < UI::Container
  extend Forwardable

  tag 'ui-posts'

  style 'ui-box:last-of-type ui-icon' => { marginRight: -> { theme.spacing.em } },
        'ui-body' => { overflow: :auto },
        'ui-title' => {
          flex: '0 0 2em',
          '> span' => {
            overflow: :hidden,
            textOverflow: :ellipsis,
            whiteSpace: :nowrap
          }
        }

  component :box, UI::Box, flex: '0 0 15em' do
    component :title, UI::Title, text: 'Posts', direction: :row do
      component :button, UI::Button, type: :success, shape: :square, action: :create do
        component :icon, UI::Icon, glyph: :plus
      end
    end
    component :list, List, base: Item, flex: 1
  end

  component :preview, UI::Box, flex: 1 do
    component :title, UI::Title, direction: :row do
      component :button, UI::Button, action: :edit do
        component :icon, UI::Icon, glyph: :edit
        component :span, :span, text: 'Edit'
      end
      component :button, UI::Button, action: :confirm_destroy!, type: :danger do
        component :icon, UI::Icon, glyph: 'trash-b'
        component :span, :span, text: 'Delete'
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
    @preview.body.html = `marked(#{data[:body].to_s}, { gfm: true, breaks: true })`
  end
end

class Form < UI::Container
  include UI::Behaviors::Serialize
  include UI::Behaviors::Actions
  include UI::Behaviors::Rest

  extend Forwardable

  tag 'ui-form'

  rest url: 'http://localhost:3000/posts'

  style 'input[type=text]' => { fontSize: 2.em,
                                flex: '0 0 auto',
                                borderRadius: 0,
                                borderBottom: -> { "#{theme.border_size.em} solid #{dampen colors.background, 0.05}" } },
        'ui-container:first-of-type' => {
          position: :relative,
          paddingLeft: '50%',
          marginTop: '0 !important'
        },
        'ui-base, textarea' => {
          boxSizing: 'border-box',
          fontSize: 16.px,
          padding: 20.px
        },
        'ui-base' => {
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

  component :title, UI::Input, name: :title, placeholder: 'Post title...'
  component :container, UI::Container, flex: 1, direction: :row, compact: true do
    component :textarea, UI::Textarea, name: :body, placeholder: 'Post body...', spellcheck: false
    component :preview, UI::Base, flex: 1 do
      component :div, :div
    end
  end
  component :statusbar, UI::Container, direction: :row, align: :end, flex: '0 0 auto' do
    component :button, UI::Button, text: 'Save', action: :save
  end

  def_delegators :container, :preview, :textarea

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

  def load(id, defaults = { title: '', body: '' })
    if id
      request :get, id do |data|
        super data
        render
        yield if block_given?
      end
    else
      super defaults
      render
      yield if block_given?
    end
  end

  def save
    if data[:id]
      update data
    else
      create data do |item|
        trigger :created, id: item[:id]
      end
    end
  end

  def render
    preview.div.html = `marked(#{data[:body].to_s}, { gfm: true, breaks: true })`
  end
end

class Main < UI::Container
  extend Forwardable
  include UI::Behaviors::Actions
  include UI::Behaviors::Rest
  include UI::Behaviors::State
  include UI::Behaviors::Confirmation

  rest url: 'http://localhost:3000/posts'

  tag 'main'

  style height: '100vh',
        boxSizing: 'border-box',
        fontSize: 14.px,
        padding: -> { theme.spacing.em }

  component :header, Header
  component :content, UI::Container, direction: :row, flex: 1, compact: true do
    component :posts, Posts, flex: 1, direction: :row
    component :form, Form, flex: 1
  end

  state_changed :state_changed

  confirmation :destroy!, 'Are you sure you want to remove this post?'

  on :created, :created

  def state_changed
    if state.key?(:id)
      load(state[:id])
    else
      @content.posts.refresh
      @content.posts.show
      @content.form.hide
    end
  end

  def state
    super.to_h
  end

  def content
    self.state = {}
  end

  def destroy!
    request :delete, @content.posts.selected.data[:id] do
      @content.posts.refresh
    end
  end

  def edit
    self.state = state.merge!(id: @content.posts.selected.data[:id])
  end

  def load(id)
    @content.form.load id do
      @content.posts.hide
      @content.form.show
    end
  end

  def create
    self.state = { id: nil }
  end

  def created(event)
    self.state = { id: event.id }
  end
end

Fron::Sheet.render_style_tag
DOM::Document.body << Main.new
