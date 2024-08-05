######
## export teams slugs in json
##   from league page
##
##   $ ruby sandbox/export.rb


##
## retry later ??

##  am -  Armenian Premier League 2024/25
##   only 10 clubs with 5 matches so far (something missing?)





$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
require 'webget'

Webcache.root = '/sports/cache'


require 'cocos'
## 3rd party
require 'nokogiri'


require_relative 'leagues'



BASE_URL = 'https://www.uefa.com/nationalassociations'



LEAGUES.each do |league, path|
    ## note - add trailing slash (/) to avoid (301) redirects!!!
    url = "#{BASE_URL}/#{path}/"

    html = Webcache.read( url )
    pp html[0,300]

## note: if we use a fragment and NOT a document -
##   no access to  page head (and meta elements and such)

doc =  Nokogiri::HTML( html )


puts
title =  doc.css( 'title' ).first.text
pp title

## get all script sections
###  type="application/ld+json"

els = doc.css( %Q{script[type*="ld+json"]} )

puts "  #{els.size} script(s) found"

## collect teams
teams = {}

els.each_with_index do |el,i|
   data = JSON.parse( el.text )
   puts "==> #{i+1}"
   ## pp data

   if data['@type'] == 'WebPage'
      ## skip; do nothing
   elsif data['@type'] == 'SportsEvent'
       name   = data['name']
       status = data['eventStatus']
       date   = data['startDate']   # e.g. "2025-03-15T00:00:00+00:00",

       print "%-40s" % name
       print "  #{status}  #{date}"
       print "\n"

      [data['awayTeam'],
       data['homeTeam']
      ].each do |team|
           if team['@type'] == 'SportsTeam'

                name = team['name']
                ref  = team['sameAs']
                ## e.g. https://www.uefa.com/nationalassociations/teams/64277--aberystwyth/
                ##  strip leading and trailing stuff
                ref  = ref.sub( %r{^https://www.uefa.com/nationalassociations/teams/}, '')
                ref  = ref.sub( %r{/$}, '' )

               rec = teams[ team['name']] ||= { name: name,
                                                ref:  ref,
                                                count: 0}
               rec[:count] += 1
           else
              puts "!! ASSERT - SportsTeam expected; got:"
              pp team
              exit 1
           end

      end
   else
     puts "!! ASSERT - SportsTeam|WebPage expected; got:"
     pp data
     exit 1
   end
end


puts
puts "#{teams.size} team(s):"
pp teams.values


##
## todo/check - add season (via page title) to outpath - why? why not?
outpath = "./slugs.teams/#{league}.json"


title = title.sub( ' | National associations | UEFA.com', '' )

data = {
         title: title,
         club_count: teams.size,
         clubs:      teams.values
       }
write_json( outpath, data )

end


puts "bye"