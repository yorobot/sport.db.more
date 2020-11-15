
def self.write_at1( season, source: 'two', split: false, normalize: true )
  ## todo use **args, **kwargs!!! to "forward args, see england - why? why not?
  write( 'at.1', season, source: source, split: split, normalize: normalize )
end

def self.write_at2( season, source: 'two', split: false, normalize: true )
  write( 'at.2', season, source: source, split: split, normalize: normalize )
end

def self.write_at_cup( season, source: 'two', split: false, normalize: true )
  write( 'at.cup', season, source: source, split: split, normalize: normalize )
end


def self.write_de1(   season, source: 'leagues', extra: nil, split: false, normalize: true )
  write( 'de.1', season, source: source, extra: extra, split: split, normalize: normalize )
end

def self.write_de2(  season, source: 'leagues', extra: nil, split: false, normalize: true )
  write( 'de.2', season, source: source, extra: extra, split: split, normalize: normalize )
end

def self.write_de3(  season, source: 'leagues', extra: nil, split: false, normalize: true )
  write( 'de.3', season, source: source, extra: extra, split: split, normalize: normalize )
end

def self.write_de_cup(  season, source: 'two', split: false, normalize: true )
  write( 'de.cup', season, source: source, split: split, normalize: normalize )
end


def self.write_eng1( season, **kwargs )
  kwargs[:source] ||= 'one'
  write( 'eng.1', season, **kwargs )
end

def self.write_eng2( season, **kwargs )
  kwargs[:source] ||= 'one'
  write( 'eng.2', season, **kwargs )
end


def self.write_eng3( season, source: 'two', extra: nil )
  write( 'eng.3', season, source: source, extra: extra )
end

def self.write_eng4( season, source: 'two', extra: nil )
  write( 'eng.4', season, source: source, extra: extra )
end

def self.write_eng5( season, source: 'two' )
  write( 'eng.5', season, source: source )
end

def self.write_eng_cup( season, source: 'two' )
  write( 'eng.cup', season, source: source )
end


def self.write_it1( season, source: ) write( 'it.1', season, source: source ); end
def self.write_it2( season, source: ) write( 'it.2', season, source: source ); end

def self.write_es1( season, source: ) write( 'es.1', season, source: source ); end
def self.write_es2( season, source: ) write( 'es.2', season, source: source ); end

def self.write_fr1( season, source: ) write( 'fr.1', season, source: source ); end
def self.write_fr2( season, source: ) write( 'fr.2', season, source: source ); end

def self.write_hu1( season, source: ) write( 'hu.1', season, source: source ); end
def self.write_gr1( season, source: ) write( 'gr.1', season, source: source ); end

def self.write_pt1( season, source: ) write( 'pt.1', season, source: source ); end

def self.write_ch1( season, source: ) write( 'ch.1', season, source: source ); end
def self.write_ch2( season, source: ) write( 'ch.2', season, source: source ); end

def self.write_tr1( season, source: ) write( 'tr.1', season, source: source ); end
def self.write_tr2( season, source: ) write( 'tr.2', season, source: source ); end


def self.write_be1( season, source: ) write( 'be.1', season, source: source ); end
def self.write_nl1( season, source: ) write( 'nl.1', season, source: source ); end
def self.write_lu1( season, source: ) write( 'lu.1', season, source: source ); end

def self.write_is1( season, source: ) write( 'is.1', season, source: source ); end
def self.write_ie1( season, source: ) write( 'ie.1', season, source: source ); end
def self.write_sco1( season, source: ) write( 'sco.1', season, source: source ); end

def self.write_dk1( season, source: ) write( 'dk.1', season, source: source ); end
def self.write_no1( season, source: ) write( 'no.1', season, source: source ); end
def self.write_se1( season, source: ) write( 'se.1', season, source: source ); end
def self.write_se2( season, source: ) write( 'se.2', season, source: source ); end
def self.write_fi1( season, source: ) write( 'fi.1', season, source: source ); end

def self.write_pl1( season, source: ) write( 'pl.1', season, source: source ); end
def self.write_cz1( season, source: ) write( 'cz.1', season, source: source ); end
def self.write_sk1( season, source: ) write( 'sk.1', season, source: source ); end

def self.write_hr1( season, source: ) write( 'hr.1', season, source: source ); end

def self.write_ua1( season, source: ) write( 'ua.1', season, source: source ); end

def self.write_ru1( season, source: ) write( 'ru.1', season, source: source ); end
def self.write_ru2( season, source: ) write( 'ru.2', season, source: source ); end


def self.write_ar1( season, source: ) write( 'ar.1', season, source: source ); end
def self.write_br1( season, source: ) write( 'br.1', season, source: source ); end



def self.write_mx1( season, source: ) write( 'mx.1', season, source: source ); end


def self.write_cn( season, source: ) write( 'cn.1', season, source: source ); end
def self.write_jp( season, source: ) write( 'jp.1', season, source: source ); end

