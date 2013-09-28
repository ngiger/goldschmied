class Lagerblattposition
  include DataMapper::Resource
  include DataMapper::Validate

  # Properties
  property :id,               Serial
  property  :beschrieb,  String   #  alt Lglblpos BESCHRIEB
  property  :menge,  String   #  alt Lglblpos MENGE
  property  :preis_stk,  String   #  alt Lglblpos PREIS_STK
  property  :preis_tot,  String   # Ist das redundant? alt Lglblpos PREIS_TOT
  property  :lieferant,  String   #  alt Lglblpos LIEFERANT
  property  :lag_blatt_index,  String   #  alt Lglblpos LAG_BLATT_INDEX
  property  :pos_sort,  String   # ?? alt Lglblpos POS_SORT
  property  :lgblidxpos,  String   #  alt Lglblpos LGBLIDXPOS
  property  :artikelnummer,  String   #  alt Lglblpos Artikelnummer
  property  :einheit,  String   #  alt Lglblpos Einheit
  property  :lieferant_nr,  String   # Warum Lieferant und Lieferant_nr? alt Lglblpos LIEFERANT_NR
  property  :emgk,  String   #  alt Lglblpos EMGK
  property  :magk,  String   #  alt Lglblpos MaGK
  property  :vvgk,  String   #  alt Lglblpos VVGK
  property  :gewinnzu,  String   #  alt Lglblpos GEWINNZU
  property  :preis_emgk,  String   # Formel oder von Hand? alt Lglblpos PREIS_EMGK
  property  :preis_magk,  String   # Formel oder von Hand? alt Lglblpos PREIS_MaGK
  property  :preis_vvgk,  String   # Formel oder von Hand? alt Lglblpos PREIS_VVGK
  property  :preis_gewz,  String   # Formel oder von Hand? alt Lglblpos PREIS_GEWZ
end