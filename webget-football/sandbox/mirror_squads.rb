require 'cocos'
require 'alphabets'   ## use unaccent


$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'webget/football'


Webcache.root = '../../../cache'  ### c:\sports\cache




# outdir = "./tmp/cache.footballsquads"

outdir = "../../../footballcsv/cache.footballsquads"



DATASETS = [
  ['eng.1',   %w[2023/24 2022/23 2021/22 2020/21
                 2019/20 2018/19 2017/18 2016/17 2015/16 2014/15]],
  ['eng.2',   %w[2023/24 2022/23 2021/22 2020/21]],
  ['eng.3',   %w[2023/24 2022/23 2021/22 2020/21]],

  ['es.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['es.2',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['de.1',    %w[2023/24 2022/23 2021/22 2020/21
                 2019/20 2018/19 2017/18 2016/17 2015/16 2014/15]],
  ['de.2',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['sco.1',  %w[2023/24 2022/23 2021/22 2020/21]], 

  ['it.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['it.2',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['fr.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['fr.2',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['pt.1',   %w[2023/24 2022/23 2021/22 2020/21]],

  ['nl.1',   %w[2023/24 2022/23 2021/22 2020/21]],
  ['be.1',   %w[2023/24 2022/23 2021/22 2020/21]],

  ['tr.1',  %w[2023/24 2022/23 2021/22 2020/21]],
  ['gr.1',  %w[2023/24 2022/23 2021/22 2020/21]],

  ['ru.1',  %w[2023/24 2022/23 2021/22 2020/21]],
  ['ua.1', %w[2023/24 2022/23 2021/22 2020/21]],
  ['pl.1',  %w[2023/24 2022/23 2021/22 2020/21]],

  ['dk.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['at.1',    %w[2023/24 2022/23 2021/22 2020/21
                 2019/20 2018/19 2017/18 2016/17 2015/16 2014/15]],
  ['ch.1',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['cz.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['hr.1',    %w[2023/24 2022/23]],
  ['hu.1',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['no.1',    %w[2024 2023 2022 2021]],
  ['se.1',    %w[2024 2023 2022 2021]],

  ['ie.1',    %w[2024 2023 2022 2021]],

  ## add overseas leagues
#  ['br.1',  %w[2024]],
#  ['ar.1',  %w[2024]], 

  ['world',  %w[2022 2018 2014 2010]],
  ['euro',   %w[2020 2016 2012]],
]




DATASETS.each do |league, seasons|
  seasons.each do |season|

    league_page = Footballsquads.league( league: league, 
                                         season: season )
    league_title =  league_page.title
    pp league_title
    teams = league_page.teams
    pp teams

   ## quick & dirty hack - use slug from first club for directory
   ##   for generate readme
   url = URI.parse( teams[0]['team_url'])
   pp url
   pp url.request_uri   ## without domain ??
  
   basedir = File.dirname( url.request_uri )
   pp basedir

   path = "#{outdir}#{basedir}/README.md"

  ## use sqhish??
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
         pp headers
         pp current[0]
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
          pp headers
          pp past[0]
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


puts "bye"


