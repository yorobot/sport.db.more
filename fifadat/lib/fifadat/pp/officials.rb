
=begin
  "Officials":
     [{"IdCountry": "URU",
       "OfficialId": "61038",
       "NameShort": [{"Locale": "en-GB", "Description": "Domingo LOMBARDI"}],
       "Name": [{"Locale": "en-GB", "Description": "Domingo LOMBARDI"}],
       "OfficialType": 1,
       "TypeLocalized": [{"Locale": "en-GB", "Description": "Referee"}]},
      {"IdCountry": "BEL",
       "OfficialId": "60664",
       "NameShort": [{"Locale": "en-GB", "Description": "Henry CRISTOPHE"}],
       "Name": [{"Locale": "en-GB", "Description": "Henry CRISTOPHE"}],
       "OfficialType": 2,
       "TypeLocalized":
        [{"Locale": "en-GB", "Description": "Assistant Referee 1"}]},
      {"IdCountry": "BRA",
       "OfficialId": "61289",
       "NameShort": [{"Locale": "en-GB", "Description": "Gilberto REGO"}],
       "Name": [{"Locale": "en-GB", "Description": "Gilberto REGO"}],
       "OfficialType": 3,
       "TypeLocalized":
        [{"Locale": "en-GB", "Description": "Assistant Referee 2"}]}],

=end


  TYPE_OFFICIAL = {
    1 => 'Referee',
    2 => 'Assistant Referee 1',
    3 => 'Assistant Referee 2',
  }

def build_official( h, id: )
    name = desc( h['Name'] )

    ## fix - use norm_official
    ## name = norm_official( name )

    idCountry = h['IdCountry']
    type      = h['OfficialType']


    assert( is_alpha?( name), "official name alpha expected; got #{name.inspect}" )
    assert( [1,2,3,4,5,6,7,8,9,10].include?( type ), "official type 1/2/3/4/5/6/7/8/9/10 expected; got #{type}" )

    rec = {}
    rec[:id] = h['OfficialId']   if id

    rec.merge!( name:      name,
                country:   idCountry,
                type:      type )

    rec
   end


def build_officials( recs, id: false )  ## use referees?
    recs = recs.map  { |h| build_official( h, id: id ) }

    ## skip fourth official (4) for now
    recs = recs.select { |h|  [1,2,3].include?( h[:type] ) }

    ## sort by type 1/2/3
    ##  1 - referee
    ##  2 - assistant referee 1
    ##  3 - assistant referee 2
    ##  4 - fourth official
    ##  5 - video assistant referee (var)
    ##  6 - reserve referee
    ##  7 - offside var
    ##  8 - assistant var
    ##  9 - support var
    ## 10 - reserve assistant referee


    recs = recs.sort { |l,r|  l[:type] <=> r[:type] }

    ## change type to literal string
    recs = recs.map { |h| h[:type]=TYPE_OFFICIAL[h[:type]]; h }

    recs
end
