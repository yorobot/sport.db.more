
require_relative 'helper'



seasons = [2025]


## outdir = "../../openfootball/clubworldcup"
outdir = "."


seasons.each do |season|

    buf = String.new
    buf << "= Club World Cup #{season}\n"
    buf <<  "\n"
    buf <<  pp_matches_full( slug: "clubworldcup",
                       season: season,
                       country: true )
   
    puts buf

    write_text( "#{outdir}/more/clubworldcup#{season}-full.txt", buf )
end


puts "bye"