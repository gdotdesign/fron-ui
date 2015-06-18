require 'fron_ui'
require_tree 'components'
contacts = Examples::Contacts.new
contacts >> DOM::Document.body
contacts.refresh
