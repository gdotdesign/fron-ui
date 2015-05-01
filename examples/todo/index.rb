require 'fron_ui'

require 'components/item'
require 'components/todos'
require 'components/main'
require 'components/options'

Fron::Sheet.helper.theme.font_family = 'Open Sans'
Fron::Sheet.stylesheet '//fonts.googleapis.com/css?family=Open+Sans:400,600,700'

DOM::Document.body << Main.new
