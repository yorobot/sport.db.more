#
#
#  todo/fix:
##   use official name in "inline" text
##        use short name as a comment only
##     avoids ambigious names for now
##      use query catalog later (for canonicial names)!!!



require 'cocos'
require 'alphabets'   ## use unaccent


$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'webget/football'


Webcache.root = '../../../cache'  ### c:\sports\cache

=begin
Footballsquads::Metal.download_league(
       country: 'austria',
       league: 'ausbun',
       season: '2023-2024'
)

Footballsquads::Metal.download_league(
       country: 'austria',
       league: 'ausbun',
       season: '2022-2023'
)

Footballsquads::Metal.download_league(
       country: 'eng',
       league: 'engprem',
       season: '2023-2024'
)


Footballsquads::Metal.download_squad(
       country: 'austria',
       league: 'bundes',   ## note: different slug/key from league!!!
       season: '2023-2024',
       team:   'austvien'
)

Footballsquads::Metal.download_squad(
       country: 'austria',
       league: 'bundes',   ## note: different slug/key from league!!!
       season: '2023-2024',
       team:   'rapvien'
)

Footballsquads::Metal.download_squad(
       country: 'eng',
       league: 'engprem',  
       season: '2023-2024',
       team:   'liverpool'
)
=end


=begin
Footballsquads::Metal.league(
       country: 'eng',
       league: 'engprem',
       season: '2023-2024'
)

page = Footballsquads::Page::League.from_cache(
       country: 'eng',
       league: 'engprem',
       season: '2023-2024'
)
=end



## pos sort order
POS = {
    'G'  => 1,
    'D'  => 2,
    'M'  => 3,
    'F'  => 4
}
def sort_players( data )
    data.sort do |l,r|
       res = (POS[ l['Pos']] || 99)  <=> ((POS[ r['Pos']] || 99))
       res =  l['Number'].to_i(10)   <=>  r['Number'].to_i(10)  if res == 0
       res
    end
end

def pp_players( data )
    buf = ""
    last_rec = nil
    data.each do |rec|
         ## auto-add separator if starting new pos (e.g. G/D/M/F/??)
         buf << "\n" if last_rec && last_rec['Pos'] != rec['Pos']

         buf << pp_player( rec )
         buf << "\n"
         last_rec = rec
    end
    buf
end

def pp_player( rec )
    buf = ""
    buf << '%2s  ' % rec['Number']
    buf << '%-28s   ' % "#{rec['Name']} (#{rec['Nat']})"
    buf << '%-2s' % rec['Pos']
    buf << "   "

    dob_str = rec['Date of Birth']
    ## note: MUST parse by our own (in ruby year 65 => 2065)
    ## 24-06-99
    ## assert date format
    dob = if dob_str.match( /^\d{2}-\d{2}-\d{2}$/ )
            dob_i = dob_str.split( '-').map { |str| str.strip.to_i(10) }
            Date.new( dob_i[2] < 20 ? 2000+dob_i[2] : 1900+dob_i[2],
                    dob_i[1],
                    dob_i[0] )
          else
              puts "! WARN - no date of birth (or wrong format):"
              pp dob_str
              pp rec
              nil
          end    
          
    buf2 = ""    
    if dob  
      buf2 << "#{dob.strftime( '%d %b %Y' )}"
      buf2 << ", #{rec['Birth Place']}"  if rec['Birth Place'].size > 0 &&
                                           rec['Birth Place'] != '-'
    end 
    buf2 << "  -- #{rec['Previous Club']}"  if rec['Previous Club'].size > 0 &&
                                                rec['Previous Club'] != 'None' 

    ## add comments if available (non-empty only)                                            
    buf << " # #{buf2.strip}"     if buf2.size > 0                                            
    buf
end


def convert_league(  country:,
                     league:,
                     season: )

##  step 1                     
## make sure pages are in cache (download if needed)

Footballsquads::Metal.league(
    country: country,
    league:  league,
    season: season
)

page = Footballsquads::Page::League.from_cache(
    country: country,
    league: league,
    season: season
)

pp page.title

teams = page.teams
puts "   #{teams.size} team(s)"
pp teams

## make sure all team pages are in cache
teams.each do |rec|
    league_slug = rec['league_slug']
    team_slug   = rec['team_slug']
    Footballsquads::Metal.squad(
        country: country,
        league:  league_slug,
        season:  season,
        team:    team_slug
    )
end

