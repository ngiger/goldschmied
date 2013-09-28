class Lagerbild
  
  include DataMapper::Resource
  include DataMapper::Validate

  # Properties
  property  :id,               Serial
  property  :lag_blatt_index,  String   #  alt Lagbild LAG_BLATT_INDEX
  property  :lagbild_tif,  String   # 345 MB Grösse. Separates .git-Repository mit git-annex alt Lagbild LAGBILD_TIF
  property  :artikelnummer,  String   #  alt Lagbild Artikelnummer

  bespiel=%(
1001.000869,C:\mueller2\bild_tif\1000\01000869.tif,1001-0008-69
1001.000877,C:\mueller2\bild_tif\1000\01000877.tif,1001-0008-77
1001.000899,C:\mueller2\bild_tif\1000\01000899.tif,1001-0008-99
1001.000902,C:\mueller2\bild_tif\1000\01000902.tif,1001-0009-02
1010.000132,C:\mueller2\bild_tif\1000\10000132.tif,1010-0001-32
1010.000135,C:\mueller2\bild_tif\1000\10000135.tif,1010-0001-35
1011.210002,C:\mueller2\bild_tif\1000\11210002.tif,1011-2100-02
1011.210006,C:\mueller2\bild_tif\1000\11210006.tif,1011-2100-06
1018.210002,C:\mueller2\bild_tif\1000\18210002.tif,1018-2100-02
)

end