###
#
#  [002]    2024-05-03 | 03:00 | Club Necaxa            | Gallos Blancos         | 3-2 (0-0, 1-1) i.E.
# !! ERROR - unsupported score format >3-2 (0-0, 1-1) i.E.< - sorry; maybe add a score error fix/patch
#    - allow penality score WITHOUT extra time  (used in mexico etc.)


require_relative 'helper'


def build_basename( slug, code:, pre:, path: )
    ### derive datafile name from slug    
##
#  maybe split slug  int parts e.g. - why? why not?
#    1) code  mex|aut
#    2) league
#    3) season
#    4) stage
#    5) modifier (_2)

        ## parse slug
           name = slug
           name = name.sub( /^#{code}-/, '' )
           ## cutoff trailing _2  if present
           ## e.g. clausura-playoffs_2 => clausura-playoffs 
           name = name.sub( /_2$/, '' )  
    
           ## get season 
           if m = name.match( /-(?<season>
                                   [0-9]{4}
                                   (-[0-9]{4})?
                                 )
                                  (-|$)
                               /x )
              season_str = m[:season]    
              season = Season.parse( season_str )          
              m0 = m[0]
              puts " found #{m0} - >#{season}<"
              ## note - add @ if season follow by stage
              name = if name.end_with?( m0 )
                       name.sub( m0, '' )
                     else
                       name.sub( m0, '@' )
                     end
              puts "   #{slug}"
              outpath = "#{path}/#{season.to_path}/#{pre}_#{name}.txt"
              outpath
           else
             puts "!! ERROR - no season match found in slug >#{slug}<"
             exit 1
           end    
end


def split_name( name )

    league = nil
    season = nil
    stage  = nil

           line = name

           ## get season 
           if m = line.match( /\b(?<season>[0-9]{4}
                                          (\/[0-9]{4})?
                                  )
                                  (\b|$)
                               /x )
              season_str = m[:season]    
              season = Season.parse( season_str )          
              m0 = m[0]
              puts " found #{m0} - >#{season}<"
              line =  line.sub( m0, '@' )
              league, stage = line.split('@').map { |value| value.strip }
              [league, 
              season.to_key,
              stage]
           else
             puts "!! ERROR - no season match found in name >#{name}<"
             exit 1
           end    
end




def generate( slug, league:, code:, path:, 
                    pre:, name_pre: )

     page = Worldfootball::Page::Schedule.from_cache( slug )

     title =  page.title.sub('» Spielplan', '').strip
     
    ### derive datafile name from slug
    basename = build_basename( slug, code: code, 
                                      path: path,
                                      pre: pre  )

    puts "   =>  #{basename}  -  #{title}" 
    
    league, season, stage = split_name( title )

    league_heading = String.new
    league_heading << "#{name_pre} #{league} #{season}"
    league_heading << ", #{stage}" if stage
    puts league_heading


    ## todo/fix ??  - reset time to nil - why? why not?
    matches = page.matches

    ## get match records
    recs =  Worldfootball.build( matches, 
                           season: season, 
                           league: league )

    ## pp recs

    ## remove unused columns (e.g. stage, et, p, etc.)
    recs, headers = Worldfootball.vacuum( recs )


    ## convert recs to match structs via text for now
    ##   add mem/data options - why? why not?
    txt =  String.new
    txt << headers.join( ',' )
    txt << "\n"
    recs.each do |values|
      txt << values.join( ',' )
      txt << "\n"
    end
    puts txt

    matches = SportDb::CsvMatchParser.parse( txt )
    pp matches[0]
  
    buf = SportDb::TxtMatchWriter.build( matches, rounds: true )
    puts
    puts buf

    outpath = "/sports/cache.wfb.txt/#{basename}"
    ## add comment with match count, team count and round count - why? why not?
    comment_line = "# #{page.matches.size} match(es), #{page.teams.size} team(s), #{page.rounds.size} round(s)\n\n"
    write_text( outpath, "= #{league_heading}\n\n"+ comment_line + buf )
end



leagues = {
             'at.1' =>  {  code: 'aut',  ## remove country code prefix
                           path: 'austria',
                           name_pre: 'Austria',
                           pre: '1',   ## basename prefix
                        }, 
=begin                        
             'mx.1' => {  code: 'mex',
                          path: 'mexico',
                          name_pre: 'Mexico',
                          pre: '1',
                          }, 
             'mx.2' => {  code: 'mex',
                          path: 'mexico',
                          name_pre: 'Mexico',
                          pre: '2',},
=end
          }


leagues.each_with_index do |(league,league_hash),i|
   path = "./slugs/#{league}.csv"
   recs = read_csv( path )

   puts "==> [#{i+1}/#{leagues.size}] #{league}..."
   puts "  #{recs.size } record(s)"
   recs.each do |rec|
      slug = rec['slug']
      generate( slug, league: league,
                      code: league_hash[:code], 
                      path: league_hash[:path], 
                      pre:  league_hash[:pre],
                      name_pre: league_hash[:name_pre])     
   end
end


puts "bye"