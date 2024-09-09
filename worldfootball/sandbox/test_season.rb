require 'season/formats'


####
#  check all seasons greater than 2019/20
 res=Season('2020') > Season('2019/20')
     pp res, "2020 > 2019/20"
 res=Season('2020') >= Season('2019/20')
    pp res,  "2020 >= 2019/20"
res=Season('2019/20') >= Season('2019/20')
    pp res,  "2019/20 >= 2019/20"
 res=Season('2019')  > Season('2019/20')
    pp res,  "2019 > 2019/20"
 res=Season('2019')  >= Season('2019/20')
    pp res,  "2019 >= 2019/20"




puts "bye"