require 'cocos'
require 'alphabets'   ## use unaccent


$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'webget/football'



## change/rename to convert_squads - why? why not?
def write_squads( league_urls, outdir: )

  league_urls.each_with_index do |league_url,i|
    league_relative_url = URI.parse( league_url ).request_uri

    puts "==> [#{i+1}/#{league_urls.size}]   #{league_relative_url} ..."

    league_page = Footballsquads::Page::League.get( league_url )
    league_title =  league_page.title
    pp league_title
    teams = league_page.teams
    # pp teams

    ## quick & dirty hack - use slug from first club for directory
    ##   for generate readme
    url = URI.parse( teams[0]['team_url'])
    pp url
    pp url.request_uri   ## without domain ??
  
    basedir = File.dirname( url.request_uri )
    pp basedir

    path = "#{outdir}#{basedir}/README.md"

    ## use squish??
    league_title = league_title.sub( 'FootballSquads - ', '' ).strip
    ## change: English Premier League - 2023/2024
    ##      to English Premier League 2023/2024
    league_title = league_title.sub( ' - ', ' ' ).strip
    puts "  => #{league_title}"

    buf = String.new
    buf << "# #{league_title}\n\n"

    buf << "#{teams.size} teams\n"

    teams.each do |team|
      team_url  = URI.parse( team['team_url'])
      team_name = team['team_name']

      basename = File.basename( team_url.request_uri, '.*' )
  
      buf << "- [#{team_name}](#{basename}.txt)\n"
    end

    write_text( path, buf )


    league_page.each_team do |team_page|
       team_title = team_page.title
       team_url   = URI.parse( team_page.url )

       
       team_title = team_title.sub( 'FootballSquads - ', '' ).strip
       pp team_title

       ## change to 
       #    Aston Villa - 2023/2024
       # to Aston Villa - English Premier League 2023/2024
       team_title = team_title.sub( / - .+$/, '' )
       team_title += " - #{league_title}"

       basename = File.basename( team_url.request_uri, '.*' )
       path = "#{outdir}#{basedir}/#{basename}.txt"

       buf = String.new
       buf << "=  #{team_title}\n\n"

 
       current, past =  team_page.players
    
       puts "current (#{current.size}):"
       # pp current
       puts "past (#{past.size}):"
       # pp past 


       ### todo/fix:
       ###  check for comma in values - quote if needed (",") !!!!

       if current.size > 0
         headers = current[0].keys
         # pp headers
         # pp current[0]
         buf << headers.join( ', ')
         buf << "\n"
         current.each do |rec|
             buf << rec.values.join( ', ' )
             buf << "\n"
         end
       end

       if past.size > 0
          buf << "\n"
          buf << "== Past Players\n\n"
          headers = past[0].keys
          # pp headers
          # pp past[0]
          buf << headers.join( ', ')
          buf << "\n"
          past.each do |rec|
              buf << rec.values.join( ', ' )
              buf << "\n"
          end 
       end

       write_text( path, buf )
    end 
  end
end


