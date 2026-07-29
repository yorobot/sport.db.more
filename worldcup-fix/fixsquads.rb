##
##  fix squads in /worldcup
##    merge directory in all-in-one squads.txt file!


require 'cocos'

=begin
##############################
# Argentina (ARG)
#   - 22 players
=end

HEADER_RE = %r{
     ^ \#{2,}    \n
     ^ \# [ ]+        (?<country> .+?)  [ ]*  \n
     ^ \# [ ]+ - [ ]+ (?<players> .+?)  [ ]*  \n
}ix


def merge( basedir, year: )

  return  unless Dir.exist?( "#{basedir}/squads" )

  files = Dir.glob( "#{basedir}/squads/**/*.txt" )
  pp files
  puts "  #{files.size }file(s)"

  buf = String.new
  buf << "= World Cup #{year}    # #{files.size} Teams\n"

  files.each do |path|
      txt = read_text( path )

      txt = txt.sub( HEADER_RE ) do
                 m = Regexp.last_match
                 "== #{m[:country]}   \# #{m[:players]}\n"
             end

      buf += "\n"
      buf += txt
  end


   puts buf[0..200]

    write_text( "#{basedir}/squads.txt", buf )
end




basedir = '/sports/openfootball/worldcup'
cups = {
    1930 => '1930--uruguay',
    1934 => '1934--italy',
    1938 => '1938--france',
    1950 => '1950--brazil',
    1954 => '1954--switzerland',
    1958 => '1958--sweden',
    1962 => '1962--chile',
    1966 => '1966--england',
    1970 => '1970--mexico',
    1974 => '1974--west_germany',
    1978 => '1978--argentina',
    1982 => '1982--spain',
    1986 => '1986--mexico',
    1990 => '1990--italy',
    1994 => '1994--usa',
    1998 => '1998--france',
    2002 => '2002--south_korea-n-japan',
    2006 => '2006--germany',
    2010 => '2010--south_africa',
    2014 => '2014--brazil',
    2018 => '2018--russia',
    2022 => '2022--qatar',
    2026 => '2026--canada-usa-mexico',
}


cups.each do |year, dirname|
     merge( "#{basedir}/#{dirname}", year: year )
end


puts "bye"