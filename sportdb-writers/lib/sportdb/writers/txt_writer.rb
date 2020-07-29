module SportDb
class TxtMatchWriter


DE_WEEKDAY = {
  1 => 'Mo',  ## Montag
  2 => 'Di',  ## Dienstag
  3 => 'Mi',  ## Mittwoch
  4 => 'Do',  ## Donnerstag
  5 => 'Fr',  ## Freitag
  6 => 'Sa',  ## Samstag
  7 => 'So',  ## Sonntag
}

##
# https://en.wikipedia.org/wiki/Date_and_time_notation_in_Spain
ES_WEEKDAY = {
  1 => 'Lun',   ## lunes   ## todo: fix!! was Lue - why?
  2 => 'Mar',   ## martes
  3 => 'Mié',   ## miércoles
  4 => 'Jue',   ## jueves
  5 => 'Vie',   ## viernes
  6 => 'Sáb',   ## sábado    ## todo: fix!! was Sab - why?
  7 => 'Dom',   ## domingo
}


PT_WEEKDAY = {
  1 => 'Seg',
  2 => 'Ter',
  3 => 'Qua',
  4 => 'Qui',
  5 => 'Sex',
  6 => 'Sáb',
  7 => 'Dom',
}

PT_MONTH = {
   1 => 'Jan',
   2 => 'Fev',
   3 => 'Março',
   4 => 'Abril',
   5 => 'Maio',
   6 => 'Junho',
   7 => 'Julho',
   8 => 'Agosto',
   9 => 'Set',
  10 => 'Out',
  11 => 'Nov',
  12 => 'Dez',
}

##
# https://en.wikipedia.org/wiki/Date_and_time_notation_in_Italy
IT_WEEKDAY = {
  1 => 'Lun',   ## Lunedì
  2 => 'Mar',   ## Martedì
  3 => 'Mer',   ## Mercoledì
  4 => 'Gio',   ## Giovedì
  5 => 'Ven',   ## Venerdì
  6 => 'Sab',   ## Sabato
  7 => 'Dom',   ## Domenica
}

FR_WEEKDAY = {
  1 => 'Lun',
  2 => 'Mar ',
  3 => 'Mer',
  4 => 'Jeu',
  5 => 'Ven',
  6 => 'Sam',
  7 => 'Dim',
}

FR_MONTH = {
  1  => 'Jan',
  2  => 'Fév',
  3  => 'Mars',
  4  => 'Avril',
  5  => 'Mai',
  6  => 'Juin',
  7  => 'Juil',
  8  => 'Août',
  9  => 'Sept',
  10 => 'Oct',
  11 => 'Nov',
  12 => 'Déc',
}


EN_WEEKDAY = {
  1 => 'Mon',
  2 => 'Tue',
  3 => 'Wed',
  4 => 'Thu',
  5 => 'Fri',
  6 => 'Sat',
  7 => 'Sun',
}



DATES =
{
  ## english (en) -- e.g. Mon Aug/11
  'en' => ->(date) { buf = String.new('')
                     buf << EN_WEEKDAY[date.cwday]
                     buf << ' '
                     buf << date.strftime( '%b/%-d' )
                     buf
                   },
  ## portuguese (pt)  -- e.g. Sáb, 13/Maio  or Sáb 13 Maio
  'pt' => ->(date) { buf = String.new('')
                     buf << PT_WEEKDAY[date.cwday]
                     buf << ", #{date.day}/"
                     buf << PT_MONTH[date.month]
                     buf
                   },
  ## german / deutsch (de) -- e.g. Mo 11.8.
  'de' => ->(date) { buf = String.new('')
                     buf << DE_WEEKDAY[date.cwday]
                     buf << ' '
                     buf << date.strftime( '%-d.%-m.' )
                     buf
                   },
  ## italian / italiano (it) -- e.g. Lun. 11.8.
  'it' => ->(date) { buf = String.new('')
                     buf << IT_WEEKDAY[date.cwday]
                     buf << '. '
                     buf << date.strftime( '%-d.%-m.' )
                     buf
                   },
  ## spanish / espanol (es) -- e.g. Lun. 11.8.
  'es' => ->(date) { buf = String.new('')
                     buf << ES_WEEKDAY[date.cwday]
                     buf << '. '
                     buf << date.strftime( '%-d.%-m.' )
                     buf
                   },
  ## french / francais (fr)
  'fr' => ->( date ) { buf = String.new('')
                       buf << FR_WEEKDAY[date.cwday]
                       buf << " #{date.day}. "
                       buf << FR_MONTH[date.month]
                       buf
                      },
}

SCORES =
{
  'en' => -> (match) { buf = String.new('')
                         ## note: also allow (minimal) scores only with a.e.t. (and no full time)
                         if (match.score1   && match.score2) ||
                            (match.score1et && match.score2et )
                           if match.score1p && match.score2p
                             buf << "#{match.score1p}-#{match.score2p} pen."
                           end
                           if match.score1et && match.score2et
                             buf << " #{match.score1et}-#{match.score2et} a.e.t."
                           end
                          if match.score1 && match.score2
                            if buf.empty?
                              buf << " #{match.score1}-#{match.score2}"
                            else  ## assume pen. and/or a.e.t.
                              buf << " (#{match.score1}-#{match.score2})"
                            end
                          end
                       else # assume empty / unknown score
                        buf << '-'
                       end
                       buf
                      },
  'de' => ->( match ) { buf = String.new('')
                        ## note: also allow (minimal) scores only with a.e.t. (and no full time)
                        if (match.score1   && match.score2) ||
                           (match.score1et && match.score2et )
                         # 2-2 (1-1) n.V. 5-1 i.E.
                         if match.score1et && match.score2et
                           buf << "#{match.score1et}:#{match.score2et}"
                         end
                         if match.score1 && match.score2
                           if buf.empty?
                             buf << " #{match.score1}:#{match.score2}"
                           else  ## assume pen. and/or a.e.t.
                             buf << " (#{match.score1}:#{match.score2})"
                           end
                         end
                         if match.score1et && match.score2et
                           buf << " n.V."
                         end
                         if match.score1p && match.score2p
                           buf << " #{match.score1p}:#{match.score2p} i.E."
                         end
                        else # assume empty / unknown score
                          buf << '-'
                        end
                        buf
                      },
}


