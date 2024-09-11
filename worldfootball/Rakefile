require 'hoe'
require './lib/worldfootball/version.rb'

Hoe.spec 'worldfootball' do

  self.version = Worldfootball::VERSION

  self.summary = "worldfootball - get world football (leagues, cups & more) match data via the worldfootball.net/weltfussball.de pages"
  self.description = summary

  self.urls = { home: 'https://github.com/sportdb/sport.db' }

  self.author = 'Gerald Bauer'
  self.email  = 'gerald.bauer@gmail.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'CHANGELOG.md'

  self.extra_deps = [
    ['football-timezones'],
    ['webget'],
    ['nokogiri'],
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   required_ruby_version: '>= 3.1.0'
  }

end
