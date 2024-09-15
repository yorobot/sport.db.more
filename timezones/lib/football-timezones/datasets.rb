

module Datasets
def self.parse_args( args )
    ### split args in datasets with leagues and seasons
    datasets = []
    args.each do |arg|
       if arg =~ %r{^[0-9/-]+$}   ##  season
           if datasets.empty?
             puts "!! ERROR - league required before season arg; sorry"
             exit 1
           end

           season = Season.parse( arg )  ## check season
           datasets[-1][1] << season
       else ## assume league key
           key = arg.downcase
           datasets << [key, []]
       end
    end
    datasets
end


def self.parse( txt )
    ### split args in datasets with leagues and seasons
    datasets = []
    recs = parse_csv( txt )
    recs.each do |rec|
        key = rec['league'].downcase
        datasets << [key, []]

        seasons_str = rec['seasons']
        seasons = seasons_str.split( /[ ]+/ )

        seasons.each do |season_str|
            season = Season.parse( season_str )  ## check season
            datasets[-1][1] << season
        end
    end
    datasets
end

def self.read( path )
    parse( read_text( path ))
end
end  # module Datasets

