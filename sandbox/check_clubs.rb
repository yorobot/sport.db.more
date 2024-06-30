##
# todo/fix - move this script out of footballdata
#      move to sandbox/  or ????
#   no footballdata api used



###
# check more clubs
#   see https://www.rsssf.org/sacups/sudamcup-allt.html
#       Copa Sudamericana - All-Time Table 2002-2023


require 'cocos'


txt =<<TXT
Liga Deportiva Universitaria,  (ECU/Quito)
São Paulo FC,  (BRA/São Paulo)
CA Independiente,  (ARG/Avellaneda)
Club Libertad,  (PAR/Asunción)
Atlético Nacional,  (COL/Medellín)
CA Lanús,  (ARG/Lanús Este)
CA San Lorenzo de Almagro,  (ARG/Buenos Aires)
Fluminense FC,  (BRA/Río de Janeiro)
CS Emelec,  (ECU/Guayaquil)
Club Athletico Paranaense,  (BRA/Curitiba)
Club Cerro Porteño,  (PAR/Asunción)
CDP Junior FC,  (COL/Barranquilla)
CD Universidad Católica de Chile,  (CHI/Santiago)
Botafogo FR,  (BRA/Río de Janeiro)
CA River Plate (Buenos Aires),  (ARG/Buenos Aires)
SC Internacional,  (BRA/Porto Alegre)
CSD Defensa y Justicia,  (ARG/Florencio Varela)
SC Corinthians Paulista,  (BRA/São Paulo)
Club Estudiantes de La Plata,  (ARG/La Plata)
CI Santa Fe,  (COL/Bogotá)
CA Peñarol,  (URU/Montevideo)
Arsenal FC,  (ARG/Sarandí)
CA River Plate (Montevideo),  (URU/Montevideo)
Club Bolívar,  (BOL/La Paz)
CFP Universidad de Chile,  (CHI/Santiago)
Club Nacional de Football,  (URU/Montevideo)
Azul & Blanco - Millonarios F.C.,  (COL/Bogotá)
CA Boca Juniors,  (ARG/Buenos Aires)
Santos FC,  (BRA/Santos)
CA Vélez Sarsfield,  (ARG/Buenos Aires)
Club Deportes Tolima,  (COL/Ibagué)
CdAR Independiente del Valle,  (ECU/Sangolquí)
EC Bahia,  (BRA/Salvador)
CSyD Colo-Colo,  (CHI/Santiago)
Goiás EC,  (BRA/Goiânia)
FBC Melgar,  (PER/Arequipa)
Barcelona SC,  (ECU/Guayaquil)
Asociación Deportivo Cali,  (COL/Cali)
Defensor Sporting Club,  (URU/Montevideo)
RB Bragantino Futebol,  (BRA/Bragança Paulista)
CA Colón,  (ARG/Santa Fe)
Atlético Clube Goianiense,  (BRA/Goiânia)
Ceará SC,  (BRA/Fortaleza)
Grêmio FBPA,  (BRA/Porto Alegre)
Club Guaraní,  (PAR/Asunción)
CR Vasco da Gama,  (BRA/Río de Janeiro)
CD La Equidad Seguros,  (COL/Bogotá)
CR Flamengo,  (BRA/Río de Janeiro)
CA Newell's Old Boys,  (ARG/Rosario)
CD El Nacional,  (ECU/Quito)
Club Olimpia,  (PAR/Asunción)
Clube Atlético Mineiro,  (BRA/Belo Horizonte)
Club Sportivo Luqueño,  (PAR/Luque)
CS Cienciano,  (PER/Cuzco)
CD Palestino,  (CHI/Santiago)
Racing Club,  (ARG/Avellaneda)
Fortaleza EC,  (BRA/Fortaleza)
Montevideo Wanderers FC,  (URU/Montevideo)
Huachipato FC,  (CHI/Talcahuano)
Club Universitario de Deportes,  (PER/Lima)
SE Palmeiras,  (BRA/São Paulo)
Club Nacional,  (PAR/Asunción)
Águilas Doradas Rionegro,  (COL/Rionegro)
CD de la Universidad Católica,  (ECU/Quito)
CA Huracán,  (ARG/Buenos Aires)
Club Sport Huancayo,  (PER/Huancayo)
CDyC Oriente Petrolero,  (BOL/Santa Cruz de la Sierra)
Liverpool FC,  (URU/Montevideo)
Audax Italiano LF,  (CHI/Santiago)
AA Ponte Preta,  (BRA/Campinas)
Sociedad Deportivo Quito,  (ECU/Quito)
CA Tigre,  (ARG/Victoria)
AC Mineros de Guayana,  (VEN/Ciudad Guayana)
AA Argentinos Juniors,  (ARG/Buenos Aires)
CD Unión La Calera,  (CHI/La Calera)
Club Sol de América,  (PAR/Villa Elisa)
Associação Chapecoense de Futebol,  (BRA/Chapecó)
Club The Strongest,  (BOL/La Paz)
CA Banfield,  (ARG/Banfield)
Danubio FC,  (URU/Montevideo)
LDU de Loja,  (ECU/Loja)
CA Rosario Central,  (ARG/Rosario)
Cruzeiro EC,  (BRA/Belo Horizonte)
Caracas FC,  (VEN/Caracas)
Deportivo Independiente Medellín,  (COL/Medellín)
CA Unión,  (ARG/Santa Fe)
CCyD Jorge Wilsterman,  (BOL/Cochabamba)
CF Pachuca,  (MEX/Pachuca)
EC Vitória,  (BRA/Salvador)
CF América,  (MEX/Ciudad de México)
Metropolitanos FC,  (VEN/Caracas)
SD Aucas,  (ECU/Quito)
Universidad César Vallejo CF,  (PER/Trujillo)
Sport Club do Recife,  (BRA/Recife)
Club de Gimnasia y Esgrima LP,  (ARG/La Plata)
Deportivo La Guaira FC,  (VEN/La Guaira)
Coquimbo Unido,  (CHI/Coquimbo)
Club Everton de Viña del Mar,  (CHI/Viña del Mar)
Club Sporting Cristal,  (PER/Lima)
Coritiba FBC,  (BRA/Curitiba)
Asociación Deportivo Pasto,  (COL/San Juan de Pasto)
CA River Plate (Asunción),  (PAR/Asunción)
CD Guadalajara,  (MEX/Guadalajara)
América de Cali,  (COL/Cali)
Montevideo City Torque,  (URU/Montevideo)
América FC (Belo Horizonte),  (BRA/Belo Horizonte)
Guaireña FC,  (PAR/Villarrica)
Zulia FC,  (VEN/Maracaibo)
CA Nacional Potosí,  (BOL/Potosí)
CD Universitario SFX,  (BOL/Sucre)
CSCyD Blooming,  (BOL/Santa Cruz de la Sierra)
Club Alianza Lima,  (PER/Lima)
CA Fénix,  (URU/Montevideo)
Alianza Atlético Sullana,  (PER/Sullana)
Deportivo Anzoátegui SC,  (VEN/Puerto La Cruz)
Club Universidad Nacional,  (MEX/Ciudad de México)
Club General Díaz,  (PAR/Luque)
CD Coronel Bolognesi,  (PER/Tacna)
CDSC Guabirá,  (BOL/Montero)
Club Deportivo Capiatá,  (PAR/Capiatá)
AD São Caetano,  (BRA/São Caetano do Sul)
CD Cobreloa,  (CHI/Calama)
CD Ñublense,  (CHI/Chillán)
Unión Española,  (CHI/Santiago)
General Caballero,  (PAR/Doctor Juan León Mallorquín)
CD Aurora,  (BOL/Cochabamba)
Club Real Potosí,  (BOL/Potosí)
Tacuary FBC,  (PAR/Asunción)
CD Macará,  (ECU/Ambato)
Club Atlético Tucumán,  (ARG/San Miguel de Tucumán)
CA Cerro,  (URU/Montevideo)
CD Temuco,  (CHI/Temuco)
CA Boston River,  (URU/Montevideo)
CD Santiago Wanderers,  (CHI/Valparaíso)
CD Universidad de Concepción,  (CHI/Concepción)
CA Belgrano,  (ARG/Córdoba)
CD Universidad San Martín Porres,  (PER/Lima)
Club de Deportes Antofagasta,  (CHI/Antofagasta)
Figueirense FC,  (BRA/Florianópolis)
Deportivo Toluca FC,  (MEX/Toluca)
Cuiabá EC,  (BRA/Cuiabá)
CD San José,  (BOL/Oruro)
Monagas SC,  (VEN/Maturín)
Trujillanos FC,  (VEN/Valera)
CA Talleres,  (ARG/Córdoba)
Club 12 de Octubre de Itauguá,  (PAR/Itauguá)
9 de Octubre FC,  (ECU/Guayaquil)
Ayacucho FC,  (PER/Ayacucho)
Aragua FC,  (VEN/Maracay)
Estudiantes de Mérida FC,  (VEN/Mérida)
Avaí FC,  (BRA/Florianópolis)
Santa Cruz FC,  (BRA/Recife)
Club Plaza Colonia de Deportes,  (URU/Colonia del Sacramento)
Cusco FC,  (PER/Cuzco)
Club Deportivo Cuenca,  (ECU/Cuenca)
Club de Deportes Iquique,  (CHI/Iquique)
Deportivo Petare FC,  (VEN/Caracas)
San Luis FC,  (MEX/San Luis Potosí)
CD Olmedo,  (ECU/Riobamba)
CD O'Higgins de Rancagua,  (CHI/Rancagua)
Royal Pari FC,  (BOL/Santa Cruz de la Sierra)
Zamora FC,  (VEN/Barinas)
Carabobo FC,  (VEN/Valencia)
CA Juventud,  (URU/Las Piedras)
Envigado FC,  (COL/Envigado)
Brasília FC,  (BRA/Brasilia)
CD Atlético Huila,  (COL/Neiva)
CD Unión San Felipe,  (CHI/San Felipe)
Club UTC,  (PER/Cajamarca)
Deportivo Lara,  (VEN/Cabudare)
Deportivo Táchira FC,  (VEN/San Cristóbal)
Sport Áncash FC,  (PER/Huaraz)
Rampla Juniors FC,  (URU/Montevideo)
Fuerza Amarilla SC,  (ECU/Machala)
DC United,  (USA/Washington, D.C.)
Club Deportivo Santaní,  (PAR/San Estanislao)
Criciúma EC,  (BRA/Criciúma)
Patriotas Boyacá,  (COL/Tunja)
CD Godoy Cruz AT,  (ARG/Godoy Cruz)
CD Magallanes,  (CHI/Santiago)
CD Provincial Osorno,  (CHI/Osorno)
Clube Náutico Capibaribe,  (BRA/Recife)
Atlético Venezuela CF,  (VEN/Caracas)
Club Sport Boys Association,  (PER/Callao)
EC Juventude,  (BRA/Caxias do Sul)
CD Hermanos Colmenárez,  (VEN/Barinas)
CA Rentistas,  (URU/Montevideo)
Club Always Ready,  (BOL/El Alto)
Mushuc Runa SC,  (ECU/Ambato)
Jaguares FC,  (COL/Montería)
Paraná Clube,  (BRA/Curitiba)
Academia Puerto Cabello,  (VEN/Puerto Cabello)
Independiente FBC,  (PAR/Asunción)
CD Cobresal,  (CHI/El Salvador)
CD Unión Comercio,  (PER/Moyobamba)
Cerro Largo FC,  (URU/Melo)
Yaracuyanos FC,  (VEN/San Felipe)
Associação Portuguesa Desportos,  (BRA/São Paulo)
Grêmio Barueri Futebol,  (BRA/Barueri)
Central Español FC,  (URU/Montevideo)
UA Maracaibo,  (VEN/Maracaibo)
ASDC Comerciantes Unidos,  (PER/Cutervo)
CA Patronato Juventud Católica,  (ARG/Paraná)
Once Caldas DAF,  (COL/Manizales)
Quilmes AC,  (ARG/Quilmes)
Club Sport Rosario,  (PER/Huaraz)
CA Bella Vista,  (URU/Montevideo)
Delfín SC,  (ECU/Manta)
CSD Carlos A. Mannucci,  (PER/Trujillo)
Club Sportivo Ameliano,  (PAR/Asunción)
CSD Atlético Grau,  (PER/Piura)
La Paz FC,  (BOL/La Paz)
Joinville EC,  (BRA/Joinville)
CCD El Tanque Sisley,  (URU/Montevideo)
Guayaquil City FC,  (ECU/Guayaquil)
FC Motagua,  (HON/Tegucigalpa)
CD Petrolero del Chaco,  (BOL/Yacuiba)
EM Deportivo Binacional,  (PER/Desaguadero)
Estudiantes de Caracas SC,  (VEN/Caracas)
CSD León de Huánuco,  (PER/Huánuco)
Llaneros de Guanare EF,  (VEN/Guanare)
CA Palmaflor,  (BOL/Quillacollo)
LD Alajuelense,  (CRC/Alajuela)
CC Deportivo Municipal,  (PER/Lima)
Club Juan Aurich,  (PER/Chiclayo)
TXT

