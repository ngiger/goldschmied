class Personal
  include DataMapper::Resource
  # property <name>, <type>
  property :id, Serial
  property  :adrnum,  String   #  alt Personal AdrNum
  property  :adrzusatznr,  String   #  alt Personal AdrZusatzNr
  property  :adrnumindex,  String   #  alt Personal AdrNumIndex
  property  :kuerzel,  String   #  alt Personal Kürzel
  property  :geburtstag,  String   #  alt Personal Geburtstag
  property  :nationalitaet,  String   #  alt Personal Nationalität
  property  :konfession,  String   #  alt Personal Konfession
  property  :ahv_nummer,  String   #  alt Personal AHV_Nummer
  property  :bvg_nummer,  String   #  alt Personal BVG_Nummer
  property  :stellenantritt,  String   #  alt Personal Stellenantritt
  property  :stellenaustritt,  String   #  alt Personal Stellenaustritt
  property  :stundenansatz,  String   #  alt Personal Stundenansatz
  property  :zivilstand,  String   #  alt Personal Zivilstand
  property  :berufe,  String   #  alt Personal Berufe
  property  :lehre_von_bis,  String   #  alt Personal Lehre_von_bis
  property  :lehre_wo,  String   #  alt Personal Lehre_wo
  property  :bank01,  String   #  alt Personal Bank01
  property  :postcheque,  String   #  alt Personal Postcheque
  property  :heimatort,  String   #  alt Personal Heimatort
  property  :angestellt_als,  String   #  alt Personal Angestellt_als
  property  :sortier,  String   #  alt Personal Sortier
  property  :notiz,  String   #  alt Personal Notiz
end
beispiel = %(
7007, 1,7007.01,BRI,,CH,,536.69.744.117,,01.Mai.1989,28.Feb.1990,,ledig,Goldschmiedin,,,,,,,Keller Brigitte,
)

