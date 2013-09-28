class Steinlager
  include DataMapper::Resource
  include DataMapper::Validate

  # Properties
  property :id,               Serial
  property  :sortier,  String   #  alt Steinlag SORTIER
  property  :steingruppe,  Integer   # Hilfstabelle alt Steinlag STEINGRUPPE
  property  :artikelnummer,  String   #  alt Steinlag Artikelnummer
  property  :sachet,  String   #  alt Steinlag SACHET
  property  :vorrat,  String   #  alt Steinlag VORRAT
  property  :beschrieb,  String   #  alt Steinlag BESCHRIEB
  property  :einheit,  String   #  alt Steinlag EINHEIT
  property  :mateinh_preis,  String   #  alt Steinlag MATEINH_PREIS
  property  :istmatpreis,  String   #  alt Steinlag ISTMATPREIS
  property  :momgewtot,  String   #  alt Steinlag MOMGEWTOT
  property  :gewichtpst,  String   #  alt Steinlag GEWICHTPST
  property  :vk,  String   #  alt Steinlag VK
  property  :beleg,  String   #  alt Steinlag BELEG
  property  :lieferant,  String   #  alt Steinlag Lieferant
  property  :inventarwe,  String   #  alt Steinlag INVENTARWE
  property  :wievielret,  String   #  alt Steinlag WIEVIELRET
  property  :vorratdatum,  String   #  alt Steinlag VORRATDATUM
  property  :lieferantennr,  String   #  alt Steinlag LieferantenNr
  property  :datum,  String   #  alt Steinlag DATUM
  property  :liefermenge,  String   #  alt Steinlag LIEFERMENGE
  property  :gebrauchtmenge,  String   #  alt Steinlag GEBRAUCHTMENGE
  property  :verlustmenge,  String   #  alt Steinlag VERLUSTMENGE
  property  :preispro,  String   #  alt Steinlag PREISPRO
  property  :kurzbeschrieb,  String   #  alt Steinlag Kurzbeschrieb
  property  :preisprostck,  String   #  alt Steinlag PreisProStck
  property  :gewichtmenge,  String   #  alt Steinlag GEWICHTMENGE
  property  :artnrzusatz,  String   #  alt Steinlag ARTNRZUSATZ
  property  :fremdwaehrung,  String   #  alt Steinlag FREMDWÄHRUNG
  property  :hinweis,  String   #  alt Steinlag HINWEIS
  property  :steinname,  String   #  alt Steinlag STEINNAME
  property  :selektion,  String   #  alt Steinlag SELEKTION
  property  :sortier2,  String   #  alt Steinlag Sortier2
  property  :lager2,  String   #  alt Steinlag Lager2
  property  :vorrat2,  String   #  alt Steinlag VORRAT 2
  property  :lag2sum,  String   #  alt Steinlag Lag2Sum
  property  :invlag2,  String   #  alt Steinlag InvLag2

end