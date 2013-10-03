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
def init_database
  $defaultLanguage = 'de'
  file = Dir.glob("#{Dir.pwd}/db/*_development.db")[0]
  inMemory   = DataMapper::setup(:default, File.join("sqlite3://#{file}"))
  inMemory.select("PRAGMA synchronous = 0")
  inMemory.select("PRAGMA page_cache = 302400")
  DataMapper.finalize
  DataMapper.auto_upgrade! # leaves existing tables
end

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

def import_modelle(datei)
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
        modelle = Modelle.create(
                                  :langtext => row[0], 
                                  :neuemodellnr => row[1], 
                                  :bestellnr => row[2], 
                                  :einheit => row[3], 
                                  :kurzbeschrieb => row[4], 
                                  :lieferant => row[5], 
                                  :kommentar => row[6], 
                                  :modellgruppe => row[7], 
                                  :gummikosten => row[8], 
                                  :wanngummi => row[9], 
                                  :erwartetzahl => row[10], 
                                  :modellkosten => row[11], 
                                  :produktionsnr => row[12], 
                                  :kostengerechnet => row[13], 
                                  :modellgewicht => row[14], 
                                  :metall => row[15], 
                                  :effektaufpreis => row[16], 
                                  :lieferantennr => row[17], 
                                  :artikelnummer => row[18], 
                                  :kollektionsname => row[19], 
                                  :schmart1 => row[20], 
                                  :testfeld1 => row[21],                                  
                                       )
        rescue  => e
          puts "rescueing for Modelle #{row[0]} at line #{count} #{row.join(';')}"
          puts "Error was #{e.inspect}"
        end
      end 
  }
  puts "Importierte #{count} Modelle"
end

def import_Kunden(datei)
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
        lineitem = Kunden.create(
                                  :adrzusatznr => row[0], 
                                  :adrnumindex => row[1], 
                                  :sortier => row[2], 
                                  :preisstufe => row[3], 
                                  :kundenart => row[4], 
                                  :beruf01_von => row[5], 
                                  :beruf01_was => row[6], 
                                  :beruf02_von => row[7], 
                                  :beruf02_was => row[8], 
                                  :code => row[9], 
                                  :eingabedatum => row[10], 
                                  :notiz => row[11], 
                                  :erstkontakt_wo => row[12], 
                                  :erstkontak_wann => row[13], 
                                  :kundseitwann => row[14], 
                                  :selektion => row[15], 
                                  :mylieferantnr => row[16], 
                                  :auswahl1 => row[17], 
                                  :offenpendenz => row[18], 
                                  :jahrgang01_von => row[19], 
                                  :jahrgang01cirka => row[20], 
                                  :jahrgang02_von => row[21], 
                                  :jahrgang02cirka => row[22], 
                                  :post_ja_nein => row[23], 
                                       )
        rescue  => e
          puts "rescueing for Kunden #{row[0]} at line #{count} #{row.join(';')}"
          puts "Error was #{e.inspect}"
        end
      end 
  }
  puts "\nImportierte #{count} Kunden"
end

def import_Personal(datei)
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
        lineitem = Personal.create(
                                    :adrnum => row[0], 
                                    :adrzusatznr => row[1], 
                                    :adrnumindex => row[2], 
                                    :kuerzel => row[3], 
                                    :geburtstag => row[4], 
                                    :nationalitaet => row[5], 
                                    :konfession => row[6], 
                                    :ahv_nummer => row[7], 
                                    :bvg_nummer => row[8], 
                                    :stellenantritt => row[9], 
                                    :stellenaustritt => row[10], 
                                    :stundenansatz => row[11], 
                                    :zivilstand => row[12], 
                                    :berufe => row[13], 
                                    :lehre_von_bis => row[14], 
                                    :lehre_wo => row[15], 
                                    :bank01 => row[16], 
                                    :postcheque => row[17], 
                                    :heimatort => row[18], 
                                    :angestellt_als => row[19], 
                                    :sortier => row[20], 
                                    :notiz => row[21], 
                                       )
        rescue  => e
          puts "rescueing for Personal #{row[0]} at line #{count} #{row.join(';')}"
          puts "Error was #{e.inspect}"
        end
      end 
  }
  puts "Importierte #{count} Personal"
end

