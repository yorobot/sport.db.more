

module Uefa

# europa/champs note - note starting 2007/08 => 2008 (end year) !!
##              2006 => 2006/07
#               1971 => 1971/72
#  note - no year 2007!!!
def self.teams_champ_url( season: )
    season = Season( season )
    year  = season >= Season('2007/08') ? season.end_year : season.start_year

    raise ArgumentError, "champ season starting at 1956/57"  if season < Season( '1956/57')
    raise ArgumentError, "academic (not calendar) season expected"  if season.calendar?

    tmpl = 'https://www.uefa.com/uefachampionsleague/history/seasons/{year}/clubs/'
    tmpl = tmpl.sub( '{year}', year.to_s )
    tmpl
end

def self.teams_europa_url( season: )
  season = Season( season )
  year  = season >= Season('2007/08') ? season.end_year : season.start_year

  raise ArgumentError, "europa season starting at 1971/22"  if season < Season( '1971/72')
  raise ArgumentError, "academic (not calendar) season expected"  if season.calendar?

  tmpl = 'https://www.uefa.com/uefaeuropaleague/history/seasons/{year}/clubs/'
  tmpl = tmpl.sub( '{year}', year.to_s )
  tmpl
end

def self.teams_conf_url( season: )
  season = Season( season )
  year  = season.end_year

  raise ArgumentError, "conf season starting at 2021/22"  if season < Season( '2021/22')
  raise ArgumentError, "academic (not calendar) season expected"  if season.calendar?

  tmpl = 'https://www.uefa.com/uefaconferenceleague/history/seasons/{year}/clubs/'
  tmpl = tmpl.sub( '{year}', year.to_s )
  tmpl
end

end # module Uefa