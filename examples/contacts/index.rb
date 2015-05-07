require 'fron_ui'

# List
class List < UI::List
  include UI::Behaviors::SelectableChildren

  tag 'ui-list'
end

# Image
# TODO: move to components
class Image < Fron::Component
  tag 'ui-image'

  component :img, :img

  style display: 'inline-block',
        background: -> { colors.background_lighter },
        img: {
          borderRadius: :inherit,
          width: :inherit,
          height: :inherit,
          transition: '320ms',
          opacity: 0,
          '&.loaded' => {
            opacity: 1
          }
        }

  def initialize
    super
    @img.on(:load) { loaded }
  end

  def loaded
    @img.add_class :loaded
  end

  def src=(value)
    return if !value || @img[:src] == value
    @img.remove_class :loaded
    timeout 320 do
      @img[:src] = value
    end
  end
end

# Item
class Item < UI::Container
  include ::Record

  tag 'ui-item'

  component :image, :img
  component :name, UI::Label

  style padding: -> { theme.spacing.em },
        lineHeight: 2.em,
        transition: 'border 200ms',
        borderLeft: '0em solid transparent',
        img: {
          borderRadius: -> { theme.border_radius.em },
          width: 2.em,
          height: 2.em
        },
        '&.selected' => {
          borderLeft: -> { "0.4em solid #{colors.primary}" }
        }

  def render
    @image.src = 'http://www.gravatar.com/avatar/' + `md5(#{data[:email] || ''})` + '?s=100&d=identicon'
    @name.text = data[:name] || ' '
  end
end

# Sidebar
class Sidebar < UI::Box
  extend Forwardable

  tag 'ui-sidebar'

  component :title, UI::Title, text: 'Contacts'
  component :input, UI::Input, placeholder: 'Search...'
  component :list, List, empty_message: 'No contacts to display!', flex: 1, base: Item
  component :button, UI::Button, text: 'Add new contact!', action: :add

  def_delegators :list, :items, :items=, :selected

  def select(id)
    @list.select @list.children.find { |item| item.data[:id] == id }
  end
end

# Details
class Details < UI::Box
  include UI::Behaviors::Confirmation
  include UI::Behaviors::Serialize
  include UI::Behaviors::Actions

  tag 'ui-details'

  style 'ui-image' => { margin: -> { theme.spacing.em },
                        borderRadius: 0.5.em,
                        height: 15.em,
                        width: 15.em },
        'ui-container' => { padding: -> { theme.spacing.em } },
        'ui-container ui-container' => { maxWidth: 30.em },
        'ui-label' => { fontWeight: 600 },
        'input' => { fontSize: 1.2.em },
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

  component :box, UI::Container, flex: 1 do
    component :image, Image
    component :form, UI::Container, direction: :column, flex: 1 do
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

  on :change, :update

  def destroy!
    Main.storage.remove data[:id]
    trigger :refresh
    load({})
    render
  end

  def update
    Main.storage.set data[:id], data
    render
    trigger :refresh
  end

  def render
    toggle_class :empty, data[:id].nil?
    @box.image.src = 'http://www.gravatar.com/avatar/' + `md5(#{data[:email] || ''})` + '?s=200&d=identicon'
  end
end

# Main
class Main < UI::Container
  include UI::Behaviors::Actions
  include UI::Behaviors::Render

  extend Forwardable

  component :sidebar, Sidebar, flex: '0 0 20em', direction: :column
  component :details, Details, flex: 1, direction: :column

  style fontSize: 14.px,
        width: 67.5.em,
        margin: '0 auto',
        height: 57.5.em,
        padding: -> { theme.spacing.em },
        boxSizing: 'border-box'

  render :render!

  def_delegators :class, :storage

  on :selected_change, :select
  on :input, 'ui-sidebar input', :render
  on :refresh, :render

  def initialize
    super
    render
  end

  def add
    id = SecureRandom.uuid
    storage.set id, id: id
    render!
    @sidebar.select id
  end

  def select
    @selected = @sidebar.selected.data[:id]
    @details.load storage.get(@selected)
    @details.render
  end

  def render!
    @sidebar.items = storage.all.select { |item| item[:name].to_s.match Regexp.new(@sidebar.input.value || '.*', 'i') }
    @sidebar.select @selected
    @details.render
  end

  def self.storage
    @storage ||= Storage.new 'contacts'
  end
end

Fron::Sheet.helper.theme.font_family = 'Open Sans'
Fron::Sheet.stylesheet '//fonts.googleapis.com/css?family=Open+Sans:400,600,700'
Fron::Sheet.add_rule 'body', { margin: 0 }, '0'

DOM::Document.body << Main.new