def import_Steinlager(datei)
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
        lineitem = Steinlager.create(
                                      :sortier => row[0], 
                                      :steingruppe => row[1], 
                                      :artikelnummer => row[2], 
                                      :sachet => row[3], 
                                      :vorrat => row[4], 
                                      :beschrieb => row[5], 
                                      :einheit => row[6], 
                                      :mateinh_preis => row[7], 
                                      :istmatpreis => row[8], 
                                      :momgewtot => row[9], 
                                      :gewichtpst => row[10], 
                                      :vk => row[11], 
                                      :beleg => row[12], 
                                      :lieferant => row[13], 
                                      :inventarwe => row[14], 
                                      :wievielret => row[15], 
                                      :vorratdatum => row[16], 
                                      :lieferantennr => row[17], 
                                      :datum => row[18], 
                                      :liefermenge => row[19], 
                                      :gebrauchtmenge => row[20], 
                                      :verlustmenge => row[21], 
                                      :preispro => row[22], 
                                      :kurzbeschrieb => row[23], 
                                      :preisprostck => row[24], 
                                      :gewichtmenge => row[25], 
                                      :artnrzusatz => row[26], 
                                      :fremdwaehrung => row[27], 
                                      :hinweis => row[28], 
                                      :steinname => row[29], 
                                      :selektion => row[30], 
                                      :sortier2 => row[31], 
                                      :lager2 => row[32], 
                                      :vorrat2 => row[33], 
                                      :lag2sum => row[34], 
                                      :invlag2 => row[35], 
                                       )
        rescue  => e
          puts "rescueing for Steinlager #{row[0]} at line #{count} #{row.join(';')}"
          puts "Error was #{e.inspect}"
        end
      end 
  }
  puts "Importierte #{count} Steinlager"
end

def import_LagerblattPosition(datei)
  count = 0
  f = File.new(datei)
  f.set_encoding(Encoding::ISO_8859_15, Encoding::UTF_8)
  inhalt = f.readlines
  nrMisses = 0
  puts "import_LagerblattPosition #{inhalt.size} lines from #{datei}"
  inhalt.each {
    |line|
      begin
        row = line.force_encoding('utf-8').split(',')
        count += 1
        begin
        lineitem = LagerblattPosition.create(
                                          :beschrieb => row[0], 
                                          :menge => row[1], 
                                          :preis_stk => row[2], 
                                          :preis_tot => row[3], 
                                          :lieferant => row[4], 
                                          :lag_blatt_index => row[5], 
                                          :pos_sort => row[6], 
                                          :lgblidxpos => row[7], 
                                          :artikelnummer => row[8], 
                                          :einheit => row[9], 
                                          :lieferant_nr => row[10], 
                                          :emgk => row[11], 
                                          :magk => row[12], 
                                          :vvgk => row[13], 
                                          :gewinnzu => row[14], 
                                          :preis_emgk => row[15], 
                                          :preis_magk => row[16], 
                                          :preis_vvgk => row[17], 
                                          :preis_gewz => row[18], 
                                       )
        rescue  => e
          puts "rescueing for LagerblattPosition #{row[0]} at line #{count} #{row.join(';')}"
          puts "Error was #{e.inspect}"
        end
      end
      if count % 100 == 0
        $stdout.write "."; $stdout.flush
      end
      if count % 8000 == 0
        puts "#{count}: #{row[0]}"
      end
  }
  puts "\nImportierte #{count} LagerblattPosition"
end

