module Worldfootball


MAX_HEADERS = [
'Stage',
'Round',
'Date',
'Time',
'Timezone',
'Team 1',
'FT',
'HT',
'Team 2',
'ET',
'P',
'Comments',    ## e.g. awarded, cancelled/canceled, etc.
'UTC']

MIN_HEADERS = [   ## always keep even if all empty
'Date',
'Team 1',
'FT',
'Team 2'
]

def self.vacuum( rows, headers: MAX_HEADERS, fixed_headers: MIN_HEADERS )
  ## check for unused columns and strip/remove
  counter = Array.new( MAX_HEADERS.size, 0 )
  rows.each do |row|
     row.each_with_index do |col, idx|
       counter[idx] += 1  unless col.nil? || col.empty?
     end
  end

  pp counter

  ## check empty columns
  headers       = []
  indices       = []
  empty_headers = []
  empty_indices = []

  counter.each_with_index do |num, idx|
     header = MAX_HEADERS[ idx ]
     if num > 0 || (num == 0 && fixed_headers.include?( header ))
       headers << header
       indices << idx
     else
       empty_headers << header
       empty_indices << idx
     end
  end

  if empty_indices.size > 0
    rows = rows.map do |row|
             row_vacuumed = []
             row.each_with_index do |col, idx|
               ## todo/fix: use values or such??
               row_vacuumed << col   unless empty_indices.include?( idx )
             end
             row_vacuumed
         end
    end

  [rows, headers]
end

end # module Worldfootball
