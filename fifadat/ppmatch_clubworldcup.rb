
require_relative 'ppmatch_v0'



seasons = [2025]


## outdir = "../../openfootball/clubworldcup"
outdir = "."


seasons.each do |season|

    buf = String.new
    buf << "= Club World Cup #{season}\n"
    buf <<  "\n"
    buf <<  pp_matches( slug: "clubworldcup",
                       season: season )
   
    puts buf

    write_text( "#{outdir}/more/clubworldcup#{season}.txt", buf )
end


puts "bye"