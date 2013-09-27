class Contact
  include DataMapper::Resource
#  belongs_to :account
#  validates_presence_of :name
#  validates_presence_of :vorname
  validates_presence_of :adrNumIndex

  has n, :addresses,    :through => Resource
  has n, :contactInfos, :through => Resource

  # property <name>, <type>
  property :id, Serial
  property :adrNumIndex, String
  property :name, String
  property :vorname, String
  property :isPerson, Boolean
  property :titel, String
  property :bild1, String
  property :bild2, String
# Timestamp info
  property :created_at,   DateTime
  property :created_on,   Date
  property :updated_at,   DateTime
  property :updated_on,   Date
end
