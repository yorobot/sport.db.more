
SEASONS = %w[2024/25 2023/24 2022/23 2021/22 2020/21]
DATASETS = [
    ['at.1', (Season('1995/96')..Season('2024/25')).to_a],
    ['at.2', SEASONS],
    ['at.3.o', SEASONS],
    ['at.cup', SEASONS],
    
    ['de.1', (Season('1963/64')..Season('2024/25')).to_a],
    ['de.2', SEASONS],
    ['de.3', SEASONS],
    ['de.4.bayern', SEASONS - %w[2020/21]],
    ['de.cup', SEASONS],

    ['ch.1', SEASONS],
    ['ch.2', SEASONS],
    ['ch.cup', SEASONS],

    ['be.1', SEASONS],
    ['nl.1', SEASONS],

    ['tr.1', SEASONS],

    ['eng.1', SEASONS],
    ['es.1', SEASONS],
    ['it.1', SEASONS],
    ['fr.1', SEASONS],
  
    ['uefa.cl',   (Season('1992/93')..Season('2023/24')).to_a], 
    ['uefa.el',   SEASONS - %w[2024/25]], 
    ['uefa.conf', SEASONS - %w[2024/25 2020/21]], 

    ## note - special seasons for mx required !!!
    ['mx.1', %w[2024/25 2024 
                2023/24 2023
                2022/23 2022
                2021/22 2021
                2020/21 2020
                2019/20 2019
                2018/19 2018
                2017/18 2017
                2016/17 2016
                2015/16 2015
                2014/15 2014
                2013/14 2013
                2012/13 2012
                2011/12 2011
                2010/11 2010]],
]

