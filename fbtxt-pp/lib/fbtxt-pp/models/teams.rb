

def slugify( str )
   str.downcase.gsub( /[^a-z0-9]/, '' )
end



class Team
   def self.build( h )
       ## pp h
       new( id:      h['id'],
            name:    h['name'],
            code:    h['code'],
            country: h['country'] )
   end


   attr_reader :id,
               :name, :code, :country
   ## attr_accessor :count       ## read/write - let's you update (match) count

   def initialize( name:,
                   code:,
                   country:,
                   id: nil)
      @name    = name
      ## name = norm_team( name )

      @code    = code
      @country = country

      if id.nil?
         id = slugify( name )
      end

      @id  = id

      ## @count = 0
   end


   def dummy?()   @name == 'N.N.'; end
   alias_method :unknown?, :dummy?

   DUMMY = build(  { 'name'    => 'N.N.',
                     'code'    => 'UNK',
                     'country' => 'UNK', } )
end   # class Team





class Teams
   def initialize
      @recs = {}
   end

   def add( recs )
      recs.each do |rec|
        _add( Team.build( rec ) )
      end
   end


   def find_by!( name: )
      if name == '?'    ## return dummy
        rec = Team::DUMMY
      else
        id = slugify( name )
        rec =  @recs[ id ]
        raise ArgumentError, "no team found for name >#{name}< using id >#{id}<"  if rec.nil?
        rec
      end
   end



   def _add( new_rec )
      rec  =  @recs[ new_rec.id ]
      if rec.nil?
          rec = new_rec
          @recs[ new_rec.id ] = new_rec
      else
         raise ArgumentError,
            "duplicate team records  #{rec.pretty_inspect} == #{new_rec.pretty_inspect}"
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


   def each( &blk ) @recs.values.each( &blk ); end



   def size() @recs.size; end

end  # class Teams
