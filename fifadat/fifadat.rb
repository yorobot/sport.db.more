
require_relative './lib/fifadat'



args = ARGV
opts = {
  cached: false,
  season: nil,
  file:   nil,
  lint:   false,
}


parser = OptionParser.new do |parser|
parser.banner = "Usage: #{$PROGRAM_NAME} [options] NAME"
   ## add options here
   parser.on( "--season=SEASON",
                 "season" ) do |season|
     opts[:season] = season
   end


  parser.on( "--cache", "--cached", "--offline",
               "use cached data in #{'??'} - default is (#{opts[:cached]})" ) do |cached|
    opts[:cached] = cached
  end

  parser.on( "-f FILE", "--file FILE",
                "read leagues (and seasons) via .csv file") do |file|
    opts[:file] = file
  end

  parser.on( "--lint",
               "turn on lint (debug) mode - default is (#{opts[:lint]})" ) do |lint|
    opts[:lint] = lint
  end


end
parser.parse!( args )


puts "OPTS:"
pp opts
puts "ARGV:"
pp args


cache_dir    = '/sports/cache.fifadat'
convert_dir  = '/sports/cache.api.fifa'



if opts[:file]
   recs = read_csv( opts[:file] )
else

  ## otherwise
  ##   build rec(ord)s from scratch (from command-line args)
  if args.size == 0
    puts " NAME argument required; use:"
    pp Fifa::COMPETITION_ID.keys
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


if opts[:lint]
   recs.each do |rec|
      slug   =  rec['league']
      seasons = Season.parse_line( rec['seasons'] )
      seasons.each do |season|
        ###
        ## add debug


       data =  read_json( "#{indir}/#{slug}/#{season.to_path}_matches.json" )


        page = String.new
        page << "= #{slug} #{season}\n"
        page << "#  generated on #{Time.now}\n"
        page <<  "\n"

        buf = pp_debug( slug: slug, season: season,
                    indir: cache_dir )

        page << buf
        puts page

        outpath =  "#{convert_dir}/#{season.to_path}_#{slug}-debug.txt"

        ## write_text( outpath, page )
        ## puts "  written to >#{outpath}<"
      end
    end
else

   ## add
   ## step 0) validate slugs & seasons

   ## step 1a) prepare
   recs.each do |rec|
      slug   =  rec['league']
      seasons = Season.parse_line( rec['seasons'] )
      seasons.each do |season|

        pp  Fifa._idSeason_by!( name: slug, season: season )

        prepare( name:    slug,
                 season:  season,
                 outdir:  cache_dir )    ## note - autoadd slug (name) e..g ./eng !!

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
      end
    end

    ## step 1b) prepare details
    recs.each do |rec|
      slug   =  rec['league']
      seasons = Season.parse_line( rec['seasons'] )
      seasons.each do |season|
        ## match (reports) one-by-one
        prepare_reports( name:    slug,
                         season:  season,
                         outdir:  cache_dir )    ## note - autoadd slug (name) e..g ./eng !!
      end
    end


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
end

puts "bye"
