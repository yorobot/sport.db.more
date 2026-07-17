=begin
 "Substitutions":
    [{"IdEvent": null,
      "Period": 5,
      "Reason": 2,
      "SubstitutePosition": 2,
      "IdPlayerOff": "448148",
      "IdPlayerOn": "395318",
      "PlayerOffName":
       [{"Locale": "en-GB", "Description": "Jeremie FRIMPONG"}],
      "PlayerOnName": [{"Locale": "en-GB", "Description": "Wataru ENDO"}],
      "Minute": "60'",
      "IdTeam": "1896634"},

  "Period"=>??,
  "SubstitutePosition"=>2,
  "IdPlayerOff"=>"403319",
  "IdPlayerOn"=>"436537",
  "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"NASSER ALDAWSARI"}],
  "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"MUSAB ALJUWAYR"}],
   "Minute"=>"",      ## note - empty string!!
   "IdTeam"=>"1943992"}
 ---
  "Period"=>17,
   "SubstitutePosition"=>2,
   "IdPlayerOff"=>"473062",
   "IdPlayerOn"=>"418961",
   "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Emiliano MARTINEZ"}],
   "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Anibal MORENO"}],
    "Minute"=>"",     ## note - empty string!!
   "IdTeam"=>"1884426"}
=end



def _build_sub_minute( h )

    ## split into minute
    ##  and offset (stoppage/injury/added time)
    ##  e.g. 90'+11'

     minute_str = h['Minute']

     ##
     ## check what is "Period"=>4
     ##   minute is "" empty!!

          if minute_str.nil? || minute_str.empty?
            if h['Period'] == 4  ## quick fix - use 46' half-time sub??
                minute_str = "46'"
            elsif h['Period'] == 8 ## quick fix - use 116' 1st half-time extra time?
                minute_str = "116'"
            elsif h['Period'] == 17  ## quick fix- what is period 17 beyond pens??
                minute_str = "121'"
            else
              puts "!! minute in sub is nil or empty:"
              pp h
              exit 1
            end
          end

     ##  _fmt_minute( *_parse_minute( minute_str ))

     minute, offset  = _parse_minute( minute_str )

     Minute.new( m:      minute,
                 offset: offset,
                 period: h['Period'] )
end



def build_sub( h, players: )

      minute = _build_sub_minute( h )

      playerOff = players.find!( h['IdPlayerOff'] )
      playerOn  = players.find!( h['IdPlayerOn'] )

      rec = { off:     playerOff[ :name ],
              on:      playerOn[ :name ],
              minute:  minute
            }

      rec
end



def build_subs( recs, players: )
    recs = recs.map  { |h| build_sub( h, players: players ) }
    recs
end


__END__

! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>3,
 "IdPlayerOff"=>"418747",
 "IdPlayerOn"=>"411174",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Tomas RODRIGUEZ"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Jose FAJARDO"}],
 "Minute"=>"",
 "IdTeam"=>"43914"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>1,
 "IdPlayerOff"=>"494351",
 "IdPlayerOn"=>"511022",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Jonas ADJETEY"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Kojo Peprah OPPONG"}],
 "Minute"=>"",
 "IdTeam"=>"43860"}

 !! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>2,
 "IdPlayerOff"=>"441341",
 "IdPlayerOn"=>"441342",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Elisha OWUSU"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Abdul FATAWU"}],
 "Minute"=>"",
 "IdTeam"=>"43860"}

 !! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>2,
 "IdPlayerOff"=>"395216",
 "IdPlayerOn"=>"484141",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"RUBEN NEVES"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"JOAO NEVES"}],
 "Minute"=>"",
 "IdTeam"=>"43963"}

 !! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>1,
 "IdPlayerOff"=>"368649",
 "IdPlayerOn"=>"403002",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"JOAO CANCELO"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"DIOGO DALOT"}],
 "Minute"=>"",
 "IdTeam"=>"43963"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>3,
 "IdPlayerOff"=>"299200",
 "IdPlayerOn"=>"401131",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Marko ARNAUTOVIC"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Michael Gregoritsch"}],
 "Minute"=>"",
 "IdTeam"=>"43934"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>2,
 "IdPlayerOff"=>"463283",
 "IdPlayerOn"=>"520036",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Romano SCHMID"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Paul WANNER"}],
 "Minute"=>"",
 "IdTeam"=>"43934"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>2,
 "IdPlayerOff"=>"385531",
 "IdPlayerOn"=>"385248",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Xaver Schlager"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Florian GRILLITSCH"}],
 "Minute"=>"",
 "IdTeam"=>"43934"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>3,
 "IdPlayerOff"=>"511875",
 "IdPlayerOn"=>"396950",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"ODEH FAKHOURY"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"MAHMOUD ALMARDI"}],
 "Minute"=>"",
 "IdTeam"=>"43820"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>3,
 "IdPlayerOff"=>"498514",
 "IdPlayerOn"=>"431211",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"ALI AZAIZEH"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"MOUSA ALTAMARI"}],
 "Minute"=>"",
 "IdTeam"=>"43820"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>3,
 "IdPlayerOff"=>"486161",
 "IdPlayerOn"=>"494248",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Relebohile MOFOKENG"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Thalente MBATHA"}],
 "Minute"=>"",
 "IdTeam"=>"43883"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>2,
 "IdPlayerOff"=>"411726",
 "IdPlayerOn"=>"463746",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"LUCAS PAQUETA"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"ENDRICK"}],
 "Minute"=>"",
 "IdTeam"=>"43924"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>2,
 "IdPlayerOff"=>"492363",
 "IdPlayerOn"=>"379953",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Felix NMECHA"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Leon GORETZKA"}],
 "Minute"=>"",
 "IdTeam"=>"43948"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>17,
 "Reason"=>0,
 "SubstitutePosition"=>2,
 "IdPlayerOff"=>"369761",
 "IdPlayerOn"=>"486875",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Miguel ALMIRON"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Gustavo VELAZQUEZ"}],
 "Minute"=>"",
 "IdTeam"=>"43928"}

 !! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>2,
 "IdPlayerOff"=>"389784",
 "IdPlayerOn"=>"463489",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Alan FRANCO"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Yaimar MEDINA"}],
 "Minute"=>"",
 "IdTeam"=>"43927"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>1,
 "IdPlayerOff"=>"463465",
 "IdPlayerOn"=>"402974",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Joel ORDONEZ"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Angelo PRECIADO"}],
 "Minute"=>"",
 "IdTeam"=>"43927"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>3,
 "IdPlayerOff"=>"448362",
 "IdPlayerOn"=>"358112",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Charles DE KETELAERE"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Romelu LUKAKU"}],
 "Minute"=>"",
 "IdTeam"=>"43935"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>2,
 "IdPlayerOff"=>"385531",
 "IdPlayerOn"=>"385248",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Xaver Schlager"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Florian GRILLITSCH"}],
 "Minute"=>"",
 "IdTeam"=>"43934"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>2,
 "IdPlayerOff"=>"441088",
 "IdPlayerOn"=>"463800",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Nicolas SEIWALD"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Carney CHUKWUEMEKA"}],
 "Minute"=>"",
 "IdTeam"=>"43934"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>3,
 "IdPlayerOff"=>"430070",
 "IdPlayerOn"=>"485068",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Ante BUDIMIR"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Igor MATANOVIC"}],
 "Minute"=>"",
 "IdTeam"=>"43938"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>1,
 "IdPlayerOff"=>"423522",
 "IdPlayerOn"=>"494411",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Jordan BOS"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Kai TREWIN"}],
 "Minute"=>"",
 "IdTeam"=>"43976"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>17,
 "Reason"=>0,
 "SubstitutePosition"=>2,
 "IdPlayerOff"=>"430452",
 "IdPlayerOn"=>"406606",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Connor METCALFE"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Awer MABIL"}],
 "Minute"=>"",
 "IdTeam"=>"43976"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>17,
 "Reason"=>0,
 "SubstitutePosition"=>2,
 "IdPlayerOff"=>"430440",
 "IdPlayerOn"=>"498421",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Aiden ONEILL"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Paul OKON-ENGSTLER"}],
 "Minute"=>"",
 "IdTeam"=>"43976"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>8,
 "Reason"=>0,
 "SubstitutePosition"=>3,
 "IdPlayerOff"=>"430476",
 "IdPlayerOn"=>"495488",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"OMAR MARMOUSH"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"HAMZA ABDELKARIM"}],
 "Minute"=>"",
 "IdTeam"=>"43855"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>2,
 "IdPlayerOff"=>"269058",
 "IdPlayerOn"=>"473050",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"James RODRIGUEZ"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Richard RIOS"}],
 "Minute"=>"",
 "IdTeam"=>"43926"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>3,
 "IdPlayerOff"=>"483448",
 "IdPlayerOn"=>"494626",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Antonio NUSA"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Andreas SCHJELDERUP"}],
 "Minute"=>"",
 "IdTeam"=>"43961"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>3,
 "IdPlayerOff"=>"398588",
 "IdPlayerOn"=>"477470",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Alexander SORLOTH"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Oscar BOBB"}],
 "Minute"=>"",
 "IdTeam"=>"43961"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>1,
 "IdPlayerOff"=>"395516",
 "IdPlayerOn"=>"400634",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Cesar MONTES"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Edson ALVAREZ"}],
 "Minute"=>"",
 "IdTeam"=>"43911"}

!! minute in sub is nil or empty:
{"IdEvent"=>nil,
 "Period"=>4,
 "Reason"=>0,
 "SubstitutePosition"=>1,
 "IdPlayerOff"=>"406280",
 "IdPlayerOn"=>"419068",
 "PlayerOffName"=>[{"Locale"=>"en-GB", "Description"=>"Sergino DEST"}],
 "PlayerOnName"=>[{"Locale"=>"en-GB", "Description"=>"Giovanni REYNA"}],
 "Minute"=>"",
 "IdTeam"=>"43921"}