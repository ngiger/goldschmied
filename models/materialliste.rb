class Materialliste
  include DataMapper::Resource
  include DataMapper::Validate
  
  # Properties
  property :id,               Serial
  property  :description,  String   # row[0] Kurzberschreibung alt Matlist Kurzbeschrieb
  property  :price_per_unit,  String   # row[1] Preis pr Stück alt Matlist PreisProStck
  property  :unit,  String   # row[2] Einheit, z.B. Kg alt Matlist Einheit
  property  :article_number,  String   # row[3] Hauptschlüssel (sprechender) alt Matlist Artikelnummer
  property  :picture,  String   # row[4] Bild des Materials alt Matlist MatBild
  property  :emgk,  String   # row[5]  alt Matlist EMGK
  property  :magk,  String   # row[6]  alt Matlist MaGK
  property  :vvgk,  String   # row[7]  alt Matlist VVGK
  property  :gewinn_zuschlag,  String   # row[8]  alt Matlist GEWINNZU

end

x=%(
Feinsilber,     1.30,gramm,1001-0000-000,,+1,+1,+1,+1
Blattsilber / Brandenberger,     0.75,Blatt,1001-0001-000,,+1,+1,+1,+1
Ag925,     1.15,gramm,1001-1000-000,,+1,+1,+1,+1
Ag925/Feingold 9/10:1:/10,     8.00,gramm,1001-1100-000,,+1,+1,+1,+1
Ag800,     1.25,gramm,1001-2000-000,,+1,+1,+1,+1
Feingold,    55.00,gramm,1002-0000-000,,+1,+1,+1,+1
Blattgold / Brandenberger,     1.30,Blatt,1002-0001-000,,+1,+1,+1,+1
Gg750,    42.00,gramm,1002-1000-000,,+1,+1,+1,+1
"Gg750,900",    46.00,gramm,1002-1200-000,,+1,+1,+1,+1
)