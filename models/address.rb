class Address
  include DataMapper::Resource

  belongs_to :contact
#  has       1,            :addresstype, :through => Resource
  validates_presence_of :type
#  validates_presence_of :ort
  # Timestamp info  
  property :created_at,   DateTime
  property :created_on,   Date
  property :updated_at,   DateTime
  property :updated_on,   Date

  # property <name>, <type>
  property :id, Serial
  property :type, Enum[ :main, :bill_to, :delivery, :other ], :default => :main
  property :text, String
  property :po_box, String
  property :strasse, String
  property :ortzusatz, String
  property :staat, String
  property :plz, String
  property :ort, String
end
