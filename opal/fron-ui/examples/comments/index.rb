require 'fron_ui'

require_relative 'components/header'
require_relative 'components/footer'
require_relative 'components/comment'
require_relative 'components/list'
require_relative 'components/feed'
require_relative 'components/main'

DOM::Document.body << Main.new
