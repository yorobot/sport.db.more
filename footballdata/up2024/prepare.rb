$LOAD_PATH.unshift( '../../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( '../lib' )

require 'footballdata'



#########
# download latest
Webcache.root = '../../../../cache'  ### c:\sports\cache

Webget.config.sleep  = 11    ## max. 10 requests/minute

# Footballdata.schedule( league: 'eng.1', season: '2023/24' )
# Footballdata.schedule( league: 'eng.2', season: '2023/24' )
# Footballdata.schedule( league: 'eng.2', season: '2022/23' )
# Footballdata.schedule( league: 'eng.2', season: '2021/22' )
# Footballdata.schedule( league: 'eng.2', season: '2020/21' )

# Footballdata.schedule( league: 'de.1',  season: '2023/24' )
# Footballdata.schedule( league: 'fr.1',  season: '2023/24' )

# note:  it.1 2023/2024 ends jul/2 !!!
# Footballdata.schedule( league: 'it.1',  season: '2023/24' )

# note: es.1 2023/2024 end may/26 !!!
# Footballdata.schedule( league: 'es.1',  season: '2023/24' )

# Footballdata.schedule( league: 'pt.1',  season: '2023/24' )
# Footballdata.schedule( league: 'nl.1',  season: '2023/24' )

# Footballdata.schedule( league: 'br.1',  season: '2024' )
# Footballdata.schedule( league: 'br.1',  season: '2023' )
# Footballdata.schedule( league: 'br.1',  season: '2022' )
# Footballdata.schedule( league: 'br.1',  season: '2021' )
# Footballdata.schedule( league: 'br.1',  season: '2020' )


#####
# convert for staging

Footballdata.config.convert.out_dir = '../../../../stage'

pp File.expand_path( Footballdata.config.convert.out_dir )
#=> "C:/sports/stage"


## use LATEST_SEASONS or such - why? why not?
SEASONS = %w[2023/24 2022/23 2021/22 2020/21]

DATASETS_TOP = [
 ['eng.1',   SEASONS + %w[2024/25]],  
 ['de.1',    SEASONS],
 ['es.1',    SEASONS],
 ['it.1',    SEASONS], # - %w[2023/24]],
 ['fr.1',    SEASONS],
]


DATASETS_MORE = [
# ['eng.2', SEASONS], #  %w[2023/24]],
# ['pt.1', SEASONS],
# ['nl.1', SEASONS],
  ['br.1', %w[2024 2023 2022 2021 2020]],
]


datasets = DATASETS_TOP + DATASETS_MORE
datasets.each do |league, seasons|
  seasons.each_with_index do |season,i|
    puts "==> #{league} #{season} - #{i+1}/#{seasons.size}..."
    Footballdata.convert( league: league, season: season )
  end 
end



puts "bye"



__END__

eng.2  - championship includes playoff e.g.
            add later how???
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping FINAL

!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping SEMI_FINALS
!!! unexpected stage:
-- skipping FINAL

!!! unexpected stage:
-- skipping PLAYOFFS
!!! unexpected stage:
-- skipping PLAYOFFS
!!! unexpected stage:
-- skipping PLAYOFFS
!!! unexpected stage:
-- skipping PLAYOFFS
!!! unexpected stage:
-- skipping PLAYOFFS



double check for more (*) awared, cancelled, and such!!!


!! check for 2020/21 in it.1
  1,Sat Sep 19 2020,Hellas Verona FC,3-0 (*),,AS Roma,awarded

  
!! ERROR: unsupported match status >IN_PLAY< - sorry:
"utcDate"=>"2024-05-20T16:30:00Z",
"status"=>"IN_PLAY",
"matchday"=>37,

note - IN_PLAY (same as playing now!!! LIVE)
##  retry when match ended!!!!

!! ERROR: unsupported match status >PAUSED< - sorry:
## - why paused??
{"area"=>{"id"=>2114, "name"=>"Italy", "code"=>"ITA", "flag"=>"https://crests.football-data.org/784.svg"},
 "utcDate"=>"2024-05-20T18:45:00Z",
 "status"=>"PAUSED",
 "matchday"=>37,



====  es.1 2023/24  =============
  match stati: {"FINISHED"=>370, "TIMED"=>10}
====  it.1 2023/24  =============
  match stati: {"FINISHED"=>370, "TIMED"=>10}
====  it.1 2020/21  =============
  match stati: {"FINISHED"=>379, "AWARDED"=>1}
====  fr.1 2021/22  =============
  match stati: {"FINISHED"=>380, "CANCELLED"=>2}


