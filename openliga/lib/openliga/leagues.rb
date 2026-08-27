module Openliga


  def self.config_dir()  "#{File.dirname(File.dirname(__dir__))}/config";  end


  ## code, season,  league_name, league_season, league_shortcut
  ##
  ##  "leagueName": "Champions League 2026/2027",
  ##  "leagueShortcut": "ucl",
  ##  "leagueSeason": "2026",
  ###
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
                                                 season:   row['league_season'],
                                                 shortcut: row['league_shortcut'] )
      end
    end
    leagues
end


end   #  module Openliga
