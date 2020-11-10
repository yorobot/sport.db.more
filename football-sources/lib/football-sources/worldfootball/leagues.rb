

require_relative 'leagues/europe'
require_relative 'leagues/north_america'
require_relative 'leagues/south_america'
require_relative 'leagues/pacific'
require_relative 'leagues/asia'


module Worldfootball

LEAGUES = [LEAGUES_EUROPE,
           LEAGUES_NORTH_AMERICA,
           LEAGUES_SOUTH_AMERICA,
           LEAGUES_PACIFIC,
           LEAGUES_ASIA].reduce({}) { |mem,h| mem.merge!( h ); mem }


class League
    def initialize( key, data )
      @key  = key
      ## @data = data

      @pages       = data[:pages]
      @season_proc = data[:season] || ->(season) { nil }
    end

    def key()   @key; end

    def pages( season: )
      ## note: return for no stages / simple case - just a string
      ##   and for the stages case ALWAYS an array (even if it has only one page (with stage))

      if @pages.is_a?( String )
        # assume always "simple/regular" format w/o stages
        slug = @pages
        { slug: fill_slug( slug, season: season ) }
      else
         ## check for league format / stages
         ##   return array (of strings) or nil (for no stages - "simple" format)
         indices = @season_proc.call( season )
         if indices.nil?
           puts "!! ERROR - no configuration found for season >#{season}< for league >#{@key}< found; sorry"
           exit 1
         elsif indices.is_a?( Integer )  ## single number - single/regular format w/o stage
          # note: starting with 0 (always use idx-1) !!!
           slug = if @pages.is_a?( Array )
                    @pages[indices-1]
                  else ## assume hash (and key is page slug)
                    @pages.keys[indices-1]
                  end
           { slug: fill_slug( slug, season: season ) }
         else  ## assume regular case - array of integers
           recs = []
           indices.each do |idx|
              slug = key = @pages.keys[idx-1]
              recs << { slug:  fill_slug( slug, season: season ),
                        stage: @pages[key] }  ## note: include mapping for page to stage name!!
           end
           recs
        end
      end
    end # pages


    ######
    # helper method
    def fill_slug( slug, season: )
      ## note: fill-in/check for place holders too
      slug = if slug.index( '{season}' )
               slug.sub( '{season}', season.to_path( :long ) )  ## e.g. 2010-2011
             elsif slug.index( '{end_year}' )
               slug.sub( '{end_year}', season.end_year.to_s )   ## e.g. 2011
             else
               ## assume convenience fallback - append regular season
               "#{slug}-#{season.to_path( :long )}"
            end

      puts "  slug=>#{slug}<"

      slug
    end
  end # class League



  def self.find_league( key )  ## league info lookup
    data = LEAGUES[ key ]
    if data.nil?
      puts "!! ERROR - no league found for >#{key}<; add to leagues tables"
      exit 1
    end
    League.new( key, data )   ## use a convenience wrapper for now
  end



### "reverse" lookup by page - returns league AND season
##  note: "blind" season template para - might be season or start_year etc.
##   e.g.  {season} or {start_year} becomes {}

PAGE_VAR_RE = /{
                [^}]+
               }/x


def self.norm_slug( slug )
    ## assume convenience fallback - append regular season
    slug.index( '{' ) ? slug : "#{slug}-{season}"
end

PAGES ||=
 LEAGUES.reduce( {} ) do |pages, (key, data)|
                                     if data[:pages].is_a?( String )
                                       slug = data[:pages]
                                       slug = Worldfootball.norm_slug( slug )
                                       pages[ slug.sub( PAGE_VAR_RE, '{}') ] = { league: key, slug: slug }
                                     elsif data[:pages].is_a?( Array )
                                       data[:pages].each do |slug|
                                        slug = Worldfootball.norm_slug( slug )
                                         pages[ slug.sub( PAGE_VAR_RE, '{}') ] = { league: key, slug: slug }
                                       end
                                        ## elsif data[:pages].nil?
                                        ## todo/fix: missing pages!!!
                                     else ## assume hash
                                      ## add stage to pages too - why? why not?
                                       data[:pages].each do |slug, stage|
                                         slug = Worldfootball.norm_slug( slug )
                                         pages[ slug.sub( PAGE_VAR_RE, '{}') ] = { league: key, slug: slug, stage: stage }
                                       end
                                     end
                                     pages
                                    end

# e.g. 2000 or 2000-2001
SEASON_RE = /[0-9]{4}
              (?:
                -[0-9]{4}
              )?
            /x


  def self.find_page!( slug )
    page = find_page( slug )
    if page.nil?
      puts "!! ERROR: no mapping for page >#{slug}< found; sorry"

      season_str = nil
      norm = slug.sub( SEASON_RE ) do |match|  ## replace season with var placeholder {}
                season_str = match   ## keep reference to season str
                '{}'  ## replace with {}
              end

      puts "   season:      >#{season_str}<"
      puts "   slug (norm): >#{norm}<"
      puts
      ## pp PAGES
      exit 1
    end
    page
  end



  def self.find_page( slug )
    ## return league key and season
    season_str = nil
    norm = slug.sub( SEASON_RE ) do |match|  ## replace season with var placeholder {}
              season_str = match   ## keep reference to season str
              '{}'  ## replace with {}
            end

    if season_str.nil?
      puts "!! ERROR: no season found in page slug >#{slug}<; sorry"
      exit 1
    end

    rec = PAGES[ norm ]
    return nil  if rec.nil?


    league_key = rec[:league]
    slug_tmpl  = rec[:slug]
    season = if slug_tmpl.index( '{start_year}' )
               ## todo/check - season_str must be year (e.g. 2020 or such and NOT 2020-2021)
               Season( "#{season_str.to_i}-#{season_str.to_i+1}" )
             elsif slug_tmpl.index( '{end_year}' )
               ## todo/check - season_str must be year (e.g. 2020 or such and NOT 2020-2021)
               Season( "#{season_str.to_i-1}-#{season_str.to_i}" )
             else  ## assume "regular" seasson - pass through as is
               Season( season_str )
             end

    ## return hash table / record
    { league: league_key,
      season: season.key }
  end


end # module Worldfootball
