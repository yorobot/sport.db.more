# encoding: utf-8


class LevelPart    ## find a more specific / clear / longer name - why? why not?

def initialize( level )
  @level = level    ## holds level_line hash with season and team stats
end


def build
  season_keys = @level.seasons.keys
  team_keys   = @level.teams.keys

  buf = String.new('')
  buf << "## Level #{@level.name}\n\n"

  buf << "- #{season_keys.size} seasons: "
  ## sort season_keys - why? why not?
  season_keys.sort.reverse.each do |season_key|
    datafiles = @level.seasons[season_key]
    buf << "#{season_key} "
    buf << " (#{datafiles.size}) "    if datafiles.size > 1
  end
  buf << "\n"

  buf << "- #{team_keys.size} teams: "
  team_keys.sort.each do |team_key|
    seasons = @level.teams[team_key]
    buf << "#{team_key} (#{seasons.size}) "
  end
  buf << "\n"


  ## add teams grouped by seasons count e.g.:
  ##  22 seasons:  Madrid, Barcelona
  ##   3 seasons:   Eibar, ...
  teams_by_seasons = {}
  @level.teams.each do |team_key, team_seasons|
    seasons_count = team_seasons.size
    teams_by_seasons[seasons_count] ||= []
    teams_by_seasons[seasons_count] << team_key
  end


  ## sort by key (e.g. seasons_count : integer)
  teams_by_seasons.keys.sort.reverse.each do |seasons_count|
    team_names = teams_by_seasons[seasons_count]
    buf << "  - #{seasons_count} seasons: "
    buf << team_names.sort.join( ', ' )
    buf << "\n"
  end

  buf << "\n\n"
  buf
end # method build

alias_method :render, :build


end # class LevelPart
