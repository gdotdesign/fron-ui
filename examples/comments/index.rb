require 'fron_ui'

require 'components/header'
require 'components/footer'
require 'components/comment'
require 'components/list'
require 'components/feed'
require 'components/main'

DOM::Document.body << Main.new
