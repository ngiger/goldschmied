class ContactInfo
  include DataMapper::Resource

  property :created_at,   DateTime
  property :created_on,   Date
  property :updated_at,   DateTime
  property :updated_on,   Date
  belongs_to              :contact

  # property <name>, <type>
  property :id, Serial
  property :type,       Enum[ :internet, :email, :fax, :mobile, :phone], :default => :internet
  property :value_1, String
  property :value_2, String
end
