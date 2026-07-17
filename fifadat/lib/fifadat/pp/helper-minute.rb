

##
## note - check if m(inute) might be unknown e.g. '??' or such
##
##  offset (aka stoppage/injury/added time)

Minute  = Struct.new( :m, :offset, :period) do
    def as_json(*) to_s; end

    ## note - format minute WITHOUT minute marker/quote (')
    def to_s
        buf =  String.new
        buf << "#{m}"
        buf << "+#{offset}"      if offset
        buf
    end

    ##  add compare (for sort)
    def <=>( other )
         res = self.m           <=> other.m
         res = (self.offset||0) <=> (other.offset||0)   if res == 0
         res
    end
end  ## struct (class) Minute



def _build_minute( h )

    ## split into minute
    ##  and offset (stoppage/injury/added time)
    ##  e.g. 90'+11'

     minute_str = h['Minute']
          if minute_str.nil? || minute_str.empty?
              puts "!! minute is nil or empty:"
              pp h
              exit 1
          end

     minute, offset  = _parse_minute( minute_str )

     Minute.new( m:      minute,
                 offset: offset,
                 period: h['Period'] )
end


 MINUTE_RE = %r{  \A
                       (?<minute>\d{1,3}) '
                        (  \+
                          (?<offset>\d{1,2}) '
                        )?
                   \z
                 }x


def _parse_minute( str )

    ## support weirdo  120'+-30'  -- remove minuts
    str = str.gsub( '-', '' )

    m = MINUTE_RE.match( str )
    raise ArgumentError, "unknown goal minute format in #{str.inspect}"  if m.nil?

    minute = m[:minute].to_i(10)
    offset = m[:offset] ? m[:offset].to_i(10) : nil

    [minute,offset]
end

def _fmt_minute( minute, offset )
     ## pp [minute,offset]

     buf = String.new
     buf << "#{minute}"
     buf << "+#{offset}"   if offset
     buf << "'"
     buf
end
