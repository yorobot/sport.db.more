
module Writer


SOURCES = {
  'one'      =>  { path: '../../stage/one' },
  'one/o'    =>  { path: '../apis/o' },     ## "o" debug version

  'two'     =>  { path: '../../stage/two' },
  'two/o'   =>  { path: '../cache.weltfussball/o' },      ## "o"   debug version
  'two/tmp' =>  { path: '../cache.weltfussball/tmp' },    ## "tmp" debug version

  'leagues'   =>  { path: '../../../footballcsv/cache.leagues' },
  'leagues/o' =>  { path: '../cache.leagues/o' },    ## "o"  debug version

  'soccerdata' => { path:   '../../../footballcsv/cache.soccerdata',
                    format: 'century', # e.g. 1800s/1888-89
                  }
}



def self.merge_goals( matches, goals )
  goals_by_match = goals.group_by { |rec| rec.match_id }
  puts "match goal reports - #{goals_by_match.size} records"

  ## lets group by date for easier lookup
  matches_by_date = matches.group_by { |rec| rec.date }


  ## note: "shadow / reuse" matches and goals vars for now in loop
  ##  find better names to avoid confusion!!
  goals_by_match.each_with_index do |(match_id, goals),i|
    ## split match_id
    team_str, more_str   = match_id.split( '|' )
    team1_str, team2_str = team_str.split( ' - ' )

    more_str  = more_str.strip
    team1_str = team1_str.strip
    team2_str = team2_str.strip

    ## for now assume date in more (and not round or something else)
    date_str = more_str  # e.g. in 2019-07-26 format

    puts ">#{team1_str}< - >#{team2_str}< | #{date_str},    #{goals.size} goals"

    ## try a join - find matching match
    matches = matches_by_date[ date_str ]
    if matches.nil?
      puts "!! ERROR: no match found for date >#{date_str}<"
      exit 1
    end

    found_matches = matches.select {|match| match.team1 == team1_str &&
                                            match.team2 == team2_str }

    if found_matches.size == 1
      match = found_matches[0]
      match.goals = SportDb::Import::Goal.build( goals )
    else
      puts "!!! ERROR: found #{found_matches.size} in #{matches.size} matches for date >#{date_str}<:"
      matches.each do |match|
        puts "  >#{match.team1}< - >#{match.team2}<"
      end
      exit 1
    end
  end
end




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




def self.split_matches( matches, season: )
  matches_i  = []
  matches_ii = []
  matches.each do |match|
    date = Date.strptime( match.date, '%Y-%m-%d' )
    if date.year == season.start_year
      matches_i << match
    elsif date.year == season.end_year
      matches_ii << match
    else
      puts "!! ERROR: match date-out-of-range for season:"
      pp season
      pp date
      pp match
      exit 1
    end
  end
  [matches_i, matches_ii]
end



###
# todo/check:  use Writer.open() or FileWriter.open() or such - why? why not?
def self.write_buf( path, buf )  ## write buffer helper
  ## for convenience - make sure parent folders/directories exist
  FileUtils.mkdir_p( File.dirname( path ))  unless Dir.exist?( File.dirname( path ))

  File.open( path, 'w:utf-8' ) do |f|
    f.write( buf )
  end
end



