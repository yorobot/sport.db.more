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


   puts buf

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
}


cups.each do |year, dirname|
     merge( "#{basedir}/#{dirname}", year: year )
end


puts "bye"