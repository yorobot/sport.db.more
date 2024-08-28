############
# to run use:
#    $ ruby up/top2024.rb


require_relative 'helper'   ## (shared) boot helper


########
# helper
#   normalize team names

###    fix !!!!!   - always add season:  (for generic interface/api)
##      e.g. def normalize( matches, league:, season: )

  def normalize( matches, league:, season: )
    matches = matches.sort do |l,r|
      ## first by date (older first)
      ## next by matchday (lowwer first)

     ## todo/fix
     ##    if no time  (assume 0:00 for now)

      res =   l.date <=> r.date
      res =   (l.time ? l.time : '0:00') <=> (r.time ? r.time : '0:00')    if res == 0
      res =   l.round <=> r.round   if res == 0
      res
    end


    league = League.find!( league )

    stats = {}

    ## todo/fix: cache name lookups - why? why not?
    puts "   normalize #{matches.size} matches..."
    matches.each_with_index do |match,i|
       team1 = Club.find_by!( name:   match.team1,
                              league: league )
       team2 = Club.find_by!( name:   match.team2,
                              league: league )

       if match.team1 != team1.name
          stat = stats[ match.team1 ] ||= Hash.new(0)
          stat[ team1.name ] += 1
       end

       if match.team2 != team2.name
          stat = stats[ match.team2 ] ||= Hash.new(0)
          stat[ team2.name ] += 1
       end

       match.update( team1: team1.name )
       match.update( team2: team2.name )
    end

    if stats.size > 0
      pp stats
    end

    print "norm OK\n"

    matches
  end



require_relative 'datasets2024'   ## shared config (prepare+top)


# datasets = DATASETS_MORE + DATASETS_TOP
datasets = DATASETS_TOP
pp datasets


OPTS = {
  # push: true
}



gh = SportDb::GitHubSync.new( datasets )

## always pull before push!! (use fast_forward)
gh.git_fast_forward_if_clean  if OPTS[:push]


outdir = if OPTS[:push]
             SportDb::GitHubSync.root
         else
             "./tmp"
         end

Writer.config.out_dir = outdir
pp Writer.config.out_dir


normproc = method(:normalize).to_proc
# pp normproc
# normproc.call( [], league: 'eng.1' )



datasets.each_with_index do |(league_key, seasons),i|

  seasons.each_with_index do |season,j|

    puts "==> [#{i+1}/#{datasets.size}]  #{league_key} #{season} [#{j+1}/#{seasons.size}]..."

    ## todo/fix - add download option
    ## Footballdata.schedule( league: league_key, season: season )

    Footballdata.convert( league: league_key, season: season )

    ##
    ### fix - allow normalize opt with proc!!!!

    ## matches = normalize( matches, league: league_key )

    Writer.write( league: league_key,
                  season: season,
                  source: Footballdata.config.convert.out_dir,
                  normalize: normproc )
                  ## normalize: false
  end
end



## todo/fix: add a getch or something to hit return before commiting pushing - why? why not?
gh.git_push_if_changes    if OPTS[:push]


puts "bye"

