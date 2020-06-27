# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_txt_writer.rb


require 'helper'


class TestTxtWriter < MiniTest::Test

  TxtMatchWriter = SportDb::TxtMatchWriter


  def test_eng
     matches = SportDb::CsvMatchParser.read( '../../stage/one/2019-20/eng.1.csv' )

     puts
     pp matches[0]
     puts "#{matches.size} matches"


     league_name  = 'English Premier League'
     season_key   = '2019/20'

     matches = normalize( matches, league: league_name )

     path = './tmp/pl.txt'
     TxtMatchWriter.write( path, matches,
                             title: "#{league_name} #{season_key}",
                             round: 'Matchday',
                             lang:  'en')

  end

  def test_es
    matches = SportDb::CsvMatchParser.read( '../../stage/one/2019-20/es.1.csv' )

    puts
    pp matches[0]
    puts "#{matches.size} matches"


    league_name  = 'Primera División de España'
    season_key   = '2019/20'

    matches = normalize( matches, league: league_name )

    path = './tmp/liga.txt'
    TxtMatchWriter.write( path, matches,
                            title: "#{league_name} #{season_key}",
                            round: 'Jornada',
                            lang:  'es')

 end

 def test_it
  matches = SportDb::CsvMatchParser.read( '../../stage/one/2019-20/it.1.csv' )

  puts
  pp matches[0]
  puts "#{matches.size} matches"


  league_name  = 'Italian Serie A'
  season_key   = '2019/20'

  matches = normalize( matches, league: league_name )

  path = './tmp/seriea.txt'
  TxtMatchWriter.write( path, matches,
                          title: "#{league_name} #{season_key}",
                          round: ->(round) { "%s^ Giornata" % round },
                          lang:  'it')
 end

  #####
  #  note: fix sort order e.g. cover
  #
  # 17^ Giornata
  # [Mer. 18.12.]
  #  UC Sampdoria             1-2  Juventus
  #
  # 7^ Giornata
  # [Mer. 18.12.]
  #  Brescia                  0-2  US Sassuolo Calcio
  #
  # 17^ Giornata
  # [Ven. 20.12.]
  #  ACF Fiorentina           1-4  AS Roma


  ########
  # helper
  #   normalize team names
  def normalize( matches, league: )
    matches = matches.sort do |l,r|
      ## first by date (older first)
      ## next by matchday (lowwer first)
      res =   l.date <=> r.date
      res =   l.round <=> r.round   if res == 0
      res
    end


    league = SportDb::Import.catalog.leagues.find!( league )
    country = league.country

    ## todo/fix: cache name lookups - why? why not?
    matches.each do |match|
       team1 = SportDb::Import.catalog.clubs.find_by!( name: match.team1,
                                                       country: country )
       team2 = SportDb::Import.catalog.clubs.find_by!( name: match.team2,
                                                       country: country )

       puts "#{match.team1} => #{team1.name}"  if match.team1 != team1.name
       puts "#{match.team2} => #{team2.name}"  if match.team2 != team2.name

       match.update( team1: team1.name )
       match.update( team2: team2.name )
    end
    matches
  end

end # class TestTxtWriter
