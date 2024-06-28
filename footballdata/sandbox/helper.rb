$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'footballdata'


load_env   ## use dotenv (.env)


Webcache.root = '../../../cache'  ### c:\sports\cache

## note -  free tier (tier one) plan - 10 requests/minute   
##              (one request every 6 seconds 6*10=60 secs)
##     10 API calls per minute max.
##  note - default sleep (delay in secs) is 3 sec(s)
Webget.config.sleep  = 10

