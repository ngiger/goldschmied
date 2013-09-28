class Kunden
  include DataMapper::Resource
  include DataMapper::Validate

  # Properties
  property  :id,               Serial
  property  :adrzusatznr,  String   #  alt Kunden AdrZusatzNr
  property  :adrnumindex,  String   #  alt Kunden AdrNumIndex
  property  :sortier,  String   # ?? alt Kunden Sortier
  property  :preisstufe,  String   #  alt Kunden Preisstufe
  property  :kundenart,  String   #  alt Kunden Kundenart
  property  :beruf01_von,  String   # ->Kontakt erweitern um Beruf alt Kunden Beruf01_von
  property  :beruf01_was,  String   #  alt Kunden Beruf01_was
  property  :beruf02_von,  String   #  alt Kunden Beruf02_von
  property  :beruf02_was,  String   #  alt Kunden Beruf02_was
  property  :code,  String   # ?? alt Kunden Code
  property  :eingabedatum,  String   #  alt Kunden Eingabedatum
  property  :notiz,  String   #  alt Kunden Notiz
  property  :erstkontakt_wo,  String   # -> Kontakt erweitern ?? alt Kunden Erstkontakt_Wo
  property  :erstkontak_wann,  String   #  alt Kunden Erstkontak_Wann
  property  :kundseitwann,  String   #  alt Kunden KundSeitWann
  property  :selektion,  String   # ?? alt Kunden Selektion
  property  :mylieferantnr,  String   # ?? alt Kunden MyLieferantNr
  property  :auswahl1,  String   # ?? alt Kunden Auswahl1
  property  :offenpendenz,  String   #  alt Kunden offenPendenz
  property  :jahrgang01_von,  String   # -> Kontakt erweitern um alt Kunden Jahrgang01_von
  property  :jahrgang01cirka,  String   #  alt Kunden Jahrgang01Cirka
  property  :jahrgang02_von,  String   #  alt Kunden Jahrgang02_von
  property  :jahrgang02cirka,  String   #  alt Kunden Jahrgang02Cirka
  property  :post_ja_nein,  Boolean   #  alt Kunden Post_Ja_Nein
end
inhalt =%(
AdrNum,AdrZusatzNr,AdrNumIndex,Sortier,Preisstufe,Kundenart,Beruf01_von,Beruf01_was,Beruf02_von,Beruf02_was,Code,Eingabedatum,Notiz,Erstkontakt_Wo,Erstkontak_Wann,KundSeitWann,Selektion,MyLieferantNr,Auswahl1,offenPendenz,Jahrgang01_von,Jahrgang01Cirka,Jahrgang02_von,Jahrgang02Cirka,Post_Ja_Nein
 1001,  1, 1001.01,Lager,,,,,,,,          ,024 025,,,          ,N,,,,,,,,
 1001,  2, 1001.02,nicht definiert,4,,,,,,,          ,"Adressen, die nicht in Adressdatei aufgenommen sind. Diese Nummer brauche ich im Lagerblatt. Z.B. fuer Offerten fuer Kunden, die ich (noch) nicht in Kundenkartei habe",,,          ,N,,,,,,,,
 1002,  1, 1002.01,Berechnungsgrundlagen,,,,,,,,          ,026 027,,,          ,N,,,,,,,,
 1003,  1, 1003.01,Sammelverkauf,,,,,,,,          ,029 030,,,          ,N,,,,,,,,
 1004,  1, 1004.01,Fremdarbeiten,,,,,,,,01.01.1990,,,,          ,N,,,,,,,,
 1006,  1, 1006.01,Matthey-Doret,4,,,,,,003,22.03.2007,"Philippe + Elisabeth / Ehepaar, er gross, schlank, hellgraue Haare, sie hat feine Finger. Hatten Spass an Japan-Ringen. Habe sie angeschrieben am 30.3.2007",muba 2007,04.03.2007,,,,,,,,,,
 1007,  1, 1007.01,Zubler,,,,,,,,31.01.1991,Ex-Kompagnon von Alfons Wypraechtiger/,muba 1991,,          ,,,,,,,,,
 1008,  1, 1008.01,Sabino,4,,ihm,eidg. dipl.Bauleiter,,,003 005,21.01.2008,"mit Hr. Gaetano Sabino hatte ich Kontakt, weil er ein Inserat im NvM schalten will.",telefonisch,18.01.2008,          ,,,,,,,,,
)