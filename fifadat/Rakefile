require 'hoe'
## require './lib/fifadat/version.rb'

Hoe.spec 'fifadat' do

  self.version = '0.0.1'

  self.summary = "fifadat - get football data via the (unofficial) fifa api"
  self.description = summary

  self.urls = { home: 'https://github.com/sportdb/sport.db' }

  self.author = 'Gerald Bauer'
  self.email  = 'gerald.bauer@gmail.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'CHANGELOG.md'

  self.extra_deps = [
    ['cocos'],
    ['webget'],
    ['season-formats'],
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   required_ruby_version: '>= 3.1.0'
  }

end
