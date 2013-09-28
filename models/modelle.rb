class Modelle
  
  include DataMapper::Resource
  include DataMapper::Validate

  # Properties
  property  :id,               Serial
  property  :langtext,  String   #  alt Modelle Langtext
  property  :neuemodellnr,  String   #  alt Modelle neueModellNr
  property  :bestellnr,  String   #  alt Modelle BestellNr
  property  :einheit,  String   #  alt Modelle Einheit
  property  :kurzbeschrieb,  String   #  alt Modelle Kurzbeschrieb
  property  :lieferant,  String   #  alt Modelle Lieferant
  property  :kommentar,  String   #  alt Modelle Kommentar
  property  :modellgruppe,  String   #  alt Modelle Modellgruppe
  property  :gummikosten,  String   #  alt Modelle Gummikosten
  property  :wanngummi,  String   #  alt Modelle wannGummi
  property  :erwartetzahl,  String   #  alt Modelle erwartetZahl
  property  :modellkosten,  String   #  alt Modelle Modellkosten
  property  :produktionsnr,  String   #  alt Modelle ProduktionsNr
  property  :kostengerechnet,  String   #  alt Modelle Kostengerechnet
  property  :modellgewicht,  String   #  alt Modelle ModellGewicht
  property  :metall,  String   #  alt Modelle Metall
  property  :effektaufpreis,  String   #  alt Modelle effektAufpreis
  property  :lieferantennr,  String   #  alt Modelle LieferantenNr
  property  :artikelnummer,  String   #  alt Modelle Artikelnummer
  property  :kollektionsname,  String   #  alt Modelle Kollektionsname
  property  :schmart1,  String   #  alt Modelle SchmArt1
  property  :testfeld1,  String   #  alt Modelle Testfeld1
end