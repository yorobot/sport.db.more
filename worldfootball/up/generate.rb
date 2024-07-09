###
#
#  [002]    2024-05-03 | 03:00 | Club Necaxa            | Gallos Blancos         | 3-2 (0-0, 1-1) i.E.
# !! ERROR - unsupported score format >3-2 (0-0, 1-1) i.E.< - sorry; maybe add a score error fix/patch
#    - allow penality score WITHOUT extra time  (used in mexico etc.)


require_relative 'helper'



module Worldfootball


def self._split_slug( slug )
  
    ### derive datafile name from slug    
##
#  maybe split slug  int parts e.g. - why? why not?
#    1) code  mex|aut
#    2) league
#    3) season
#    4) stage
#    5) modifier (_2)

  league = nil
  season = nil
  stage  = nil


         ## parse slug
           line = slug
           ## cutoff trailing _2  if present
           ## e.g. clausura-playoffs_2 => clausura-playoffs 
           line = line.sub( /_2$/, '' )  
    
           ## get season 
           if m = line.match( /-(?<season>
                                   [0-9]{4}
                                   (-[0-9]{4})?
                                 )
                                  (-|$)
                               /x )
              season_str = m[:season]    
              season = Season.parse( season_str )          
              m0 = m[0]
              puts " found #{m0} - >#{season}<"

              line =  line.sub( m0, '@' )
              league, stage = line.split('@').map { |value| value.strip }
              [league, 
              season.to_path,
              stage]
           else
            puts "!! ERROR - no season match found in slug >#{slug}<"
            exit 1
          end    
end


def self._split_name( name )

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


## add (timezone) offset here too - why? why not?
LEAGUE_SETUPS  = {
  ## note - for now auto-generate  path via name (downcased)
  ##         e.g. Belgium => /belgium

  ## top five (europe)
  'eng' => { code: 'eng', name: 'England'  },
  'es'  =>  { code: 'esp', name: 'Spain' },
  # 'fr'  =>  { code: 'fra', name: 'France' },
  # 'de'  =>  { code: '???', name: 'Germany' },
  'it'  =>  { code: 'ita', name: 'Italy' },


  'be' =>  { code: 'bel', name: 'Belgium'   },  
  'at' =>  { code: 'aut', name: 'Austria'   },
  'hu' =>  { code: 'hun', name: 'Hungary'   },

  'tr' =>  { code: 'tur', name: 'Turkey' },
  'nl' =>  { code: 'ned', name: 'Netherlands' },
  'ch' =>  { code: 'sui',  name: 'Switzerland' },

  'mx' =>  { code: 'mex', name: 'Mexico'    },
  'ar' =>  { code: 'arg', name: 'Argentina' },
  'br' =>  { code: 'bra', name: 'Brazil' },
}


def self._generate_slug( slug, league:,
                               outdir:  )

    ## note - at.3.o  - at (country) 3 (more)  o (- dropped)                
    league_country, league_more = league.split( '.' )
    
    league_setup = LEAGUE_SETUPS[ league_country ]
    if league_setup.nil?
      puts "!! ERROR - no league setup def found for  >#{league_country}<"
      exit 1
    end 

    code        = league_setup[:code]  # e.g. aut
    name_pre    = league_setup[:name]  # e.g. Austria
    extra_path  = name_pre.downcase.gsub( ' ', '-' )   # e.g. austria 
    league_slug_pre = league_more    # eg. 1|2|3|cup  etc.


     page = Page::Schedule.from_cache( slug )

     page_title =  page.title.sub('» Spielplan', '').strip
     
    ### derive datafile name from slug
    league_slug, season_slug, stage_slug = _split_slug( slug )
    ## cut-off aut-/mex-   leading country code if present
    league_slug = league_slug.sub( /^#{code}-/, '' )

    basename = String.new
    basename << "#{extra_path}/#{season_slug}/"
    basename << "#{league_slug_pre}_#{league_slug}"
    basename << "@#{stage_slug}"  if stage_slug
    basename << ".txt"

    puts "   =>  #{basename}  -  #{page_title}" 
    
    league_name, season, stage = _split_name( page_title )

    league_heading = String.new
    league_heading << "#{name_pre} #{league_name} #{season}"
    league_heading << ", #{stage}" if stage
    puts league_heading


    ## todo/fix ??  - reset time to nil - why? why not?
    matches = page.matches

    # 
    # Turkey SüperLig 2024/25
    # 0 rows - build tr.1 2024/25

    if matches.size == 0
      puts "!! WARN - no matches found for league #{league}; skipping generation"
      return
    end

    ## get match records
    recs =  build( matches, 
                           season: season, 
                           league: league )
                     
    if ['at', 'de', 'ch', 
        'hu',
        'nl', 'lu', 'be',
        'it',
        'fr', 'es',
         ].include?(league_country)
       ## do nothing; assume cet / central european time
       ##   see https://en.wikipedia.org/wiki/Time_in_Europe  
    else   
      ## add quick fix for timezone - all times cet - central european (summer) time                       
      ## check: rename (optional) offset to time_offset or such?
 
      offset = OFFSETS[ league_country ]
      if offset.nil?
        puts "!! ERROR - no timezone/offset configured for league country >#{league_country}<"
        exit 1
      end

      ## check for date and time cols
      puts " check date/time in:"
      pp recs[0]
      print "date - "; pp recs[0][2] ## date
      print "time - "; pp recs[0][3] ## time

      recs = recs.map { |rec| fix_date( rec, offset ) }  
    end
    ## pp recs

    ## remove unused columns (e.g. stage, et, p, etc.)
    recs, headers = vacuum( recs )


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

    outpath = "#{outdir}/#{basename}"
    ## add comment with match count, team count and round count - why? why not?
    comment_line = "# #{page.matches.size} match(es), #{page.teams.size} team(s), #{page.rounds.size} round(s)\n\n"
    write_text( outpath, "= #{league_heading}\n\n"+ comment_line + buf )
end
end  # module Worldfootball




module Worldfootball

  ##  use/rename to generate - why? why not?

  ## move slugdir and outdir to config - why? why not?
  def self.generate_seasons( league:,
                outdir:, 
                slugdir: './slugs'
                  )

    ##
    ## todo/fix - make slugs_dir configurable !!!!
    path = "#{slugdir}/#{league}.csv"
    recs = read_csv( path )
    puts "  #{recs.size } record(s)"
 
    ## for debugging generate first six slugs 
    recs[0,6].each do |rec|
       slug = rec['slug']
       ## rename to generate_season or such - why? why not?
       _generate_slug( slug,  league: league,
                       outdir: outdir )     
    end   
  end
end


leagues = %w[
   eng.1 eng.2
   es.1
   it.1
   
   at.1 at.2 at.3.o at.cup
   ch.1 ch.2
   hu.1

   be.1 be.2        be.cup
   nl.1

   tr.1

   mx.1 mx.2 mx.3   mx.cup
   ar.1
   br.1
]



outdir = '/sports/cache.wfb.txt'

leagues.each_with_index do |league,i|
   puts "==> [#{i+1}/#{leagues.size}] #{league}..."

   Worldfootball.generate_seasons( league: league,
                                    outdir: outdir )
end


puts "bye"