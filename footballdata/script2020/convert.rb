require_relative 'lib/convert'


# OUT_DIR = './o'
# OUT_DIR = '../../stage/one'



=begin
DATASETS = [['BR.1',  %w[2018 2019 2020]],
            ['DE.1',  %w[2018 2019]],
            ['NL.1',  %w[2018 2019]],
            ['ES.1',  %w[2018 2019]],
            ['PT.1',  %w[2018 2019]],
            ['ENG.1', %w[2018 2019]],
            ['ENG.2', %w[2018 2019]],
            ['FR.1',  %w[2018 2019]],
            ['IT.1',  %w[2018 2019]],
           ]
=end

DATASETS = [['nl.1',  %w[2018/19 2019/20]],
            ['pt.1',  %w[2018/19 2019/20]],
            ['eng.1', %w[2018/19 2019/20]],
            ['eng.2', %w[2018/19 2019/20]],
            ['br.1',  %w[2020    2019     2018]],  # note: season is calendar year
           ]

pp DATASETS

DATASETS.each do |dataset|
  league  = dataset[0]
  seasons = dataset[1]
  seasons.each do |season|
    Footballdata.convert( league: league, season: season )
  end
end


=begin
convert( league: 'ENG.1', year: 2018 )
convert( league: 'ENG.1', year: 2019 )

convert( league: 'ENG.2', year: 2018 )
convert( league: 'ENG.2', year: 2019 )

convert( league: 'ES.1', year: 2018 )
convert( league: 'ES.1', year: 2019 )

convert( league: 'PT.1', year: 2018 )
convert( league: 'PT.1', year: 2019 )

convert( league: , year: 2018 )
convert( league: 'DE.1', year: 2019 )

convert( league: 'NL.1', year: 2018 )
convert( league: 'NL.1', year: 2019 )

convert( league: 'FR.1', year: 2018 )
convert( league: 'FR.1', year: 2019 )

convert( league: 'IT.1', year: 2018 )
convert( league: 'IT.1', year: 2019 )

convert( league: 'BR.1', year: 2018 )
convert( league: 'BR.1', year: 2019 )
convert( league: 'BR.1', year: 2020 )
=end

# convert( league: 'FR.1',  year: 2019 )
# convert( league: 'ENG.1', year: 2018 )

# convert( league: 'ENG.1', year: 2019 )
# convert( league: 'ENG.2', year: 2019 )
