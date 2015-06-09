require 'fron_ui'

URL = 'http://localhost:3000/files'

class Item < UI::Container
  include UI::Behaviors::Rest
  include UI::Behaviors::Action
  include ::Record

  style padding: -> { theme.spacing.em },
        '> span' => { fontWeight: 600 }

  component :span, :span

  def render
    @span.text = @data[:filename]
  end

  def action
    trigger :dblclick
  end
end

class List < UI::List
  include UI::Behaviors::Rest

  rest url: URL

  def refresh
    request :get, '' do |items|
      self.items = items
    end
  end
end

class FileTab < UI::Container
  include UI::Behaviors::Rest
  include ::Record

  tag 'ui-file'

  rest url: URL

  component :textarea, UI::Textarea, spellcheck: false

  style position: :relative,
        textarea: { position: :absolute,
                    padding: -> { theme.spacing.em },
                    width: '100%',
                    height: '100%',
                    resize: :none }

  on :change, :save

  def render
    self[:tab] = @data[:filename]
    @textarea.value = @data[:content].to_s
  end

  def save
    update content: @textarea.value
  end
end

class Main < UI::Container
  style padding: -> { theme.spacing.em },
        boxSizing: 'border-box',
        height: '100vh',
        'ui-box:first-child' => {
          flex: '0 0 10em'
        }

  component :container, UI::Container, direction: :row, flex: 1 do
    component :sidebar, UI::Box do
      component :title, UI::Title, text: 'Files', direction: :row do
        component :button, UI::Button, type: :success, shape: :square do
          component :icon, UI::Icon, glyph: :plus
        end
      end
      component :list, List, base: Item
    end
    component :content, UI::Box, flex: 1 do
      component :tabs, UI::Tabs, flex: 1, compact: true
    end
  end

  include UI::Behaviors::Rest

  rest url: URL

  on :dblclick, 'item', :open

  def initialize
    super
    @container.sidebar.list.refresh
  end

  def open(event)
    request :get, event.target.data[:id] do |data|
      current = @container.content.tabs.find_by_id(data[:filename])
      break @container.content.tabs.select current if current
      tab = FileTab.new
      tab.data = data
      @container.content.tabs << tab
      @container.content.tabs.select tab
    end
  end
end

main = Main.new

DOM::Document.body << main
