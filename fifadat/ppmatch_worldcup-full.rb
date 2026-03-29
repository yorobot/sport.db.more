require_relative 'helper'



## pretty print matches




seasons = [1930, 1934, 1938,
           1950, 1954, 1958, 1962, 1966, 1970, 1974, 1978,
           1982, 1986, 1990, 1994, 1998, 2002, 2006, 2010,
           2014, 2018, 2022]

## outdir = "../../openfootball/worldcup"
outdir = "./"


seasons.each do |season|
   buf = String.new
   buf << "= World Cup #{season}\n"
   buf << "\n"
   buf <<  pp_matches_full( slug: 'worldcup',
                            season: season )
   puts buf
   
   write_text( "#{outdir}/more/#{season}_full.txt", buf )
end


puts "bye"