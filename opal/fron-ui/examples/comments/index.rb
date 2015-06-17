require 'fron_ui'
require_tree 'components'
comments = Examples::Comments.new
comments >> DOM::Document.body
comments.load
