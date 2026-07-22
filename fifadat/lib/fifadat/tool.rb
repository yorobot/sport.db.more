

module Fifadat

def self.main( args=ARGV )


opts = {
  season:  nil,
  file:    nil,
  force:   false,
  offline: false,
  reports: true,

  cache_dir:    '/sports/cache.fifadat',
  convert_dir:  '/sports/cache.api.fifa',
}


parser = OptionParser.new do |parser|
parser.banner = "Usage: #{$PROGRAM_NAME} [options] NAME"
   ## add options here
   parser.on( "--season=SEASON",
                 "season" ) do |season|
     opts[:season] = season
   end


  parser.on( "--cache", "--cached", "--offline",
               "always (and only) use cached data in >#{opts[:cache_dir]}< - default is (#{opts[:offline]})" ) do |offline|
    opts[:offline] = offline
  end

  parser.on( "--force",
               "always (force) download fresh copy & overwrite - default is (#{opts[:force]})" ) do |force|
    opts[:force] = force
  end

  parser.on( "--[no-]reports",
               "incl. one-by-one (detailed) match reports - default is (#{opts[:reports]})" ) do |reports|
    opts[:reports] = reports
  end



  parser.on( "-f FILE", "--file FILE",
                "read leagues (and seasons) via .csv file") do |file|
    opts[:file] = file
  end



end
parser.parse!( args )


puts "OPTS:"
pp opts
puts "ARGV:"
pp args


cache_dir    = opts[:cache_dir]
convert_dir  = opts[:convert_dir]



if opts[:file]
   recs = read_csv( opts[:file] )
else

  ## otherwise
  ##   build rec(ord)s from scratch (from command-line args)
  if args.size == 0
    puts " NAME argument (plus season opt) required; use:"
    Fifa::CODES.each do |code, h|
        idCompetition = h[:idCompetition]
        comp = Fifa::COMPETITIONS[idCompetition]
        seasons = comp.values.map { |c| c[:season] }
        puts "  #{code}   (#{seasons.size}) #{seasons.join(',')}"
    end
    exit 1
  end


  ##
  ## note - all args other than first ignored for now; issue warn - why? why not?
  rec = {}
  rec['league']    =  args[0].downcase
  rec['seasons']   =  Season.parse(opts[:season]).to_s
  recs = [rec]
end

pp recs


   ################
   ## step 0) validate slugs & seasons
   recs.each do |rec|
      slug   =  rec['league']
      seasons = Season.parse_line( rec['seasons'] )
      seasons.each do |season|
        pp  Fifa._idSeason_by!( name: slug, season: season )
      end
    end


  if opts[:offline] == false
    ## step 1a) prepare
   recs.each do |rec|
      slug   =  rec['league']
      seasons = Season.parse_line( rec['seasons'] )
      seasons.each do |season|

        prepare( name:    slug,
                 season:  season,
                 outdir:  cache_dir,
                 force: opts[:force] )    ## note - autoadd slug (name) e..g ./eng !!

=begin
        ###
        ## add debug
        page = String.new
        page << "= #{slug} #{season}\n"
        page << "#  generated on #{Time.now}\n"
        page <<  "\n"

        buf = pp_debug( slug: slug, season: season,
                    indir: cache_dir )

        page << buf
        puts page

        outpath =  "#{convert_dir}/#{season.to_path}_#{slug}-debug.txt"

        write_text( outpath, page )
        puts "  written to >#{outpath}<"
=end
      end
    end

    if opts[:reports]
      ## step 1b) prepare details
      recs.each do |rec|
        slug   =  rec['league']
        seasons = Season.parse_line( rec['seasons'] )
        seasons.each do |season|
          ## match (reports) one-by-one
          prepare_reports( name:    slug,
                         season:  season,
                         outdir:  cache_dir,    ## note - autoadd slug (name) e..g ./eng !!
                         force: opts[:force] )
        end
      end
    end # if reports
  end  ## if online (offline==false)




   ## step 2) convert
   recs.each do |rec|
      slug   =  rec['league']
      seasons = Season.parse_line( rec['seasons'] )
      seasons.each do |season|

        convert( slug: slug, season: season,
                               indir: cache_dir,
                              outdir: convert_dir )


        ##  convert all match reports one-by-one
        convert_reports( slug: slug, season: season,
                                     indir: cache_dir,
                                     outdir: convert_dir )
      end
   end

puts "bye"

end


end  # module Fifadat