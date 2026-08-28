module Openliga


  def self.config_dir()  "#{File.dirname(File.dirname(__dir__))}/config";  end


  ## code, season,  league_name, league_season, league_shortcut
  ##
  ##  "leagueName": "Champions League 2026/2027",
  ##  "leagueShortcut": "ucl",
  ##  "leagueSeason": 2026,
  ##
  ## from https://api.openligadb.de
  ##   Name	Description
  ##  leagueShortcut  - string - der Shortcut der Liga, z.B. 'bl1' für die erste Bundesliga
  ##  leagueSeason  - integer($int32) - die Saison der Liga, z.B. 2019 für die Saison 2019/2020





  League = Struct.new( :name, :season, :shortcut)


  LEAGUES = begin
    leagues = {}
    ['leagues_de.csv',
     'leagues_more.csv'].each do |name|
       path = "#{config_dir}/#{name}"
       rows = read_csv( path )
       ## pp rows
       rows.each do |row|
          seasons = leagues[row['code']] ||= {}
          ## note - normalize season!!
          season = Season.parse( row['season'] )
          seasons[ season.to_key ] = League.new( name:     row['league_name'],
                                                 season:   row['league_season'].to_i(10),
                                                 shortcut: row['league_shortcut'] )
      end
    end
    leagues
end


end   #  module Openliga
