#!/usr/bin/env ruby
#encoding utf-8
require 'csv'
require 'pp'
$: << File.join(File.dirname(File.dirname(__FILE__)), 'lib')
require 'data_schema'
require 'dm-types'

address_datei = '/opt/RolfMueller/export/Address01.csv'

inMemory   = DataMapper::setup(:default, File.join("sqlite3://#{Dir.pwd}/development.db"))
pp inMemory.select("PRAGMA synchronous = 0")
pp inMemory.select("PRAGMA journal_mode = off")
# pp inMemory.select("PRAGME page cache = 102400")
#  -- Turn the page cache up so it is large enough to hold the whole
#     database in the cache.
#  -- Turn the journal file off.
# 
#  -- Turn synchronous off.

require  'dm-migrations'
DataMapper.finalize
# DataMapper.auto_upgrade
DataMapper.auto_upgrade! # cleans tables
  
$defaultLanguage = 'de'
def addContactType(type, value, language = $defaultLanguage)
  begin
  contactType = ContactType.create(:type => type, :value => value, :language => language)
  rescue  => e
    puts "rescueing for contactType #{type} #{value}"
    puts "Error was #{e.inspect}"
  end
end
addContactType(:internet,     'Internet')
addContactType(:email,        'E-Mail')
addContactType(:fax,          'Fax')
addContactType(:mobile,       'Handy')
addContactType(:phone,        'Telefon')
puts "Created #{ContactType.all.size} contactTypes"

def addAdressType(type, value, language=$defaultLanguage)
  puts "addAdressType #{type} #{value}"
  addressType = AddressType.create(:type => type, :value => value, :language => language)
  puts addressType.save
  pp addressType
  rescue  => e
    puts "rescueing for addressType #{type} #{value}"
    puts "Error was #{e.inspect}"
end
addAdressType(:main,      'Hauptadresse')
addAdressType(:bill_to,   'Rechnungsadresse')
addAdressType(:delivery,  'Lieferadresse')
addAdressType(:other,     'Weitere Adresse')
puts "Created #{AddressType.all.size} addressTypes"

count = 0
nrSkips= 0
f = File.new(address_datei)
f.set_encoding(Encoding::ISO_8859_15, Encoding::UTF_8)

def addContactType(row, person, type, column)
  unless row[column].eql?('') 
    ContactInfo.create(:person_id => person.id, :type =>type, :value_1 => :row[column], :value_2 => :row[column+1])
  end
end

f.readlines.each {
  |line|
    begin
      row = line.force_encoding('utf-8').split(',')
      pp row.join('; ')
      count += 1
      unless /\d\d\d\d\.\d\d/.match(row[0])
        puts "\nSkipping row #{count}: #{row.join(',')}"
        nrSkips += 1
        next
      end
      person = Person.new       
      person.adrNumIndex   = row[0].strip
      unless row[1].eql?('') # Firma
        person.isPerson      = false
        person.vorname       = row[1] 
        person.name          = row[2]
        if row[4] != '' or row[5] != ''
          puts "Bin auf Firma mit Name/Vorname nicht vorbereitet #{row}"
#          break
        end
      else
        person.isPerson      = true
        person.vorname       = row[4] 
        person.name          = row[5]
      end      
      person.bild1 = row[55]
      person.bild2 = row[56]
      person.save
      if row[6] # 
        address = Address.new
        address.person_id     = person.id
        address.strasse = row[6]
        address.ortzusatz = row[7]
        address.staat = row[8]
        address.plz = row[9]
        address.ort = row[10]
        address.type = :main
        unless address.save
          puts "Konnte Adresse #{address.inspect} nicht speichern!"
          exit 2
        end
      end

      unless row[11].eql?('') # 
        address = Address.new
        address.person_id     = person.id
        address.text = row[11]
        address.strasse = row[12]
        address.po_box = row[13]
        address.staat = row[15]
        address.plz = row[16]
        address.ort = row[17]
        address.type = :delivery
        unless address.save
          puts "Konnte Adresse #{address.inspect} nicht speichern!"
          exit 2
        end
        # pp address; puts "Address neu gespeichert";  break
      end

      unless row[18].eql?('') # 
        address = Address.new
        address.person_id     = person.id
        address.text = row[18]
# address.adr02_firma = row[19]
# address.adr02firmzusatz = row[20]
# address.adr02_titel = row[21]
# address.adr02_vorname = row[22]
# address.adr02_name = row[23]
        address.strasse = row[24]
        address.po_box = row[25]
        address.staat = row[27]
        address.plz = row[28]
        address.ort = row[29]
        address.type = :bill_to
        unless address.save
          puts "Konnte Adresse #{address.inspect} nicht speichern!"
          exit 2
        end
        # pp address; puts "Address neu gespeichert";  break
      end

      addContactType(row, person, :phone, 30)
      addContactType(row, person, :phone, 32)
      addContactType(row, person, :phone, 34)
      addContactType(row, person, :phone, 36)
      addContactType(row, person, :fax, 38)
      addContactType(row, person, :fax, 53)
      addContactType(row, person, :mobile, 40)
      addContactType(row, person, :mobile, 42)
      addContactType(row, person, :email, 44)
      addContactType(row, person, :email, 46)
      addContactType(row, person, :email, 57)
      unless row[48].eql?('') 
        ContactInfo.create(:person_id => person.id, :type =>:internet, :value_1 => '', :value_2 => :row[48])
      end
      unless row[49].eql?('') 
        ContactInfo.create(:person_id => person.id, :type =>:internet, :value_1 => '', :value_2 => :row[49])
      end

# address.adrnum = row[50]
# address.code = row[51]
# address.sortier = row[52]

      unless person.save
        puts "Saving of row #{row} failed!"
        person.errors.each do |error|
            #print the name of the invalid attribute
            puts error.attribute_name
        end
        next
      end
      $stdout.write('.')
      $stdout.puts if count % 80 == 0
      # break unless $inMemory or count > 10
    rescue  => e
      puts "rescueing for row #{row}"
      puts "Error was #{e.inspect}"
      puts puts $@.join("\n")
      break
    end
}
puts "Skip #{nrSkips} of #{count} lines. Erfasste 
* #{sprintf('%4d', Person.all.size)} Kunden
* #{sprintf('%4d', Address.all.size)} Adressen und 
* #{sprintf('%4d', ContactInfo.all.size)} Kontakt-Informationen"
