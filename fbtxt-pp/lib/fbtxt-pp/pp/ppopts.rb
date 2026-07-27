


##
## opt_country: true|false   -- add country code for clubs
## opt_stadium: false|true   -- print only city (NOT long stadium+city)


  ## use OptsFormat or OptsPP or such - why? why not?

##  change format to opts for entities (time/team/etc.) - why? why not?
##  use    - time:                   timezone
##         - venue/ground/stadium:   city|stadium
##         - team:                   country

class FormatOpts

   def self.build_min( **kwargs )
      new( **{ city:     false,
               stadium:  false,
               timezone: false,
               country:  false,
             }.merge( kwargs ))
   end

   def self.build( **kwargs )
      new( **{ city:     true,
               stadium:  true,
               timezone: true,
               country:  false,
             }.merge( kwargs ))
   end

   def self.build_full( **kwargs )
      new( **{ city:     true,
               stadium:  true,
               timezone: true,
               country:  false,
             }.merge( kwargs))
   end


   def initialize( city:,
                   stadium:,
                   timezone:,
                   country:,
                   ####
                   ## (stats) headers
                   ##    use list_stadiums or such - why? why not?
                   show_stadiums: false,
                   show_teams:    false,
                   show_stages:   false
                   )
       @city     = city
       @stadium  = stadium
       ## incl. timezone to time
       @timezone = timezone
       ## incl. country code in team name?
       @country  = country

       ## stats header
       ##   print/list teams
       @show_teams     = show_teams
       @show_stadiums  = show_stadiums
       @show_stages    = show_stages
   end

   def city?()     @city; end
   def stadium?()  @stadium; end
   def timezone?() @timezone; end
   def country?()  @country; end

   def show_teams?()     @show_teams;  end
   def show_stadiums?()  @show_stadiums;  end
   def show_stages?()    @show_stages;  end
end  # class FormatOpts
