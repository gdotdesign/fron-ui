require 'fron_ui'

class List < UI::List
  include UI::Behaviors::SelectableChildren

  tag 'ui-list'

  style '.selected' => {
          color: :red
        }
end

class Item < UI::Container
  tag 'ui-item'

  component :image, :img
  component :name, UI::Label

  style padding: -> { theme.spacing.em },
        lineHeight: 2.em,
        img: {
          borderRadius: -> { theme.border_radius.em },
          width: 2.em,
          height: 2.em
        }

  def render(data = {})
    @image[:src] = 'http://www.gravatar.com/avatar/' + `md5(#{data[:email] || ''})` + '?s=100'
    @name.text = data[:name] || ' '
  end
end

class Sidebar < UI::Box
  include UI::Behaviors::Actions
  include UI::Behaviors::Render

  tag 'ui-sidebar'

  component :title, UI::Title, text: 'Contacts'
  component :list, List, empty_message: 'No contacts to display!', flex: 1
  component :button, UI::Button, text: 'Add new contact!', action: :add

  render :render!

  on :selected_change, :select

  def initialize
    super
    render
  end

  def add
    id = SecureRandom.uuid
    key = "contacts:#{id}"
    storage.set key, {}
    render!
    @list.find("[key='#{key}']").trigger :click
  end

  def load
    @list.empty
    keys = storage.keys.select { |key| key.start_with?(:contacts) }
    keys.each do |key|
      item = Item.new
      item.render storage.get(key).to_h
      item[:key] = key
      item >> @list
    end
  end

  def select
    trigger :select, contact_key: @list.selected[:key]
  end

  def render!
    load
    @list.render
  end

  def storage
    Fron::Storage::LocalStorage
  end
end

class Details < UI::Box
  include UI::Behaviors::Serialize
  tag 'ui-details'

  style img: { borderRadius: 0.5.em,
               height: 200.px,
               width: 200.px },
        'ui-container ui-container' => { maxWidth: 30.em }

  component :title, UI::Title, text: 'Contact Details'

  component :box, UI::Container do
    component :image, :img
    component :form, UI::Container, direction: :column, flex: 1 do
      component :input, UI::Input, placeholder: 'Name...', name: :name
      component :input, UI::Input, placeholder: 'Email...', name: :email
    end
  end

  on :change, :save

  def save
    storage.set @key, data
    render
  end

  def set(key)
    load defaults.merge!(storage.get(key))
    @key = key
    render
  end

  def render
    @box.image[:src] = 'http://www.gravatar.com/avatar/' + `md5(#{data[:email] || ''})` + '?s=200'
  end

  def defaults
    {
      name: nil,
      email: nil
    }
  end

  def storage
    Fron::Storage::LocalStorage
  end
end

class Main < UI::Container
  component :sidebar, Sidebar, flex: '0 0 20em', direction: :column
  component :details, Details, flex: 1, direction: :column

  style fontSize: 14.px,
        width: 960.px,
        margin: '0 auto',
        height: 800.px,
        padding: -> { theme.spacing.em },
        boxSizing: 'border-box'

  on :select, :select
  on :change, :render

  def render
    @sidebar.render
  end

  def select(event)
    @details.set event.contact_key
  end
end

Fron::Sheet.helper.theme.font_family = 'Open Sans'
Fron::Sheet.stylesheet '//fonts.googleapis.com/css?family=Open+Sans:400,600,700'
Fron::Sheet.add_rule 'body', { margin: 0 }, '0'

DOM::Document.body << Main.new
