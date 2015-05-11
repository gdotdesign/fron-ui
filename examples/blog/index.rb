require 'fron_ui'

class Item < UI::Container
  include ::Rest
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
  include ::Rest

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
  tag 'posts[direction=row]'

  style padding: -> { (theme.spacing * 2).em },
        paddingTop: -> { theme.spacing.em },
        'ui-container:last-of-type ui-icon' => { marginRight: -> { theme.spacing.em } },
        'ui-container:last-of-type' => {
          marginLeft: -> { (theme.spacing * 2).em }
        },
        'ui-title' => {
          display: :flex,
          '> span' => {
            overflow: :hidden,
            textOverflow: :ellipsis,
            whiteSpace: :nowrap,
            flex: 1
          }
        }

  component :box, UI::Container, flex: '0 0 15em' do
    component :title, UI::Title, text: 'Posts' do
      component :button, UI::Button, type: :success, shape: :square do
        component :icon, UI::Icon, glyph: :plus
      end
    end
    component :list, List, base: Item, flex: 1
  end

  component :preview, UI::Container, flex: 1 do
    component :title, UI::Title do
      component :button, UI::Button do
        component :icon, UI::Icon, glyph: :pencil
        component :span, :span, text: 'Edit'
      end
    end
    component :body, 'ui-body'
  end

  on :selected_change, :select

  def refresh
    @box.list.refresh do
      break if @box.list.selected
      @box.list.select_first
    end
  end

  def select
    self.selected = @box.list.selected.data
  end

  def selected=(data)
    @preview.title.text = data[:title]
    @preview.body.html = `marked(#{data[:body]})`
  end
end

class Form < UI::Container
  include UI::Behaviors::Serialize
  include ::Rest

  rest url: 'http://localhost:3000/posts'

  component :title, UI::Input, name: :title
  component :container, UI::Container, flex: 1, direction: :row do
    component :body, UI::Textarea, name: :body
    component :preview, UI::Base, flex: 1
  end

  style 'ui-container' => {
          position: :relative,
          paddingLeft: '50%',
        },
        'base' => {
          overflow: :auto,
          padding: 20.px,
          fontSize: 16.px,
          boxSizing: 'border-box',
          '> *' => {
            margin: 0,
            marginBottom: 0.6.em
          }
        },
        textarea: {
          position: :absolute,
          boxSizing: 'border-box',
          fontSize: 16.px,
          padding: 20.px,
          top: 0,
          left: 0,
          width: '50%',
          height: '100%',
          '&:focus' => {
            boxShadow: :none
          }
        }

  on :change, :save
  on :input, :render

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
    @container.preview.html = `marked(#{data[:body]})`
  end
end

class Main < UI::Container
  extend Forwardable
  include UI::Behaviors::Actions

  tag 'main'

  style height: '100vh',
        boxSizing: 'border-box',
        fontSize: 14.px

  component :header, Header
  component :content, UI::Container, direction: :row, flex: 1 do
    # component :posts, Posts, flex: 1
    component :form, Form, flex: 1
  end

  def initialize
    super
    # @content.posts.refresh
    @content.form.load 1
  end

  def create
    data = { title: '', body: '' }
    list.request :post, '', data do |item|
      @content.form.load item[:id]
      refresh
    end
  end
end

DOM::Document.body << Main.new
