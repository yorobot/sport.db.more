###
#  to run use
#     ruby test/test_build.rb


require_relative 'helper'

class TestBuild < Minitest::Test

  
  def test_parse_score
    ## note - parse_score returns
    ##   [ht, ft, et, pen, comments]
    #    note - (optional) half time (ht) score goes first

    assert_equal ['1-0', '3-2', '', '', ''], 
                 Worldfootball.parse_score( '3-2 (1-0)' )

    assert_equal ['', '3-0 (*)', '', '', 'awd.'],  ## awarded 
                 Worldfootball.parse_score( '3-0 (0-0, 0-0) Wert.' )
    assert_equal ['', '3-0 (*)', '', '', 'awd.'],  ## awarded 
                 Worldfootball.parse_score( '3-0 Wert.' )
  end


end # class TestBuild
