require_relative './lib/fifadat'


## e.g. 2020
##      2020/2021
SEASON_RE = %r{  \b
                    (?<season> \d{4}
                                 (?: [/-] \d{4} )?
                    )
                  \b
                }x

SEASON_HEADERS = [
   'season',
   'id_season',
    'id_comp',
    'start_date',
    'end_date',
    'name'
]


## collect records
##   season,  id_season, id_comp,  name,  start_date, end_date
def collect_seasons( data )
  recs = []
  seasons = data['Results']

  seasons.each do |h|
    id_comp         = h['IdCompetition']
    id_season       = h['IdSeason']
    start_date_utc  = h['StartDate']
    end_date_utc    = h['EndDate']

    name            = desc( h['Name'])
    if m=SEASON_RE.match(name)
       season = Season.parse( m[:season] ).to_s
    else
       raise ArgumentError,
          "no season match found in name >#{name}< in: #{h.pretty_inspect}"
    end

    recs << [season,
             id_season,
             id_comp,
             start_date_utc,
             end_date_utc,
             name
            ]
  end
  recs
end


outdir = "./lib/fifadat/config/seasons"


args = ARGV

## name = 'worldcup'
name = args[0] || 'uefa.cl'


if name == 'clubs' || name == 'club'
## update all club configs!!

  Fifa::CODES.values.each do |rec|
      next if !rec[:club]   ## skip if NOT club

      code          = rec[:code]   ## note - using code (NOT name here)
      idCompetition = rec[:idCompetition]

      path = "./cache.json/seasons/#{code}_seasons.json"
      url  = Fifa::Metal.seasons_url( idCompetition: idCompetition)

      fetch_json_if( url, path )

      data = read_json_v2( path )
      recs = collect_seasons( data )

      puts "  #{code} | #{recs.size} season(s)"
      ## pp recs

      outpath = "#{outdir}/#{code}.csv"
      write_csv( outpath, recs, headers: SEASON_HEADERS )
  end
else
  idCompetition = Fifa._idComp_by!( name: name )

  path = "./cache.json/seasons/#{name}_seasons.json"
  url  = Fifa::Metal.seasons_url( idCompetition: idCompetition)

  fetch_json_if( url, path )

  data = read_json_v2( path )
  recs = collect_seasons( data )

  puts "  #{recs.size} season(s)"
  pp recs

  outpath = "#{outdir}/#{name}.csv"

  write_csv( outpath, recs, headers: SEASON_HEADERS )
end


puts "bye"
