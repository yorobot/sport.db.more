
  ## auto-fix copa.l 2024
   ##  !! ERROR: unsupported match status >IN_PLAY< - sorry:
   if m['status'] == 'IN_PLAY' &&
      team1 == 'Club Aurora' && team2 == 'FBC Melgar'
        m['status'] = 'FINISHED'
   end
