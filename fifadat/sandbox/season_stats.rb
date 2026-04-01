require_relative '../helper'



##
## read comps meta
rows = [] 
rows += read_csv( './competitions_m_club.csv')
rows += read_csv( './competitions_m_nati.csv')

COMPETITIONS = rows.reduce( {} ) do |h,row|
                                       h[row['IdCompetition']] = row
                                       h
                                    end

## pp COMPETITIONS                                   


TEAM_TYPE = { 0 => 'CLUB', 1 => 'NATI' }

def collect_seasons( matches, 
                   stats:   ) 

   matches.each do |m|

   if m['Home']
     gender = m['Home']['Gender']   # 1-m/2-f
     ageType = m['Home']['AgeType']   # use 7 and 0 only for now
     teamType = m['Home']['TeamType']
     footballType = m['Home']['FootballType']
    else
       next   ## skip for now if no home match defined - sorry
    end

       next if !(gender == 1 && 
                 [0,7].include?(ageType) &&
                 footballType == 0  ## skip futsal & beach soccer etc.
                )


       idCompetition = m['IdCompetition']
  
       ## note - skip "weirdo" / invalid idCompetitions
       ##       used FCWC_MCQ in ???
       next if ['FCWC_MCQ',
                'b537iyp3c44psskitxwjxpng8',  ## Tournoi Maurice Revello (mixed AgeType teams)
                '7k4t5z7iiueq1l5pu1bymud71',  ## TAH Ligue 1   (weirdo teams with nulls)
                ].include?( idCompetition )

  
       comp_meta  = COMPETITIONS[idCompetition]

       if comp_meta.nil?
         puts "no comp_meta found for >#{idCompetition}<:"
         pp m
        exit 1
       end

  
       comp = stats[idCompetition] ||= { count: 0,
                                              names: [],
                                              teamType: TEAM_TYPE[teamType],
                                              confed: comp_meta['IdConfederation'],
                                              assoc:  comp_meta['IdMemberAssociation'],
                                              seasons: {},
                                               }
       comp[:count] += 1   ## (total) match count (all seasons)
       name = desc( m['CompetitionName'] )
       comp[:names] << name    if !comp[:names].include?(name)
    
       ######
       ## add IdSeason
       season = comp[:seasons][m['IdSeason']] ||= { count: 0,
                                                    names: [],
                                                    stages: Hash.new(0) }
       season[:count] += 1                                                
       seasonName = desc( m['SeasonName'] )
       season[:names] << seasonName    if !season[:names].include?(seasonName)
       stageName = desc( m['StageName'] )
       season[:stages][ stageName ] +=1    
   end

   stats
end



start_date = Date.new( 2022, 1, 1 )
date = start_date

total_stats = {}

loop do

  from = "#{date.strftime('%Y-%m-%d')}T00:00:00Z"
  to   = "#{date.strftime('%Y-%m-%d')}T23:59:59Z"

  print "==> %03d" % date.yday 
  print "  #{from} - #{to} "
  
  outpath = "./matchday/#{date.year}/#{'%03d' % date.yday}_#{date.strftime('%Y-%m-%d')}.json"
  data = read_json( outpath )
  data = data['Results']
  print " -- #{data.size} match(es)\n"
  
   collect_seasons( data, stats: total_stats )

   date += 1

   break      if date >= Date.new( 2026, 3, 30 )
end


puts
puts "total:"
pp total_stats

write_json_v2( "./seasons.json", total_stats )


puts "bye"

