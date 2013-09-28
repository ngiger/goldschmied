class Gusskosten
  include DataMapper::Resource
  include DataMapper::Validate
  property :id,               Serial
  property  :metallnummer,  String   #  alt Gusskost MetallNummer
  property  :neuemodellnr,  String   #  alt Gusskost neueModellNr
  property  :fremdbestellnr,  String   #  alt Gusskost FremdBestellNr
  property  :einheit,  String   #  alt Gusskost Einheit
  property  :lieferant,  String   #  alt Gusskost Lieferant
  property  :modellgruppe,  String   #  alt Gusskost Modellgruppe
  property  :metall,  String   #  alt Gusskost Metall
  property  :preisprostck,  String   #  alt Gusskost PreisProStck
  property  :giesserkosten,  String   #  alt Gusskost Giesserkosten
  property  :fremdgeldkosten,  String   #  alt Gusskost Fremdgeldkosten
  property  :effektaufpreis,  String   #  alt Gusskost effektAufpreis
  property  :lieferantnr,  String   # Unterschied zu Lieferant, LieferantenNr alt Gusskost LieferantNr
  property  :artikelnummer,  String   #  alt Gusskost Artikelnummer
  property  :lieferantennr,  String   # Worauf verweist diese? alt Gusskost LieferantenNr
end
beispiel=%(
0.0,9321-11,,,Ginko,9321,Kein,   0.00,,,   3.50,7,9321-1100-214,214
0.0,9320-11,,,Ginko,9320,Kein,   0.00,,,   3.60,7,9320-1100-214,214
0.0,9319-11,,,Ginko,9319,Kein,   0.00,,,   5.00,7,9319-1100-214,214
0.0,9318-11,,,Ginko,9318,Kein,   0.00,,,   5.00,7,9318-1100-214,214
0.0,9317-11,,,Ginko,9317,Kein,   0.00,,,   3.00,7,9317-1100-214,214
1.1,9450-11,,,,,Ag925,,   4.00,,  15.00,,9450-1110-019,
1.1,9448-11,9448-1 Ag925,,,,Ag925,,  35.00,, 125.00,,9448-1110-011,
1.1,9449-11,9449-1 Ag925,,,,Ag925,,  26.00,, 123.00,,9449-1110-011,
1.1,9447-11,Nr. 171 Ag925,,,,Ag925,,  40.00,, 112.00,,9447-1110-013,
)