def self.write( league, season, source:,
                                extra: nil,
                                split: false,
                                normalize: true,
                                rounds: true )
  season = Season( season )  ## normalize season

  league_info = LEAGUES[ league ]
  if league_info.nil?
    puts "!! ERROR - no league found for >#{league}<; sorry"
    exit 1
  end

  ## check - if source is directory (assume if starting ./ or ../ or /)
  if source.start_with?( './')  ||
     source.start_with?( '../') ||
     source.start_with?( '/')
     ## check if directory exists
     unless File.exist?( source )
       puts "!! ERROR: source dir >#{source}< does not exist"
       exit 1
     end
     source_info = { path: source }   ## wrap in "plain" source dir in source info
  else
    source_info = SOURCES[ source ]
    if source_info.nil?
      puts "!! ERROR - no source found for >#{source}<; sorry"
      exit 1
    end
  end

  source_path = source_info[:path]

  ## format lets you specify directory layout
  ##   default   = 1888-89
  ##   century   = 1800s/1888-89
  ##   ...
  season_path = season.to_path( (source_info[:format] || 'default').to_sym )
  in_path = "#{source_path}/#{season_path}/#{league}.csv"   # e.g. ../stage/one/2020/br.1.csv


  matches = SportDb::CsvMatchParser.read( in_path )
  puts "matches- #{matches.size} records"


  ## check for goals
  in_path_goals = "#{source_path}/#{season_path}/#{league}~goals.csv"   # e.g. ../stage/one/2020/br.1~goals.csv
  if File.exist?( in_path_goals )
    goals = SportDb::CsvGoalParser.read( in_path_goals )
    puts "goals - #{goals.size} records"
    pp goals[0]

    puts
    puts "merge goals:"
    merge_goals( matches, goals )
  end


  pp matches[0]


  matches = normalize( matches, league: league, season: season )   if normalize



  league_name  = league_info[ :name ]      # e.g. Brasileiro Série A
  basename     = league_info[ :basename]   #.e.g  1-seriea

  league_name =  league_name.call( season )   if league_name.is_a?( Proc )  ## is proc/func - name depends on season
  basename    =  basename.call( season )      if basename.is_a?( Proc )  ## is proc/func - name depends on season

  lang         = league_info[ :lang ] || 'en_AU'  ## default / fallback to en_AU (always use rounds NOT matchday for now)
  repo_path    = league_info[ :path ]      # e.g. brazil or world/europe/portugal etc.


  season_path = String.new('')    ## note: allow extra path for output!!!! e.g. archive/2000s etc.
  season_path << "#{extra}/"   if extra
  season_path << season.path


  ## check for stages
  stages = league_info[ :stages ]
  stages = stages.call( season )    if stages.is_a?( Proc )  ## is proc/func - stages depends on season


  if stages

  ## split into four stages / two files
  ## - Grunddurchgang
  ## - Finaldurchgang - Meister
  ## - Finaldurchgang - Qualifikation
  ## - Europa League Play-off

  matches_by_stage = matches.group_by { |match| match.stage }
  pp matches_by_stage.keys


  ## stages = prepare_stages( stages )
  pp stages


  romans = %w[I II III IIII V VI VII VIII VIIII X XI]  ## note: use "simple" romans without -1 rule e.g. iv or ix

  stages.each_with_index do |stage, i|

    ## assume "extended" style / syntax
    if stage.is_a?( Hash ) && stage.has_key?( :names )
      stage_names    = stage[ :names ]
      stage_basename = stage[ :basename ]
      ## add search/replace {basename} - why? why not?
      stage_basename = stage_basename.sub( '{basename}', basename )
    else  ## assume simple style (array of strings OR hash mapping of string => string)
      stage_names    = stage
      stage_basename =  if stages.size == 1
                            "#{basename}"  ## use basename as is 1:1
                         else
                            "#{basename}-#{romans[i].downcase}"  ## append i,ii,etc.
                         end
    end

    buf = build_stage( matches_by_stage, stages: stage_names,
                                         name: "#{league_name} #{season.key}",
                                         lang: lang )

    ## note: might be empty!!! if no matches skip (do NOT write)
    write_buf( "#{config.out_dir}/#{repo_path}/#{season_path}/#{stage_basename}.txt", buf )   unless buf.empty?
  end
  else  ## no stages - assume "regular" plain vanilla season

## always (auto-) sort for now - why? why not?
matches = matches.sort do |l,r|
  ## first by date (older first)
  ## next by matchday (lower first)
  res =   l.date <=> r.date
  res =   l.time <=> r.time     if res == 0 && l.time && r.time
  res =   l.round <=> r.round   if res == 0 && rounds
  res
end

  if split
    matches_i, matches_ii = split_matches( matches, season: season )

    out_path = "#{config.out_dir}/#{repo_path}/#{season_path}/#{basename}-i.txt"

    SportDb::TxtMatchWriter.write( out_path, matches_i,
                                   name: "#{league_name} #{season.key}",
                                   lang:  lang,
                                   rounds: rounds )

    out_path = "#{config.out_dir}/#{repo_path}/#{season_path}/#{basename}-ii.txt"

    SportDb::TxtMatchWriter.write( out_path, matches_ii,
                                   name: "#{league_name} #{season.key}",
                                   lang:  lang,
                                   rounds: rounds )
  else
    out_path = "#{config.out_dir}/#{repo_path}/#{season_path}/#{basename}.txt"

    SportDb::TxtMatchWriter.write( out_path, matches,
                                   name: "#{league_name} #{season.key}",
                                   lang:  lang,
                                   rounds: rounds )
  end
  end
end


=begin
def prepare_stages( stages )
  if stages.is_a?( Array )
     if stages[0].is_a?( Array )  ## is array of array
       ## convert inner array shortcuts to hash - stage input is same as stage output
       stages.map {|ary| ary.reduce({}) {|h,stage| h[stage]=stage; h }}
     elsif stages[0].is_a?( Hash )  ## assume array of hashes
       stages  ## pass through as is ("canonical") format!!!
     else ## assume array of strings
      ## assume single array shortcut; convert to hash - stage input is same as stage output name
      stages = stages.reduce({}) {|h,stage| h[stage]=stage; h }
      [stages]  ## return hash wrapped in array
     end
  else  ## assume (single) hash
    [stages] ## always return array of hashes
  end
end
=end



def self.build_stage( matches_by_stage, stages:, name:, lang: )
  buf = String.new('')

  ## note: allow convenience shortcut - assume stage_in is stage_out - auto-convert
  stages = stages.reduce({}) {|h,stage| h[stage]=stage; h }   if stages.is_a?( Array )

  stages.each_with_index do |(stage_in, stage_out),i|
    matches = matches_by_stage[ stage_in ]   ## todo/fix: report error if no matches found!!!

    next if matches.nil? || matches.empty?

    ## (auto-)sort matches by
    ##  1) date
    matches = matches.sort do |l,r|
      result = l.date  <=> r.date
      result
    end

    buf << "\n\n"   if i > 0 && buf.size > 0

    buf << "= #{name}, #{stage_out}\n"
    buf << SportDb::TxtMatchWriter.build( matches, lang: lang )

    puts buf
  end

  buf
end


end   # module Writer
