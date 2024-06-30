require_relative '../boot'



DATAFILES_DIR = './o'


team_buf, team_errors   = SportDb::TeamSummary.build( DATAFILES_DIR )


File.open( "#{DATAFILES_DIR}/SUMMARY.md", 'w:utf-8' ) { |f| f.write( team_buf ) }


puts "#{team_errors.size} error(s) - teams:"
pp team_errors

puts 'bye'

