$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )


require 'kicker'


Webcache.root = '/sports/cache'


Webget.config.sleep = 1  # delay in sec(s)

