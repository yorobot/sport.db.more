require_relative 'helper'


# slug = 'manchester-city'
slug = 'al-ahly-sc'

cache = false
# Worldfootball::Metal.download_team( slug, cache: cache )

page = Worldfootball::Page::Team.from_cache( slug )
pp page.title

# puts "matches:"
# pp page.matches


puts "bye"


__END__

<div class="sidebar">

<div class="box emblemwrapper">
<div class="head">
<h2>Al Ahly SC</h2>
</div>
<div class="data " align="center">
<div class="emblem"><a href="/teams/al-ahly-sc/"><img src="https://s.hs-data.com/bilder/wappen/mittel/1480.gif?fallback=png" border="0" width="100" hspace="5" vspace="5" alt="Al Ahly SC" title="Al Ahly SC" /></a></div>
<div class="emblem_background"><a href="/teams/al-ahly-sc/"><img src="https://s.hs-data.com/bilder/wappen/mittel/1480.gif?fallback=png" border="0" width="100" hspace="5" vspace="5" alt="Al Ahly SC" title="Al Ahly SC" /></a></div>
</div>
<div class="data">
<table class="standard_tabelle yellow" cellpadding="3" cellspacing="0">
<tr>
<td colspan="2" align="center">Al Ahly Sporting Club</td>
</tr>
<tr>
<td colspan="2">&nbsp;</td>
</tr>
<tr>
<td align="right"><b>Land:</b></td>
<td>
<img src="https://s.hs-data.com/bilder/flaggen_neu/68.gif" width="18" height="12" hspace="5" title="Ägypten" align="absmiddle" />
Ägypten </td>
</tr>
<tr>
<td align="right"><b>gegründet:</b></td>
<td>24.04.1907</td>
</tr>
<tr>
<td align="right"><b>Stadion:</b></td>
<td><a href="/spielorte/international-stadium-cairo/" title="International Stadium">International Stadium</a></td>
</tr>
<tr>
<td align="right"><b>Homepage:</b></td>
<td><a href="http://alahlyegypt.com/" target="_blank">alahlyegypt.com/</a></td>
</tr>
<tr>
<td colspan="2" align="right"><b><a href="/teams/al-ahly-sc/1/" title="Weitere Infos zu Al Ahly SC">zum Profil &raquo;</a></b></td>
</tr>
</table>
</div>
</div>
