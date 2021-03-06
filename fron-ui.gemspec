# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fron_ui/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'fron-ui'
  s.version      = Fron::UI::VERSION
  s.author       = 'Gusztav Szikszai'
  s.email        = 'gusztav.szikszai@digitalnatives.hu'
  s.homepage     = 'https://github.com/gdotdesign/fron-ui'
  s.summary      = 'UI Library using Fron'
  s.description  = 'UI Library using Fron'

  s.files          = `git ls-files`.split("\n")
  s.executables    = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_runtime_dependency 'fron', '1.0.0rc2'
  s.add_runtime_dependency 'color', '1.8'
  s.add_development_dependency 'opal-rspec', '~> 0.5.0'
end
