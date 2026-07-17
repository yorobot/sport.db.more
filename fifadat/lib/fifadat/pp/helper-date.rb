

def _fmt_date_local(  date_utc, date_local )

  ## note:  returns Rational (e.g. 3/1 or 1/4 etc.) use to_f/to_i to convert
  diff_in_hours = ((date_local - date_utc) * 24).to_f
  diff_in_days  =  date_local.jd - date_utc.jd
  ## pp [diff_in_hours, diff_in_days]


  ## use   20:30 UTC+1  or 20:30 UTC-3
  "#{date_local.strftime( '%Y-%m-%d %H:%M' )} UTC%+d" % diff_in_hours
end
