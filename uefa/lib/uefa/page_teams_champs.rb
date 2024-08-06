

module Uefa
class Page
class Teams < Page  ## nested inside Page - why? why not?
    def self.read_cache( url )
      html = Webcache.read( url )
      new( html )
    end


## get all team divs
=begin
<a href="/uefachampionsleague/clubs/52280--arsenal/" class="team-wrap" title="Arsenal">
<pk-identifier class="pk-py--xs team-wrap" type="vertical">
<span slot="prefix">
<pk-badge alt="Arsenal FC" badge-title="Arsenal FC" src="https://img.uefa.com/imgml/TP/teams/logos/70x70/52280.png"
fallback-image="club-generic-badge"></pk-badge>
</span>
<span slot="primary">Arsenal</span>
<span slot="secondary" class="team-name__country-code">(ENG)</span>
</pk-identifier>
</a>
--or--
              <a itemprop="url" href="/uefachampionsleague/history/clubs/60571--1860-munchen/" class="team-wrap" title="TSV 1860 M&#xFC;nchen">
                <pk-identifier class="pk-py--xs" class="team-wrap" type="vertical" itemprop="itemListElement" itemscope
                  itemtype="https://schema.org/ListItem">
                  <meta itemprop="position" content="0" />
                  <span slot="prefix">
                    <pk-badge alt="TSV 1860 M&#xFC;nchen" badge-title="TSV 1860 M&#xFC;nchen"
                      src="https://img.uefa.com/imgml/TP/teams/logos/70x70/60571.png"
                      fallback-image="club-generic-badge"></pk-badge>
                  </span>
                  <span slot="primary">1860 M&#xFC;nchen</span>
                    <span slot="secondary" class="team-name__country-code">(GER)</span>
                </pk-identifier>
              </a>
=end
  def teams
      recs = []

      els = doc.css( 'a.team-wrap' )
      puts "  #{els.size} a(s) found"

   els.each do |el|
       ## long name
      team_name1 =  el.at( 'pk-badge')['alt']   ## attr[] returns string
       ## short name
      team_name2 = el.at( %q{[slot="primary"]} ).text
     code =  el.at( %q{[slot="secondary"]} ).text

     team_names = if team_name1 != team_name2
                    [team_name1, team_name2]
                  else
                    [team_name1]
                  end

     recs << { names: team_names,
               code:  code }
   end
   recs
  end
end # class Teams < Page (nested)
end # class Page
end # module Uefa