def split_line( line )
    name, geo = line.split(',')
 
    geo = geo.gsub( /[()]/, '')
    country, city = geo.split( '/' )
 
    [name.strip, 
     country.strip, 
     city.strip]
end

## split by name, country, city
clubs = txt.lines.map { |line| split_line( line ) }
pp clubs





$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-readers/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-sync/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-models/lib' )
require 'sportdb/catalogs'

SportDb::Import.config.catalog_path = '../../../sportdb/sport.db/catalog/catalog.db'

CatalogDb::Metal.tables  # print table stats



## sort by country code
clubs = clubs.sort { |l,r| l[1] <=> r[1] }


puts
puts "==> #{clubs.size} teams"


#######################
# check and normalize team names

clubs.each_with_index do |(team_name, country_name, city_name),i|

   country = SportDb::Import.world.countries.find( country_name )
   if country.nil?
     puts "!! ERROR: no mapping found for country >#{country_name}<:"
     pp team_name
     pp team_hash
     exit 1
   end

   ## note - use lookup with country required
   club = SportDb::Import.catalog.clubs.find_by( 
                                  name:    team_name,
                                  country: country )
   if club.nil?
    puts "!! ERROR   #{team_name}  @ #{city_name}, #{country.name}"
    ## exit 1
   else
    if team_name != club.name
         puts " != #{i+1} -   #{team_name}  =>  #{club.name} @ #{city_name}, #{country.name}"  
    else
      print "#{i+1} -   #{team_name} @ #{city_name}, #{country_name}"
      print "\n"
    end 
   end
end

puts "bye"
