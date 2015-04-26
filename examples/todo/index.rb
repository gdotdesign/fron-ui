require 'fron_ui'

require 'components/item'
require 'components/todos'
require 'components/main'
require 'components/options'

Fron::Sheet.helper.theme.font_family = 'Open Sans'

DOM::Document.body << Main.new

