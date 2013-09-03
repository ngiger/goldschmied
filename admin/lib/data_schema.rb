# more could be at http://datamapper.org/docs/dm_more/

# Adressen head /opt/RolfMueller/export/Address01.csv
# AdrNumIndex,Firma,Firmenzusatz,Titel,Vorname,Name,Strasse,Ortzusatz,Staat,PLZ,Ort,Postadr_Text,Postadr_Strasse,Postadr_PO_Box,PostadOrtzusatz,Postadr_Staat,Postadr_PLZ,Postadr_Ort,Adr02_Text,Adr02_Firma,Adr02Firmzusatz,Adr02_Titel,Adr02_Vorname,Adr02_Name,Adr02_Strasse,Adr02_PO_Box,Adr02_Ortzusatz,Adr02_Staat,Adr02_PLZ,Adr02_Ort,Tel01_von,Tel01_Nummer,Tel02_von,Tel02_Nummer,Tel03_von,Tel03_Nummer,Tel04_von,Tel04_Nummer,Fax01_von,Fax01_Nummer,Handy01_von,Handy01_Nummer,Handy02_von,Handy02_Nummer,Email01_von,Email01_Text,Email02_von,Email02_Text,Internet01,Internet02,AdrNum,Code,Sortier,Fax02_von,Fax02_Nummer,Bild1,Bild2,Email03_von,Email03_Text
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'

class Client
  include DataMapper::Resource
  has n, :addresses     , :required => false
  has n, :contactInfos  , :required => false

  property :id,           Serial     # primary serial key # AdrNumIndex  
  property :adrNumIndex,  String     # Rolf Muellers old id
  property :created_at,   DateTime
  property :created_on,   Date
  property :updated_at,   DateTime
  property :updated_on,   Date
  property :isPerson,     Boolean     # to distinguish between enterprises and humans
  property :titel,        String
  property :vorname,      String
  property :name,         String
  property :bild1,        String
  property :bild2,        String
    
end

# main, bill_to, delivery, other
class AddressType
  include DataMapper::Resource
  property :language,   String, :key => true, :length => 3 # ISO-Code
  property :id,         String, :key => true
  property :value,      String, :length => 32
end

class ContactType
  include DataMapper::Resource
  property :language,   String, :key => true, :length => 3 # ISO-Code
  property :id,         String, :key => true
  property :value,      String, :length => 32
end

# E-Mail, Fax, Mobile, etc
class ContactInfo
  include DataMapper::Resource
  belongs_to              :client,      :key => true
  has 1,                  :contactType, :key => true
  property :value_1,      String
  property :value_2,      String
end

class Address
  include DataMapper::Resource
  has       1,            :addressType
  belongs_to              :client

  property :id,           Serial
  property :created_at,   DateTime
  property :created_on,   Date
  property :updated_at,   DateTime
  property :updated_on,   Date
  
  property :titel,        String
  property :vorname,      String
  property :name,         String
  property :strasse,      String
  property :ortzusatz,    String
  property :staat,        String
  property :plz,          String
  property :ort,          String
end

