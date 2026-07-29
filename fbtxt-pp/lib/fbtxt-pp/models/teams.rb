



TEAM_MODS = {
   ## nati(onal) teams (e.g. world cup)
   ##  map "offical" country names to common country names
   'Germany FR'          => 'West Germany',
   'German DR'           => 'East Germany',
   'Korea Republic'      => 'South Korea',
   'Korea DPR'           => 'North Korea',
   'China PR'            => 'China',
   'Republic of Ireland' => 'Ireland',
   'IR Iran'             => 'Iran',
   'United States'       => 'USA',
   'Czechia'             => 'Czech Republic',
   'Türkiye'             => 'Turkey',
   ##  Côte d'Ivoire  [fr]  => Ivory Coast   ???

   ## austria (at)
   ##   remove cut-out (commerical) sponsor names
   'RZ Pellets WAC'       => 'Wolfsberger AC',  ## WAC
   'CASHPOINT SCR Altach' => 'SCR Altach',
   'SV Guntamatic Ried'   => 'SV Ried',
}


class Team
   def self.build( h )
       ## pp h
       new( id:      h['id'],
            name:    h['name'],
            code:    h['code'],
            country: h['country'] )
   end


   attr_reader :id,
               :name,
               :alt_names,
               :code, :country
   ## attr_accessor :count       ## read/write - let's you update (match) count

   def initialize( name:,
                   code:,
                   country:,
                   id: nil)
      @alt_names = []

      norm = norm_name( name )
      if norm != name
        puts "  NORM TEAM NAME  >#{name}<  =>  >#{norm}<"
        @alt_names << name
        name = norm
      end

      ## check for mods/canonical  name
      mod = TEAM_MODS[ name ]
      if mod
         puts "   MOD TEAM NAME  >#{name}<  =>  >#{mod}<"
         @alt_names << name
         name = mod
      end

      @name  = name

      @code    = code
      @country = country

      @id  = id

      ## @count = 0
   end



   ## get lookup keys (id+name+alt_names)
   def keys
      keys = []
      keys << @id                if @id
      keys << slugify(@name)
      keys += @alt_names.map {|name| slugify(name)}   unless @alt_names.empty?

      ##  note - make sure keys are unique
      keys.uniq
   end


   def dummy?()   @name == 'N.N.'; end
   alias_method :unknown?, :dummy?

   DUMMY = build(  { 'name'    => 'N.N.',
                     'code'    => 'UNK',
                     'country' => 'UNK', } )
end   # class Team





class Teams
   def initialize
      @recs   = []
      @lookup = {}
   end

   def add( recs )
      recs.each do |rec|
        _add( Team.build( rec ) )
      end
   end

   def _add( new_rec )
      @recs << new_rec

      new_rec.keys.each do |key|
         rec  =  @lookup[ key ]
         if rec.nil?
            @lookup[ key ] = new_rec
         else
           raise ArgumentError,
             "duplicate team records  #{rec.pretty_inspect} == #{new_rec.pretty_inspect}"
         end
      end
   end


   ## note - search by   id, name or alt_names !!
   def find!( q )
      if q == '?'    ## return dummy
        rec = Team::DUMMY
      else
        key = slugify( q )
        rec =  @lookup[ key ]
        if rec.nil?
           raise ArgumentError, "no team found for q(uery) >#{q}< using key >#{key}<"
        end
        rec
      end
   end


=begin
   def recs( sort: true  )
      recs = @recs.values
      if sort
        recs = recs.sort do |l,r|
                res = r[:count] <=> l[:count]
                res = l[:name] <=> r[:name]  if res == 0
                res
             end
      end
      recs
   end
=end


   def each( &blk ) @recs.each( &blk ); end
   def size()       @recs.size; end

end  # class Teams
