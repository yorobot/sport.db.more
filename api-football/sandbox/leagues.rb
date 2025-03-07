
require_relative 'helper'


def debug_years( seasons )
    years =  seasons.map do |season|
                             ## check for start and end
                             ##   if year different use season

                             ## note - season_year might be ahead one year!!
                             ##                    or one year behind!!
                             ## e.g.
                             ## Cup, Argentina (AR) |  Trofeo de Campeones de la Superliga  - 6 season(s):
                             ##     {"year"=>2024,
                             ##  "start"=>"2023-12-23",
                             ##  "end"=>"2023-12-23",
                             ##
                             ## always use start and end for now
                             ##
                                  #  note - relegation playoffs
                                  #    have   year with  start+1 AND end+1 e.g.
                                  # {"year"=>2022,
                                  # "start"=>"2023-05-11",
                                  # "end"=>"2023-05-18",
 
                             season_year  =  season['year']
                             season_start = Date.strptime(season['start'], '%Y-%m-%d') 
                             season_end   = Date.strptime(season['end'],   '%Y-%m-%d')
                    
                             if season_start.year == season_end.year
                                  # calendar year season
                                  if season_year != season_start.year
                                    puts "!! (calendar year) season_year != season_start.year:"
                                    pp season
                                  end
                                  season_start.year.to_s 
                             elsif season_start.year+1 == season_end.year
                                 # academic year season
                                 if season_year != season_start.year
                                  puts "!! (acaedmic year) season_year != season_start.year:"
                                  pp season
                                 end
                                 "#{season_start.year}/#{season_end.year % 100}" 
                             else
                                ## multi-year - during corona?
                               ##  Argentina (AR) |  Primera C  -{"year"=>2019,
                               ##  "start"=>"2019-07-27",
                               ##  "end"=>"2021-01-16",
                                  puts "!! multi-year??"
                                  pp season
                                  "!#{season_start.year}--#{season_end.year % 100}" 
                                  ## raise ArgumentError, "invalid season for #{league_name}"
                             end
                          end
 
    puts years.join( ' ' )
end


def pp_leagues( data )
  res = data['response']
  puts "  #{res.size} record(s)"

  ## sort by country
  res = res.sort do |l,r|
                      cmp = l['country']['name'] <=> r['country']['name']  
                      cmp = l['league']['id'] <=> r['league']['id']  if cmp == 0 
                      cmp
                  end

  res.each do |rec|
      league_id   = rec['league']['id']
      league_name = rec['league']['name']
      league_type = rec['league']['type']
      country_name =  rec['country']['name']
      country_code =  rec['country']['code']
      seasons      =  rec['seasons'] 

      print " (#{league_id}) #{league_type},"
      print " #{country_name}"
      print " (#{country_code})"   if country_code
      print " | #{league_name}"
      print "  -- (#{seasons.size}): "
      years = seasons.map { |season| season['year'].to_s }
      print years.join( ' ' )
      print "\n"

      ## note - uncomment to see how  year differes in super cups and such
      ##              from season_start and season_end year!!!
      ## debug_years( seasons )
  end
end



leagues = ApiFootball.leagues
## pp leagues

pp_leagues( leagues )


puts "bye"