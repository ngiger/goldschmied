#!/usr/bin/env ruby
#encoding utf-8
require 'csv'
require 'pp'
require 'dm-types'
require 'dm-validations'
require 'dm-timestamps'

models = Dir.glob('models/*.rb')
models.each{ |model| require File.expand_path(model) }

require  'dm-migrations'
# DataMapper.auto_migrate! # cleans tables
#def init_database
  $defaultLanguage = 'de'
  file = Dir.glob("#{Dir.pwd}/db/*_development.db")[0]
  inMemory   = DataMapper::setup(:default, File.join("sqlite3://#{file}"))
  inMemory.select("PRAGMA synchronous = 0")
  # inMemory.select("PRAGMA page cache = 102400")
  DataMapper.finalize
  DataMapper.auto_upgrade! # leaves existing tables
#end
#init_database

def import_materialliste(datei)
  count = 0
  f = File.new(datei)
  f.set_encoding(Encoding::ISO_8859_15, Encoding::UTF_8)
  inhalt = f.read
  inhalt.gsub!(/\n",/, '",') # Patches for lines like SV-45 which contain cr/lf"
  nrMisses = 0
  inhalt.split("\n").each {
    |line|
      begin
        row = line.force_encoding('utf-8').split(',')
        count += 1
        begin
        picture_path = row[4].gsub('\\', '/')    
        material = Materialliste.create(
                                          :description => row[0], 
                                          :price_per_unit => row[1], 
                                          :unit => row[2], 
                                          :article_number => row[3], 
                                          :picture => File.basename(picture_path), 
                                          :emgk => row[5], 
                                          :magk => row[6], 
                                          :vvgk => row[7], 
                                          :gewinn_zuschlag => row[8],
                                        )
        rescue  => e
          puts "rescueing for Materialliste #{description} at line #{count} #{row.join(';')}"
          puts "Error was #{e.inspect}"
        end
      end 
  }
  puts "Importierte #{count} materiallisten"
end

def import_gusskosten(datei)
  count = 0
  f = File.new(datei)
  f.set_encoding(Encoding::ISO_8859_15, Encoding::UTF_8)
  inhalt = f.read
  nrMisses = 0
  inhalt.split("\n").each {
    |line|
      begin
        row = line.force_encoding('utf-8').split(',')
        count += 1
        begin
        picture_path = row[4].gsub('\\', '/')    
        gusskosten = Gusskosten.create(
                                        :metallnummer => row[0], 
                                        :neuemodellnr => row[1], 
                                        :fremdbestellnr => row[2], 
                                        :einheit => row[3], 
                                        :lieferant => row[4], 
                                        :modellgruppe => row[5], 
                                        :metall => row[6], 
                                        :preisprostck => row[7], 
                                        :giesserkosten => row[8], 
                                        :fremdgeldkosten => row[9], 
                                        :effektaufpreis => row[10], 
                                        :lieferantnr => row[11], 
                                        :artikelnummer => row[12], 
                                        :lieferantennr => row[13],
                                       )
        rescue  => e
          puts "rescueing for Gusskosten #{metallnummer} at line #{count} #{row.join(';')}"
          puts "Error was #{e.inspect}"
        end
      end 
  }
  puts "Importierte #{count} Gusskosten"
end

def addContacttype(type, value, language = $defaultLanguage)
  begin
  contact_t = Contacttype.create(:type => type, :value => value, :language => language)
  rescue  => e
    puts "rescueing for contacttype #{type} #{value}"
    puts "Error was #{e.inspect}"
  end
end

def setup_contacttypes
  addContacttype(:internet,     'Internet')
  addContacttype(:email,        'E-Mail')
  addContacttype(:fax,          'Fax')
  addContacttype(:mobile,       'Handy')
  addContacttype(:phone,        'Telefon')
  pp Contacttype.all
  puts "Created #{Contacttype.all.size} contacttypes"
  exit 1 unless Contacttype.all.size == 5
end

def addAdresstype(type, value, language=$defaultLanguage)
  Addresstype.create(:type => type, :value => value, :language => language)
  rescue  => e
    puts "rescueing for Addresstype #{type} #{value}"
    puts "Error was #{e.inspect}"
end

def setupAdresstype
  addAdresstype(:main,      'Hauptadresse')
  addAdresstype(:bill_to,   'Rechnungsadresse')
  addAdresstype(:delivery,  'Lieferadresse')
  addAdresstype(:other,     'Weitere Adresse')
  pp Addresstype.all
  puts "Created #{Addresstype.all.size} Addresstypes"
  exit 1 unless Addresstype.all.size == 4
end

def addContacttype(row, person, type, column)
  unless row[column].eql?('') 
    info = ContactInfo.create(:contact_id => person.id, :type =>type, :value_1 => :row[column], :value_2 => :row[column+1])
    unless info and info.save
      puts "#{__LINE__}: Konnte ContactInfo für #{person.id} #{person.adrNumIndex} #{type} '#{row[column]}' '#{row[column+1]}' nicht speichern! \n#{info.inspect}"
      info.errors.each do |e| puts e end
      exit 2
    end
  end
end

def saveAddress(person, type, strasse, ortzusatz, staat, plz, ort)
    address = Address.create( :contact_id    =>person.id,
                              :type=>type, # type.to_s,
                              :strasse=>strasse,
                              :ortzusatz=>ortzusatz,
                              :staat=>staat,
                              :plz=>plz,
                              :ort=>ort)
    unless address.save
      puts "#{__LINE__}: Konnte Adresse #{address.inspect} nicht speichern!"
      exit 2
    end    
  rescue  => e
    puts "#{__LINE__}: Konnte Adresse #{address.inspect} nicht speichern!"
    puts "rescueing for Address #{person.id} t #{type} s #{strasse} oz #{ortzusatz} #{staat} plz #{plz} o #{ort}"
    puts e
    exit 2
end

def import_address0(address_datei = '/opt/RolfMueller/export/Address01.csv')
  count = 0
  nrSkips= 0
  f = File.new(address_datei)
  f.set_encoding(Encoding::ISO_8859_15, Encoding::UTF_8)
  nrMisses = 0
  f.readlines.each {
    |line|
      begin
        row = line.force_encoding('utf-8').split(',')
        pp row.join('; ') if $VERBOSE
        count += 1
        unless /\d\d\d\d\.\d\d/.match(row[0])
          puts "\nSkipping row #{count}: #{row.join(',')}"
          nrSkips += 1
          next
        end
        person = Contact.new  
  #      person.account_id    = 1
        person.adrNumIndex   = row[0].strip
        unless row[1].eql?('') # Firma
          person.isPerson      = false
          person.vorname       = row[1] 
          person.name          = row[2]
          if row[4] != '' or row[5] != ''
            nrMisses += 1
            puts "#{__LINE__}: csv Zeile #{count}: Bin auf Firma mit Name/Vorname nicht vorbereitet #{row}" if $VERBOSE
  #          break
          end
        else
          person.isPerson      = true
          person.vorname       = row[4] 
          person.name          = row[5]
        end      
        person.bild1 = row[55]
        person.bild2 = row[56]
        unless person.save
          puts "#{__LINE__}: csv Zeile #{count}: Konnte Person #{person.inspect} nicht speichern!"
          exit 2
        end
        if row[6] # 
        # saveAddress(person, type, strasse, ortzusatz, staat, plz, ort)
          saveAddress(person, :main, row[6], row[7], row[7], row[9], row[10])
        end

        unless row[11].eql?('') # 
        # saveAddress(person, type, strasse, ortzusatz, staat, plz, ort)
          saveAddress(person, :delivery, row[12], row[13], row[15], row[16], row[17])
  #        address.text = row[11]
  #        address.po_box = row[13]
        end

        unless row[18].eql?('') # 
        # saveAddress(person, type, strasse, ortzusatz, staat, plz, ort)
          saveAddress(person, :bill_to, row[24], row[25] ?  'Postfach '+ row[25] : '', row[27], row[28], row[29])
  # address.text = row[18]
  # address.adr02_firma = row[19]
  # address.adr02firmzusatz = row[20]
  # address.adr02_titel = row[21]
  # address.adr02_vorname = row[22]
  # address.adr02_name = row[23]
        end

        addContacttype(row, person, :phone, 30)
        addContacttype(row, person, :phone, 32)
        addContacttype(row, person, :phone, 34)
        addContacttype(row, person, :phone, 36)
        addContacttype(row, person, :fax, 38)
        addContacttype(row, person, :fax, 53)
        addContacttype(row, person, :mobile, 40)
        addContacttype(row, person, :mobile, 42)
        addContacttype(row, person, :email, 44)
        addContacttype(row, person, :email, 46)
        addContacttype(row, person, :email, 57)
        unless row[48].eql?('') 
          ContactInfo.create(:contact_id => person.id, :type =>:internet, :value_1 => '', :value_2 => :row[48])
        end
        unless row[49].eql?('') 
          ContactInfo.create(:contact_id => person.id, :type =>:internet, :value_1 => '', :value_2 => :row[49])
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
end

# import_materialliste('/opt/RolfMueller/export/matliste.csv')
import_gusskosten('/opt/RolfMueller/export/gusskost.csv')
setupAdresstype
pp __LINE__
setup_contacttypes
pp __LINE__
import_address0
pp __LINE__
puts "\n\n"
puts " (Bin auf Firma mit Name/Vorname nicht vorbereitet) Fand es #{nrMisses} mal. Zum überdenken!"
puts "Skip #{nrSkips} of #{count} lines. Erfasste 
* #{sprintf('%4d', Contact.all.size)} Kunden
* #{sprintf('%4d', Address.all.size)} Adressen und 
* #{sprintf('%4d', ContactInfo.all.size)} Kontakt-Informationen"
