require_relative 'read'



STAT        = Stat.new
LEAGUE_STAT = {}

def check( league:, year: )

  path         = "./dl/competitions~~#{LEAGUES[league.downcase]}~~matches-I-season~#{year}.json"

  data         = read_json( path )

  matches = data[ 'matches']
  matches.each do |m|

    score   = m['score']


    stat = STAT.update( m )

    stage_key = m['stage'].downcase.to_sym

    ## track all leagues with non-regular stages
    if stage_key != :regular_season
      league_stat = LEAGUE_STAT[ league ] ||= {}
      year_stat   = league_stat[ year ] ||= {}
      stat        = year_stat[ stage_key ] ||= { duration: Hash.new( 0 ),
                                                 status:   Hash.new( 0 ),
                                                 group:    Hash.new( 0 ),
                                                 matchday: Hash.new( 0 ),
                                               }
      stat[:group][ m['group'] ]  += 1
      stat[:duration][ score['duration'] ] += 1   ## track - assert always REGULAR
      stat[:status][ m['status'] ]  += 1
      stat[:matchday][ m['matchday'] ]  += 1
    end
  end
end # method convert



DATASETS = [['BR.1',  %w[2018 2019 2020]],
            ['DE.1',  %w[2018 2019]],
            ['NL.1',  %w[2018 2019]],
            ['ES.1',  %w[2018 2019]],
            ['PT.1',  %w[2018 2019]],
            ['ENG.1', %w[2018 2019]],
            ['ENG.2', %w[2018 2019]],
            ['FR.1',  %w[2018 2019]],
            ['IT.1',  %w[2018 2019]],

            ['CL',    %w[2018 2019]],
           ]

pp DATASETS

DATASETS.each do |dataset|
  basename = dataset[0]
  dataset[1].each do |year|
    check( league: basename, year: year )
  end
end

pp STAT[:all]

puts "---"

pp LEAGUE_STAT



