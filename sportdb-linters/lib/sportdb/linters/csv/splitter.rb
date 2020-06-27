# encoding: utf-8


class CsvMatchSplitter


def self.split( path, out_root: './o', basename: '1-liga',
                       sep: ',',
                       col: 'Season',
                       format: 'short',
                       headers: nil )

  ## check if headers incl. season if yes,has priority over col mapping
  ##  e.g. no need to specify twice (if using headers)
  col = headers[:season]    if headers && headers[:season]

   ## format: 'short'  => season format for SeasonUtils.directory
   ##   e.g. 2017-18 or 2010s/2017-18 etc.

  seasons = CsvMatchReader.find_seasons( path, col: col, sep: sep )
  pp seasons

=begin
## AUT.csv
{"2012/2013"=>180,
 "2013/2014"=>180,
 "2014/2015"=>180,
 "2015/2016"=>180,
 "2016/2017"=>180,
 "2017/2018"=>182}

## MEX.csv
{"2012/2013"=>334,
 "2013/2014"=>334,
 "2014/2015"=>334,
 "2015/2016"=>334,
 "2016/2017"=>334,
 "2017/2018"=>332}
=end

  seasons.each do |season|
      matches = CsvMatchReader.read( path, headers: headers, sep: sep,
                                           filters: { col => season } )

      pp matches[0..2]
      pp matches.size

      out_path = "#{out_root}/#{SeasonUtils.directory(season, format: format)}/#{basename}.csv"
      ## make sure parent folders exist
      FileUtils.mkdir_p( File.dirname(out_path) )  unless Dir.exists?( File.dirname( out_path ))

      CsvMatchWriter.write( out_path, matches )

      ###
      ## todo: fix!!!  allow convert date/time in .csv !!!!
      ##   for mx-mexico (assume utc and convert to local time e.g. -6 hours or something!!)
      ##      will change 1:00 to one day back!!!!
  end
end


end # class CsvMatchSplitter
