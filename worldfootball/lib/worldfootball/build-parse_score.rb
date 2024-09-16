module Worldfootball


## add  WO
##   br.mineiro 2024 - Descenso
##
##  W.O. or w/o (originally two words: "walk over"),
##
## [004] 3. Spieltag => 3
## [004]    2024-03-22 | 00:00 | Atlético Patrocinense - MG | Ipatinga - MG          | WO
## !! ERROR - unsupported score format >WO< - sorry; maybe add a score error fix/patch




def self.parse_score( score_str )
    ## add support for
    ##   3-0 (0-0, 0-0) Wert.
    ##   3-0 (0-0, 0-0) awd.

  ## check for 0:3 Wert.   - change Wert. to awd.  (awarded)
  ## todo/fix - use "hardcoded" Wert\. in regex - why? why not?
  ## score_str = score_str.sub( /Wert\./i, 'awd.' )


  comments = String.new     ## check - rename to/use status or such - why? why not?

  ## split score
  ft  = ''
  ht  = ''
  et  = ''
  pen = ''


  if score_str == '---'   ## in the future (no score yet) - was -:-
    ft = ''
    ht = ''
  elsif score_str == 'n.gesp.' ||   ## cancelled (british) / canceled (us)
        score_str == 'ausg.'   ||   ## todo/check: change to some other status ????
        score_str == 'annull.'      ## todo/check: change to some other status (see ie 2012) ????
    ft = '(*)'
    ht = ''
    comments = 'cancelled'
  elsif score_str == 'abgebr.'  ## abandoned  -- waiting for replay?
    ft = '(*)'
    ht = ''
    comments = 'abandoned'
  elsif score_str == 'verl.'   ## postponed
    ft = ''
    ht = ''
    comments = 'postponed'
  elsif score_str == 'WO'   # walk over
    ##  W.O. or w/o (originally two words: "walk over"),
    ft = '(*)'
    ht = ''
    comments = 'w/o'   ## use walkover - why? why not?
  # 5-4 (0-0, 1-1, 2-2) i.E.
  elsif score_str =~ /([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*
                      \(([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*,[ ]*
                        ([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*,[ ]*
                       ([0-9]+) [ ]*-[ ]* ([0-9]+)\)
                          [ ]*
                       i\.E\.
                     /x
    pen = "#{$1}-#{$2}"
    ht  = "#{$3}-#{$4}"
    ft  = "#{$5}-#{$6}"
    et  = "#{$7}-#{$8}"
  # 3-2 (0-0, 1-1) i.E.   - note: no extra time!!! only ht,ft!!!
  #                         "popular" in southamerica & mexico
  elsif score_str =~ /([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*
                      \(([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*,[ ]*
                       ([0-9]+) [ ]*-[ ]* ([0-9]+)\)
                          [ ]*
                       i\.E\.
                     /x
    pen = "#{$1}-#{$2}"
    ht  = "#{$3}-#{$4}"
    ft  = "#{$5}-#{$6}"
    et  = ''
  # 2-1 (1-0, 1-1) n.V
  elsif score_str =~ /([0-9]+) [ ]*-[ ]* ([0-9]+)
                      [ ]*
                    \(([0-9]+) [ ]*-[ ]* ([0-9]+)
                       [ ]*,[ ]*
                      ([0-9]+) [ ]*-[ ]* ([0-9]+)
                      \)
                       [ ]*
                       n\.V\.
                     /x
    et  = "#{$1}-#{$2}"
    ht  = "#{$3}-#{$4}"
    ft  = "#{$5}-#{$6}"
  ### auto-patch fix drop last score
  ## 1-3 (0-1, 1-1, 0-2) n.V.  => 1-3 (0-1, 1-1) n.V.
  elsif score_str =~ /([0-9]+) [ ]*-[ ]* ([0-9]+)
                      [ ]*
                    \(([0-9]+) [ ]*-[ ]* ([0-9]+)
                       [ ]*,[ ]*
                      ([0-9]+) [ ]*-[ ]* ([0-9]+)
                       [ ]*,[ ]*
                      ([0-9]+) [ ]*-[ ]* ([0-9]+)
                      \)
                       [ ]*
                       n\.V\.
                     /x
    et  = "#{$1}-#{$2}"
    ht  = "#{$3}-#{$4}"
    ft  = "#{$5}-#{$6}"

    puts "!! WARN - auto-fix/patch score - >#{score_str}<"
    ### todo/fix - log auto-patch/fix - for double checking!!!!!
  elsif score_str =~ /([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*
                      \(([0-9]+) [ ]*-[ ]* ([0-9]+)
                      \)
                     /x
    ft = "#{$1}-#{$2}"
    ht = "#{$3}-#{$4}"
  elsif  score_str =~ /([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*
                          Wert\.    # ([a-z.]+)
                       /x    ### assume awd. (awarded) always - why? why not?
    ft = "#{$1}-#{$2} (*)"
    ht = ''
    comments = 'awd.'   # awarded - $3
  ##  auto-fix/patch
  ##   drop last scores (only use ft)
  ##     3-0 (0-0, 0-0) awd.
  elsif  score_str =~ /([0-9]+) [ ]*-[ ]* ([0-9]+)
                         [ ]*
                       \(([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*,[ ]*
                        ([0-9]+) [ ]*-[ ]* ([0-9]+)
                       \)
                        [ ]*
                        Wert\.    # ([a-z.]+)
                       /x    ### assume awd. (awarded) always - why? why not?
    ft = "#{$1}-#{$2} (*)"
    ht = ''
    comments = 'awd.'   # awarded - $7
    ## (auto) log case for double checking - why? why not?
  elsif score_str =~ /^([0-9]+)-([0-9]+)$/
     ft = "#{$1}-#{$2}"     ## e.g. see luxemburg and others
     ht = ''
  ## auto-fix/patch
  # 3-3 (0-3, 3-3)  =>  3-3 (0-3) - drop last score
  elsif score_str =~ /^([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*
                      \(([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*,[ ]*
                        ([0-9]+) [ ]*-[ ]* ([0-9]+)
                      \)$
                     /x
    ft = "#{$1}-#{$2}"
    ht = "#{$3}-#{$4}"

    puts "!! WARN - auto-fix/patch score - >#{score_str}<"
    ### todo/fix - log auto-patch/fix - for double checking!!!!!
  elsif score_str =~ /^([0-9]+) [ ]*-[ ]* ([0-9]+)
                         [ ]*
                       n\.V\.
                      $/x
    et  = "#{$1}-#{$2}"
    ht  = ''
    ft  = ''
    puts "!! WARN - weird score n.V. only - >#{score_str}<"
  elsif score_str =~ /^([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*
                       i\.E\.
                       $/x
    pen = "#{$1}-#{$2}"
    et  = ''
    ht  = ''
    ft  = ''
    puts "!! WARN - weird score i.E. only - >#{score_str}<"
  else
     puts "!! ERROR - unsupported score format >#{score_str}< - sorry; maybe add a score error fix/patch"
     exit 1
  end

  [ht, ft, et, pen, comments]
end
end  # module Worldfootball