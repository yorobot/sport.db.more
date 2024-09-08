###
#  to run use
#     ruby test/test_convert.rb


require_relative 'helper'

class TestConvert < Minitest::Test

  def test_convert_score
    ## duration: REGULAR  · PENALTY_SHOOTOUT  · EXTRA_TIME
    ## ft, ht, et, pen = ['','','','']

    data = parse_json( <<JSON )
    {
        "score": {
          "winner": "HOME_TEAM",
          "duration": "PENALTY_SHOOTOUT",
          "fullTime":    { "home": 6, "away": 4  },
          "halfTime":    { "home": 0, "away": 0  },
          "regularTime": { "home": 1, "away": 1  },
          "extraTime":   { "home": 0, "away": 0  },
          "penalties":   { "home": 5, "away": 3  }
       }
    }
JSON

    score = Footballdata.convert_score( data['score'] )
    pp score
    assert_equal ['1-1', '0-0', '1-1', '5-3'], score


    data = parse_json( <<JSON )
    {
        "score": {
            "winner": "HOME_TEAM",
            "duration": "REGULAR",
            "fullTime": { "home": 2, "away": 1 },
            "halfTime": { "home": 0, "away": 0 }
          }
    }
JSON

    score = Footballdata.convert_score( data['score'] )
    pp score
    assert_equal ['2-1', '0-0', '', ''], score


    data = parse_json( <<JSON )
    {
        "score": {
            "winner": "HOME_TEAM",
            "duration": "EXTRA_TIME",
            "fullTime":    { "home": 2, "away": 1 },
            "halfTime":    { "home": 0, "away": 1 },
            "regularTime": { "home": 1, "away": 1 },
            "extraTime":   { "home": 1, "away": 0 }
          }
    }
JSON

    score = Footballdata.convert_score( data['score'] )
    pp score
    assert_equal ['1-1', '0-1', '2-1', ''], score
end


end # class TestConvert