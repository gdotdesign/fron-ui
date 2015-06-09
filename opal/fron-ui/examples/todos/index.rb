require 'fron_ui'
require 'fron-ui/utils/theme_roller'
require_relative 'components/main'

DOM::Document.body << Main.new
DOM::Document.body << ThemeRoller.new
