
require_relative 'ppmatch_v0'



##
##  - [ ] check for N.N.  goal missing IdPlayer
## ▪ 3rd Place
## Thu Feb 11
##  18:00 UTC+3   Al Ahly FC  0-0 a.e.t., 3-2 pen.  Palmeiras   @ Education City Stadium, Doha
##                  (Badr BENOUN 91'(p), MOHAMED HANY 97'(p), AJAYI Junior 99'(p);
##                   GUSTAVO SCARPA 96'(p), N.N. 98'(p))
##
##  - [ ]  clean stages in interconti
##           FIFA Derby of the Americas
##           FIFA African-Asian-Pacific Playoff
##           FIFA African-Asian-Pacific Play-off 2025™
##           FIFA African-Asian-Pacific Cup 2025™
##           FIFA Derby of the Americas 2025
##           FIFA Challenger Cup 2025
##           FIFA Intercontinental Cup 2025 Final
##
##  - [ ]  add year to first date -  club world cups 2020,2021 start year+1!!!
##   Club World Cup 2020
##    Dates    Mon Feb 1 - Thu Feb 11 2021 (10d)
      


##  note - incl. all club world cups  2000, 2005-2023
##     interconti cup   2024-

seasons = [2000, 
           2005, 2006, 2007, 2008, 2009,
           2010, 2011, 2012, 2013, 2014,
           2015, 2016, 2017, 2018, 2019,
           2020, 2021, 2022, 2023,
           
           2024, 2025]


## outdir = "../../openfootball/clubworldcup"
outdir = "."


##
##   fix - add country code  flag
##            Salzburg (AUT),  Inter Miami (USA), etc.


seasons.each do |season|

     name =  season >= 2024 ? "Intercontinental Cup #{season}"  :
                              "Club World Cup #{season}"  

    buf = String.new
    buf << "= #{name}\n"
    buf <<  "\n"
    buf <<  pp_matches( slug: "interconticup",
                       season: season )
   
    puts buf

    slug = season >= 2024 ? 'interconticup' : 'clubworldcup'
    write_text( "#{outdir}/more/#{slug}#{season}.txt", buf )
end


puts "bye"