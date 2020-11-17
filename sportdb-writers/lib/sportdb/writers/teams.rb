######
# teams/clubs normalize helper
#   todo/check/fix:  move upstream for (re)use  - why? why not?


module Writer

########
# helpers
#   normalize team names
#
#  todo/fix:  for reuse move to sportdb-catalogs
#                use normalize  - add to module/class ??
##
##  todo/fix: check league - if is national_team or clubs or intl etc.!!!!



def self.normalize( matches, league:, season: nil )
  league = SportDb::Import.catalog.leagues.find!( league )
  country = league.country

  ## todo/fix: cache name lookups - why? why not?
  matches.each do |match|
     team1 = SportDb::Import.catalog.clubs.find_by!( name: match.team1,
                                                     country: country )
     team2 = SportDb::Import.catalog.clubs.find_by!( name: match.team2,
                                                     country: country )

     if season
       team1_name = team1.name_by_season( season )
       team2_name = team2.name_by_season( season )
     else
       team1_name = team1.name
       team2_name = team2.name
     end

     puts "#{match.team1} => #{team1_name}"  if match.team1 != team1_name
     puts "#{match.team2} => #{team2_name}"  if match.team2 != team2_name

     match.update( team1: team1_name )
     match.update( team2: team2_name )
  end
  matches
end

end # module Writer