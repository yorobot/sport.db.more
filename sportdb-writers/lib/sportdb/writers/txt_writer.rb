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


def self.write( path, matches, title:, round:, lang: 'en')

  ## for convenience - make sure parent folders/directories exist
  FileUtils.mkdir_p( File.dirname( path) )  unless Dir.exists?( File.dirname( path ))


  out = File.new( path, 'w:utf-8' )

  out << "= #{title}\n"


  last_round = nil
  last_date  = nil


  matches.each do |match|
     if match.round != last_round
       out << "\n\n"
       if round.is_a?( Proc )
         out << round.call( match.round )
       else
         ## default "class format
         ##   e.g. Runde 1, Spieltag 1, Matchday 1, Week 1
         out << "#{round} #{match.round}"
       end
       out << "\n"
     end


     date = if match.date.is_a?( String )
               Date.strptime( match.date, '%Y-%m-%d' )
            else  ## assume it's already a date (object)
               match.date
            end

     date_YYYYMMDD = date.strftime( '%Y-%m-%d' )

     if match.round != last_round || date_YYYYMMDD != last_date

       date_buf = ''

       if lang == 'de'
         date_buf << DE_WEEKDAY[date.cwday]
         date_buf << ' '
         date_buf << date.strftime( '%-d.%-m.' )   ## e.g. Mo 11.8.
       elsif lang == 'es'
         date_buf << ES_WEEKDAY[date.cwday]
         date_buf << '. '
         date_buf << date.strftime( '%-d.%-m.' )   ## e.g. Lun. 11.8.
       elsif lang == 'it'
         date_buf << IT_WEEKDAY[date.cwday]
         date_buf << '. '
         date_buf << date.strftime( '%-d.%-m.' )   ## e.g. Lun. 11.8.
       elsif lang == 'fr'
         date_buf << FR_WEEKDAY[date.cwday]
         date_buf << " #{date.day}. "
         date_buf << FR_MONTH[date.month]
       else   ## assume en
         date_buf << EN_WEEKDAY[date.cwday]
         date_buf << ' '
         date_buf << date.strftime( '%b/%-d' )   ## e.g. Mon Aug/11
       end

       out << "[#{date_buf}]\n"
     end

     ## allow strings and structs for team names
     team1 = match.team1.is_a?( String ) ? match.team1 : match.team1.name
     team2 = match.team2.is_a?( String ) ? match.team2 : match.team2.name

     out << '  '
     out << "%-23s" % team1    ## note: use %-s for left-align

     if match.score1 && match.score2
       out << "  #{match.score1}-#{match.score2}"
       ## out << " (#{match.score1i}-#{match.score2i})"  if match.score1i && match.score2i
       out << '  '  ## note: separate by at least two spaces for now
     else
       out << '  -  '
     end

     out << ("%-23s" % team2).strip    ## remove trailing spaces (w7 strip)
     out << "\n"

     last_round = match.round
     last_date  = date_YYYYMMDD
  end

  out.close
end # method self.write

end # class TxtMatchWriter
end # module SportDb
