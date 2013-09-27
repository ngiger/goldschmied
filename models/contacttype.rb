
  class Contacttype
    include DataMapper::Resource
    property :id,         Serial
    property :type,       Enum[ :internet, :email, :fax, :mobile, :phone ], :unique_index => :unique_type
    property :language,   String, :length =>  3, :unique_index => :unique_type, :auto_validation => true, :default => 'de' # ISO-Code
    property :value,      String, :length => 32, :default => 'dummy'
  end
  