LANGS =
{
  'en'     => { round: 'Matchday',                           date: DATES['en'], score: SCORES['en'] },
  'en_AU'  => { round: 'Round',                              date: DATES['en'], score: SCORES['en'] },
  'pt'     => { round: 'Jornada',                            date: DATES['pt'], score: SCORES['en'] },
  'pt_BR'  => { round: 'Rodada',                             date: DATES['pt'], score: SCORES['en'] },
  'it'     => { round: ->(round) { "%s^ Giornata" % round }, date: DATES['it'], score: SCORES['en'] },
  'fr'     => { round: 'Journée',                            date: DATES['fr'], score: SCORES['en'] },
  'es'     => { round: 'Jornada',                            date: DATES['es'], score: SCORES['en'] },
  'de'     => { round: 'Spieltag',                           date: DATES['de'], score: SCORES['de'] },
  'de_AT'  => { round: ->(round) { "%s. Runde" % round },    date: DATES['de'], score: SCORES['de'] },
}

## add 1:1 (more) convenience aliases
LANGS[ 'de_DE' ] = LANGS[ 'de']
LANGS[ 'de_CH' ] = LANGS[ 'de']
LANGS[ 'pt_PT' ] = LANGS[ 'pt']
LANGS[ 'es_AR' ] = LANGS[ 'es']




## note: build returns buf - an (in-memory) string buf(fer)
def self.build( matches, lang: 'en', rounds: true )
  ## note: make sure rounds is a bool, that is, true or false  (do NOT pass in strings etc.)
  raise ArgumentError, "rounds flag - bool expected; got: #{rounds.inspect}"    unless rounds.is_a?( TrueClass ) || rounds.is_a?( FalseClass )


  defaults = LANGS[ lang ] || LANGS[ 'en' ]   ## note: fallback for now to english if no defaults defined for lang

  round        = defaults[ :round ]
  format_date  = defaults[ :date ]
  format_score = defaults[ :score ]


  buf = String.new('')

  last_round = nil
  last_date  = nil


  matches.each do |match|

     ## note: make rounds optional (set rounds flag to false to turn off)
     if rounds
       if match.round != last_round
         buf << "\n\n"
         if match.round.is_a?( Integer ) ||
           match.round =~ /^[0-9]+$/   ## all numbers/digits
           if round.is_a?( Proc )
             buf << round.call( match.round )
           else
             ## default "class format
             ##   e.g. Runde 1, Spieltag 1, Matchday 1, Week 1
             buf << "#{round} #{match.round}"
           end
        else ## use as is from match
          buf << "#{match.round}"
        end
        buf << "\n"
       end
     end


     date = if match.date.is_a?( String )
               Date.strptime( match.date, '%Y-%m-%d' )
            else  ## assume it's already a date (object)
               match.date
            end

     date_yyyymmdd = date.strftime( '%Y-%m-%d' )

     if rounds
       if match.round != last_round || date_yyyymmdd != last_date
          buf << "[#{format_date.call( date )}]\n"
       end
     else
       if date_yyyymmdd != last_date
          buf << "\n"    ## note: add an extra leading blank line (if no round headings printed)
          buf << "[#{format_date.call( date )}]\n"
       end
    end


     ## allow strings and structs for team names
     team1 = match.team1.is_a?( String ) ? match.team1 : match.team1.name
     team2 = match.team2.is_a?( String ) ? match.team2 : match.team2.name


     line = String.new('')
     line << '  '
     line << "%-23s" % team1    ## note: use %-s for left-align

     line << "  #{format_score.call( match )}  "  ## note: separate by at least two spaces for now

     line << "%-23s" % team2


     if match.status
      line << '  '
      case match.status
      when Status::CANCELLED
        line << '[cancelled]'
      when Status::AWARDED
        line << '[awarded]'
      when Status::ABANDONED
        line << '[abandoned]'
      when Status::REPLAY
        line << '[replay]'
      when Status::POSTPONED
        ## note: add NOTHING for postponed for now
      else
        puts "!! WARN - unknown match status >#{match.status}<:"
        pp match
        line << "[#{match.status.downcase}]"  ## print "literal" downcased for now
      end
     end

     ## add match line
     buf << line.rstrip   ## remove possible right trailing spaces before adding
     buf << "\n"

     last_round = match.round
     last_date  = date_yyyymmdd
  end
  buf
end


def self.write( path, matches, name:, lang: 'en', rounds: true)

  buf = build( matches, lang: lang, rounds: rounds )

  ## for convenience - make sure parent folders/directories exist
  FileUtils.mkdir_p( File.dirname( path) )  unless Dir.exists?( File.dirname( path ))

  File.open( path, 'w:utf-8' ) do |f|
    f.write( "= #{name}\n" )
    f.write( buf )
  end
end # method self.write


end # class TxtMatchWriter
end # module SportDb