def import_Lagerblatt(datei)
  count = 0
  f = File.new(datei)
  f.set_encoding(Encoding::ISO_8859_15, Encoding::UTF_8)
  inhalt = f.readlines
  nrMisses = 0
  puts "import_Lagerblatt #{inhalt.size} lines from #{datei}"
  inhalt.each {
    |line|
      begin
        row = line.force_encoding('utf-8').split(',')
        count += 1
        begin
        lineitem = Lagerblatt.create(
                                      :lagernr => row[0], 
                                      :blatt => row[1], 
                                      :eingang => row[2], 
                                      :ausgang => row[3], 
                                      :kunde => row[4], 
                                      :anzahl => row[5], 
                                      :aufbeschrieb => row[6], 
                                      :mueller => row[7], 
                                      :ansatz => row[8], 
                                      :total_arbeit => row[9], 
                                      :inventarwert => row[10], 
                                      :zuschlag1 => row[11], 
                                      :ztotal => row[12], 
                                      :zuschlag_ => row[13], 
                                      :administrat => row[14], 
                                      :kalkpreis => row[15], 
                                      :grundpreis => row[16], 
                                      :vertriebfaktor => row[17], 
                                      :versfrgerechnet => row[18], 
                                      :versfrgerundet => row[19], 
                                      :ge_gp_ => row[20], 
                                      :gegerechnet => row[21], 
                                      :gegerundet => row[22], 
                                      :sachetnr => row[23], 
                                      :auftragnr => row[24], 
                                      :pos => row[25], 
                                      :grundpreis_stk => row[26], 
                                      :hinweis => row[27], 
                                      :versfrpreis => row[28], 
                                      :vkge => row[29], 
                                      :zuschlag_2 => row[30], 
                                      :zuschlag_groesse => row[31], 
                                      :kostenvoransch => row[32], 
                                      :sachetbeschrieb => row[33], 
                                      :gewichttot => row[34], 
                                      :gewichtstk => row[35], 
                                      :goldtot => row[36], 
                                      :goldstk => row[37], 
                                      :platintot => row[38], 
                                      :platinstk => row[39], 
                                      :silbertot => row[40], 
                                      :silberstk => row[41], 
                                      :bezandere => row[42], 
                                      :bezanderetot => row[43], 
                                      :bezanderestk => row[44], 
                                      :prozzuschl => row[45], 
                                      :adminstk => row[46], 
                                      :bezugs_groesse => row[47], 
                                      :groesse_stueck => row[48], 
                                      :textzu1 => row[49], 
                                      :textzu2 => row[50], 
                                      :archiv => row[51], 
                                      :vorrat => row[52], 
                                      :invent_x_vorat => row[53], 
                                      :aufgeloest => row[54], 
                                      :effektivpreis => row[55], 
                                      :preisstufe => row[56], 
                                      :preisliste => row[57], 
                                      :vorratdatum => row[58], 
                                      :mueller_x_ansatz => row[59], 
                                      :kundenum => row[60], 
                                      :gold_total_aktuell => row[61], 
                                      :pt_total_aktuell => row[62], 
                                      :ag_total_aktuell => row[63], 
                                      :andere_aktuell => row[64], 
                                      :selektion => row[65], 
                                      :berechengrundla => row[66], 
                                      :lag_blatt_index => row[67], 
                                      :lagbild => row[68], 
                                      :selektion2 => row[69], 
                                      :selektion2menge => row[70], 
                                      :wer03 => row[71], 
                                      :wer04 => row[72], 
                                      :anzahl_std03 => row[73], 
                                      :anzahl_std04 => row[74], 
                                      :ansatz_std_04 => row[75], 
                                      :ansatz_std_03 => row[76], 
                                      :stunden_pro_stueck => row[77], 
                                      :inventarwert_st => row[78], 
                                      :totalarbeit_st => row[79], 
                                      :gussmodell => row[80], 
                                      :kollektionsname => row[81], 
                                      :selek_wien => row[82], 
                                      :herstellxvorrat => row[83], 
                                      :kurzlagtext => row[84], 
                                      :stundentotal => row[85], 
                                      :faktorkatalog => row[86], 
                                      :kataloggrechnet => row[87], 
                                      :katalogerundet => row[88], 
                                      :katalogpreissfr => row[89], 
                                      :set1 => row[90], 
                                      :merkmal1 => row[91], 
                                      :merkmal2 => row[92], 
                                      :herstelproanzah => row[93], 
                                      :detbrdfaktor => row[94], 
                                      :sfrzueuro => row[95], 
                                      :detbrdgerundet => row[96], 
                                      :detbrdeuropreis => row[97], 
                                      :vereurogerundet => row[98], 
                                      :vereuropreis => row[99], 
                                      :freipreisfaktor => row[100], 
                                      :freipreisgerund => row[101], 
                                      :freivkpreis => row[102], 
                                      :freipreiswem => row[103], 
                                      :vkge_schluessel => row[104], 
                                      :mateinzelkost1 => row[105], 
                                      :auf_ls => row[106], 
                                      :auf_lswo => row[107], 
                                      :sumherst => row[108], 
                                      :katalwem => row[109], 
                                      :priveurfaktor => row[110], 
                                      :priveurgerech => row[111], 
                                      :priveurgerundet => row[112], 
                                      :priveurpreis => row[113], 
                                      :det_eur_schluessel => row[114], 
                                      :kalkschema => row[115], 
                                      :totarbeit_vvgk => row[116], 
                                      :totarbeit_gezu => row[117], 
                                      :herstellpreis => row[118], 
                                      :selbstkpreis => row[119], 
                                      :kalkkostpreis => row[120], 
                                      :totmatemgk => row[121], 
                                      :totmatmak => row[122], 
                                      :totmatvvgk => row[123], 
                                      :totmatgezu => row[124], 
                                      :mwst_ansatz => row[125], 
                                      :sumlsdet => row[126], 
                                      :schmuckart => row[127], 
                                      :seitenzahl => row[128], 
                                      :artikelnummer => row[129], 
                                      :albumpreispriv => row[130], 
                                      :albumpreisdet => row[131], 
                                      :de_vertrek2_eur => row[132], 
                                      :de_det_ek2_eur => row[133], 
                                      :de_detek_eurkey => row[134], 
                                      :de_det_vk2_eur => row[135], 
                                      :ch_vertrek2_chf => row[136], 
                                      :ch_det_ek2 => row[137], 
                                      :ch_det_ek_key => row[138], 
                                      :ch_det_vk2 => row[139], 
                                      :ch_my_endpreis2 => row[140], 
                                      :preis_wann_neu => row[141], 
                                       )
        rescue  => e
          puts "rescueing for Lagerblatt #{row[0]} at line #{count} #{row.join(';')}"
          puts "Error was #{e.inspect}"
        end
      end
      if count % 100 == 0
        $stdout.write "."; $stdout.flush
      end
      if count % 2000 == 0
        puts "#{count}: #{row[0]}"
      end
  }
  puts "\nImportierte #{count} Lagerblatt"
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

