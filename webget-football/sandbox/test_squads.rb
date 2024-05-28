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



## pos sort order
POS = {
    'G'  => 1,
    'D'  => 2,
    'M'  => 3,
    'F'  => 4
}

## pretty print (pp) pos
# 
# GK  or  G
# DF or   D
# MF or   M
# FW or   F

PPPOS = {
    'G'  => 'GK',  # goal keeper
    'D'  => 'DF',  # defence
    'M'  => 'MF',  # mid fielder
    'F'  => 'FW',  # forward
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
    buf << '%-2s' % PPPOS[rec['Pos']] || "??#{rec['Pos']}"
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


def convert_league(  league:,
                     season: )

league_page = Footballsquads.league( league: league, season: season )
pp league_page.title

league_page.each_team do |team_page|
   pp team_page.title

   team_name         =  team_page.team_name
   pp team_name
   team_name_official = team_page.team_name_official
   pp team_name_official

   current, past =  team_page.players

   puts "current (#{current.size}):"
   pp current
   puts "past (#{past.size}):"
   pp past  
   
   ## e.g. Brighton & Hove Albion => brighton_hove_albion
   slug = unaccent( team_name ).downcase.gsub( /[^a-z0-9 ]/, '').gsub( /[ ]+/, '_' )
   season_slug = Season( season ).to_path
   path = "./tmp/#{league}/#{season_slug}/#{slug}.txt"


## note - use official (long) team name - add (short) team name as comment   
buf = ""
buf << "= #{team_name_official}    # #{team_name}\n\n"
buf << pp_players( sort_players(current))
   
   write_text( path, buf  )
end
end  # method convert_league




DATASETS = [
  ['eng.1',   %w[2023/24]],
  ['de.1',    %w[2023/24]],
  ['es.1',    %w[2023/24]],
  ['fr.1',    %w[2023/24]],
  ['it.1',    %w[2023/24]],

  ['at.1',    %w[2023/24]],
]

DATASETS.each do |league, seasons|
  seasons.each do |season|
    convert_league( league: league, season: season )
  end
end

puts "bye"


