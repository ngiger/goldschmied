#!/usr/bin/env ruby
#encoding utf-8
require 'csv'
require 'pp'
$: << File.join(File.dirname(File.dirname(__FILE__)), 'lib')
require 'data_schema'
require 'dm-types'

$inMemory = true
unless $inMemory
  puts "using development.db"
  DataMapper::setup(:default, File.join('sqlite3://', Dir.pwd, 'development.db'))
else
  DataMapper.setup(:default, 'sqlite::memory:')
end
# A Postgres connection:
# DataMapper.setup(:default, 'postgres://user:password@hostname/database')

DataMapper.finalize
require  'dm-migrations'
# DataMapper.auto_upgrade
DataMapper.auto_upgrade!
#  AdrNumIndex
#  Firma
#  Firmenzusatz
#  Titel
#  Vorname
#  Name
#  Strasse
#  Ortzusatz
#  Staat
#  PLZ
#  Ort

#  Postadr_Text
#  Postadr_Strasse
#  Postadr_PO_Box
#  PostadOrtzusatz
#  Postadr_Staat
#  Postadr_PLZ
#  Postadr_Ort

#  Adr02_Text
#  Adr02_Firma
#  Adr02Firmzusatz
#  Adr02_Titel
#  Adr02_Vorname
#  Adr02_Name
#  Adr02_Strasse
#  Adr02_PO_Box
#  Adr02_Ortzusatz
#  Adr02_Staat
#  Adr02_PLZ
#  Adr02_Ort

#  Tel01_von
#  Tel01_Nummer
#  Tel02_von
#  Tel02_Nummer
#  Tel03_von
#  Tel03_Nummer
#  Tel04_von
#  Tel04_Nummer
#  Fax01_von
#  Fax01_Nummer
#  Handy01_von
#  Handy01_Nummer
#  Handy02_von
#  Handy02_Nummer
#  Email01_von
#  Email01_Text
#  Email02_von
#  Email02_Text

#  Internet01
#  Internet02
#  AdrNum
#  Code
#  Sortier
#  Fax02_von
#  Fax02_Nummer
#  Bild1
#  Bild2
#  Email03_von
#  Email03_Text
#  

$defaultLanguage = 'de'
def addContactType(id, value, language = $defaultLanguage)
  contactType = ContactType.new
  contactType.language = language
  contactType.id = id
  contactType.value = value
end
addContactType(:internet,     'Internet')
addContactType(:email,        'E-Mail')
addContactType(:fax,          'Fax')
addContactType(:mobile,       'Handy')
addContactType(:phone,        'Telefon')

def addAdressType(id, value, language=$defaultLanguage)
  addressType = AddressType.new
  addressType.language = language
  addressType.id = id
  addressType.value = value
end
addAdressType(:main,      'Hauptadresse')
addAdressType(:bill_to,   'Rechnungsadresse')
addAdressType(:delivery,  'Lieferadresse')
addAdressType(:other,     'Weitere Adresse')


address_datei = '/opt/RolfMueller/export/Address01.csv'
count = 0
nrSkips= 0
f = File.new(address_datei)
f.set_encoding(Encoding::ISO_8859_15, Encoding::UTF_8)

f.readlines.each {
  |line|
    begin
      row = line.force_encoding('utf-8').split(',')
      count += 1
      unless /\d\d\d\d\.\d\d/.match(row[0])
        puts "\nSkipping row #{count}: #{row.join(',')}"
        nrSkips += 1
        next
      end
      address = Address.new  
      address.client_id     = address.adrNumIndex
      address.vorname       = row[4] 
      address.name          = row[5]
      pp row[0..5]
      pp address
      unless address.save
        puts "Saving of row #{row} failed!"
        address.errors.each do |error|
            #print the name of the invalid attribute
            puts error.attribute_name
        end
        next
      end
      $stdout.write('.')
      $stdout.puts if count % 80 == 0
      break unless $inMemory or count > 10
    rescue  => e
      puts "rescueing"
      puts "Error was #{e.inspect}"
      break
    end
}
puts "Skip #{nrSkips} of #{count} lines"
pp Address.all.size
pp Address.all.first
puts 'done'