teams.each do |rec|
    league_slug = rec['league_slug']
    team_slug   = rec['team_slug']
    team_name   = rec['team_name']
    page = Footballsquads::Page::Squad.from_cache(
             country:  country,
             league:   league_slug,  ## note: different slug/key from league!!!
             season:   season,
             team:     team_slug
           )

   pp page.title
   current, past =  page.players

   puts "current (#{current.size}):"
   pp current
   puts "past (#{past.size}):"
   pp past  
   
   ## e.g. Brighton & Hove Albion => brighton_hove_albion
   slug = unaccent( team_name ).downcase.gsub( /[^a-z0-9 ]/, '').gsub( /[ ]+/, '_' )
   path = "./tmp/#{country}/#{season}/#{slug}.txt"

buf = ""
buf << "= #{team_name}\n\n"
buf << pp_players( sort_players(current))
   
   write_text( path, buf  )
end
end  # method convert_league


=begin
convert_league( country: 'eng',
                league: 'engprem',
                season: '2023-2024'
              )


convert_league( country: 'austria',
                league: 'ausbun',
                season: '2023-2024'
              )

# ger/2023-2024/gerbun.htm
convert_league( country: 'ger',
                league: 'gerbun',
                season: '2023-2024'
              )


# spain/2023-2024/spalali.htm
convert_league( country: 'spain',
                league: 'spalali',
                season: '2023-2024'
              )

# italy/2023-2024/seriea.htm
convert_league( country: 'italy',
                league: 'seriea',
                season: '2023-2024'
              )
=end

# france/2023-2024/fralig1.htm
convert_league( country: 'france',
                league: 'fralig1',
                season: '2023-2024'
              )


puts "bye"

__END__

Footballsquads::Metal.league(
    country: 'austria',
    league: 'ausbun',
    season: '2023-2024'
)

page = Footballsquads::Page::League.from_cache(
    country: 'austria',
    league: 'ausbun',
    season: '2023-2024'
)


pp page.title

teams = page.teams
puts "   #{teams.size} team(s)"
pp teams


## make sure all team pages are in cache
teams.each do |rec|
    league_slug = rec['league_slug']
    team_slug   = rec['team_slug']
    Footballsquads::Metal.squad(
        country: 'austria',
        league: league_slug,
        season: '2023-2024',
        team:   team_slug
    )
end


puts "bye"

__END__

page = Footballsquads::Page::Squad.from_cache(
    country: 'austria',
    league: 'bundes',   ## note: different slug/key from league!!!
    season: '2023-2024',
    team:   'austvien'  #  'rapvien'
)

=begin
page = Footballsquads::Page::Squad.from_cache(
    country: 'eng',
    league: 'engprem',  
    season: '2023-2024',
    team:   'liverpool'
)
=end

pp page.title
current, past =  page.players

puts "current (#{current.size}):"
pp current
puts "past (#{past.size}):"
pp past



puts "current (#{current.size}):"
puts pp_players( sort_players(current) )


puts "bye"


__END__

GK  or  G
DF or   D
MF or   M
FW or   F

= Arsenal

 1  Wojciech Szczęsny (POL)      GK  2007-
13  David Ospina (COL)           GK  2014-
26  Damián Martinez (ARG)        GK  2010-

 2  Mathieu Debuchy (FRA)        DF  2014-
 3  Kieran Gibbs                 DF  2007-
 4 (vc) Per Mertesacker (GER)    DF  2011-
 6  Laurent Koscielny (FRA)      DF  2010-
18  Nacho Monreal (ESP)          DF  2013-
21  Calum Chambers               DF  2014-

 7  Tomáš Rosický (CZE)          MF  2006-
 8 (c) Mikel Arteta (ESP)        MF  2011-
10  Jack Wilshere                MF  2008-
11  Mesut Özil (GER)             MF  2013-
15  Alex Oxlade-Chamberlain      MF  2011-
16  Aaron Ramsey (WAL)           MF  2008-
19  Santi Cazorla (ESP)          MF  2012-
20  Mathieu Flamini (FRA)        MF  2013-
24  Abou Diaby (FRA)             MF  2006-
34  Francis Coquelin (FRA)       MF  2008-
35  Gedion Zelalem (GER)         MF  2013-

 9  Lukas Podolski (GER)         FW   2012-
12  Olivier Giroud (FRA)         FW   2012-
14  Theo Walcott                 FW   2006-
17  Alexis Sánchez (CHI)         FW   2014-
22  Yaya Sanogo (FRA)            FW   2013-
23  Danny Welbeck                FW   2014-
27  Serge Gnabry (GER)           FW   2012-
28  Joel Campbell (CRC)          FW   2011-
