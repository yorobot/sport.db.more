$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'openliga'


Webcache.root = '../../../cache'  ### c:\sports\cache


pp Openliga::LEAGUES
puts "  #{Openliga::LEAGUES.keys.size} league(s)"


## try de.1 - 1. bundesliga
# Openliga::Metal.matches( 'bl1', 2023 )  # 2023/2024
# Openliga::Metal.teams( 'bl1', 2023 )  
# Openliga::Metal.goalgetters( 'bl1', 2023 )  

# Openliga::Metal.matches( 'bl1', 2022 )  
# Openliga::Metal.teams( 'bl1', 2022 )  
# Openliga::Metal.matches( 'bl1', 2021 )  
# Openliga::Metal.matches( 'bl1', 2020 )  

# Openliga::Metal.matches( 'bl2', 2023 )  
# Openliga::Metal.matches( 'bl3', 2023 )  


# Openliga::Metal.matches( 'dfb',     2024 )
# Openliga::Metal.teams( 'dfb',     2024 )

# Openliga::Metal.matches( 'dfb',     2023 )
# Openliga::Metal.teams( 'dfb',     2023 )
# Openliga::Metal.matches( 'dfb2022', 2022 )



## austrian bundeslig
##  FIX
##   `split': URI must be ascii only 
## "https://api.openligadb.de/getmatchdata/\u00D6BL/2021" 
##   (URI::InvalidURIError)
# Openliga::Metal.matches( 'ÖBL', 2021 )

## champions league
# Openliga::Metal.matches( 'champion1', 2023 )	
# Openliga::Metal.teams( 'champion1', 2023 )	
# Openliga::Metal.goalgetters( 'champion1', 2023 )	
# Openliga::Metal.matches( 'uefacl22', 2022 )
# Openliga::Metal.matches( 'uefacl', 2021 )


# Openliga::Metal.matches( 'WM2022', 2022 )
# Openliga::Metal.goalgetters( 'WM2022', 2022 )


# Openliga::Metal.teams( 'em', 2024 )  
# Openliga::Metal.matches( 'em', 2024 )
# Openliga::Metal.goalgetters( 'em', 2024 )

# Openliga::Metal.matches( 'em20', 2020 )
# Openliga::Metal.goalgetters( 'em20', 2020 )

# Openliga::Metal.teams( 'CA2024', 2024 )  
# Openliga::Metal.matches( 'CA2024', 2024 )
# Openliga::Metal.goalgetters( 'CA2024', 2024 )


# Openliga::Metal.matches( 'CA2021', 2021 )
# Openliga::Metal.teams( 'CA2021', 2021 )


# Openliga::Metal.leagues



puts "bye"