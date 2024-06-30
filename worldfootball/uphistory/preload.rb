require_relative '../cache.weltfussball/lib/metal'


Webget.config.sleep = 3



def preload( slug )
  ## note: check if passed in slug is cached too (if not - preload / download too)
  url = Worldfootball::Metal.schedule_url( slug )
  Worldfootball::Metal.schedule( slug )   unless Webcache.cached?( url )

  page = Worldfootball::Page::Schedule.from_cache( slug )

  ## pp page.seasons

page.seasons.each_with_index do |rec,i|
   slug = rec[:ref]
   text = rec[:text]
   url = Worldfootball::Metal.schedule_url( slug )
   if Webcache.cached?( url )   ### check if page is cached
     print "   OK "
   else
     print "??    "
   end

   print " [%02d/%02d] " % [i+1, page.seasons.size]

   print "%-46s" % slug
   print " - "
   print text
   print "\n"

   ## download / preload in cache
   Worldfootball::Metal.schedule( slug )    unless Webcache.cached?( url )
end
end # method preload


SLUGS = [
=begin
  'aut-bundesliga-2020-2021',
  'aut-2-liga-2020-2021',
  'aut-oefb-cup-2020-2021',

  'bel-eerste-klasse-a-2020-2021',

  'ita-serie-a-2020-2021',

  'esp-primera-division-2020-2021',

  'jpn-j1-league-2020',

  'bra-serie-a-2020',

  'tur-sueperlig-2020-2021',

  'ukr-premyer-liga-2019-2020',

  'swe-allsvenskan-2020',

  'sui-super-league-2020-2021',

  'mex-primera-division-2020-2021-apertura',

  'ned-eredivisie-2020-2021',

  'lux-nationaldivision-2020-2021',

  'chn-super-league-2020',
=end
  'arg-primera-division-2019-2020',

  'champions-league-2020-2021',
  'europa-league-2020-2021',

  'usa-major-league-soccer-2020',
  'usa-usl-championship-2020',
  'usa-u-s-open-cup-2019',

  'copa-libertadores-2020',


  'concacaf-champions-league-2020',

  'mex-copa-mx-2019-2020',
  'mex-liga-de-expansion-2020-2021-apertura',
  'mex-premier-de-ascenso-2020-2021-grupo-b',

  'crc-primera-division-2020-2021-apertura',
  'slv-primera-division-2020-2021-apertura',

  'gua-liga-nacional-2020-2021-apertura',
  'hon-liga-nacional-2020-2021-apertura',

  'nca-liga-primera-2020-2021-apertura',

  'per-primera-division-2020-apertura',
  'chi-primera-division-2020',
  'uru-primera-division-2020-apertura',
  'col-primera-a-2020',
  'bol-liga-profesional-2020-apertura',
  'ecu-serie-a-2020',

  'egy-premiership-2019-2020',
]



SLUGS.each_with_index do |slug,i|
  puts "[#{i+1}/#{SLUGS.size}] >#{slug}<"
  preload( slug )
end


puts "bye"
