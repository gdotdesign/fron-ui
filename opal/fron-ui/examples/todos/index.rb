require 'fron_ui'
require_tree 'components'
todos = Examples::Todos.new
todos >> DOM::Document.body
todos.refresh
