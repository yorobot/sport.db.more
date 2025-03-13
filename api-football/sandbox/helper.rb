$LOAD_PATH.unshift( './lib' )
$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( '/sports/sportdb/sport.db/timezones/lib' )
require 'api-football'


load_env   ## use dotenv (.env)




Webcache.root = './cache'
## Webcache.root = '/sports/cache'  ### c:\sports\cache

## note -  free tier (tier one) plan - 10 requests/minute
##              (one request every 6 seconds 6*10=60 secs)
##     10 API calls per minute max.
##  note - default sleep (delay in secs) is 3 sec(s)
Webget.config.sleep  = 10