def addContactToPerson(row, person, type, column)
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

        addContactToPerson(row, person, :phone, 30)
        addContactToPerson(row, person, :phone, 32)
        addContactToPerson(row, person, :phone, 34)
        addContactToPerson(row, person, :phone, 36)
        addContactToPerson(row, person, :fax, 38)
        addContactToPerson(row, person, :fax, 53)
        addContactToPerson(row, person, :mobile, 40)
        addContactToPerson(row, person, :mobile, 42)
        addContactToPerson(row, person, :email, 44)
        addContactToPerson(row, person, :email, 46)
        addContactToPerson(row, person, :email, 57)
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
  puts "\nimport_address0: (Bin auf Firma mit Name/Vorname nicht vorbereitet) Fand es #{nrMisses} mal. Zum überdenken!"
  puts "Übersprang #{nrSkips} von #{count} Zeilen"
  puts "Erfasste 
  * #{sprintf('%4d', Contact.all.size)} Kunden
  * #{sprintf('%4d', Address.all.size)} Adressen und
  * #{sprintf('%4d', ContactInfo.all.size)} Kontakt-Informationen"
end

init_database
import_Personal('/opt/RolfMueller/export/personal.csv')

setupAdresstype
setup_contacttypes
import_address0
import_Kunden('/opt/RolfMueller/export/kunden.csv')
import_modelle('/opt/RolfMueller/export/modelle.csv')
import_gusskosten('/opt/RolfMueller/export/gusskost.csv')
import_materialliste('/opt/RolfMueller/export/matliste.csv')
import_Steinlager('/opt/RolfMueller/export/steinlag.csv')
import_LagerblattPosition('/opt/RolfMueller/export/lgblpos.csv')
import_Lagerblatt('/opt/RolfMueller/export/lagblatt.csv')

puts "\n\n"
puts "Zusammenfassung: Erfasste 
* #{sprintf('%4d', Contact.all.size)} Kunden
* #{sprintf('%4d', Address.all.size)} Adressen und
* #{sprintf('%4d', ContactInfo.all.size)} Kontakt-Informationen
* #{sprintf('%4d', Kunden.all.size)} Kunden
* #{sprintf('%4d', Personal.all.size)} Personal
* #{sprintf('%4d', Modelle.all.size)} Modelle
* #{sprintf('%4d', Gusskosten.all.size)} Gusskosten
* #{sprintf('%4d', Steinlager.all.size)} Steinlager
* #{sprintf('%4d', Materialliste.all.size)} Materialliste
* #{sprintf('%4d', LagerblattPosition.all.size)} LagerblattPosition
* #{sprintf('%4d', Lagerblatt.all.size)} Lagerblatt
(Ohne Lagbild)
"
