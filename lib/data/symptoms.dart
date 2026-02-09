// Araç Arıza Semptomları Veritabanı - Genişletilmiş Türkiye Versiyonu

class Symptom {
  final String id;
  final String name;
  final String description;
  final String category;
  final String? severity; // low, medium, high, critical
  final List<String>? relatedParts;

  const Symptom({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.severity,
    this.relatedParts,
  });
}

class SymptomCategory {
  final String name;
  final String icon;
  final List<Symptom> symptoms;

  const SymptomCategory({
    required this.name,
    required this.icon,
    required this.symptoms,
  });
}

final List<SymptomCategory> symptomCategories = [
  // ======= MOTOR SESLERİ =======
  SymptomCategory(name: 'Motor Sesleri', icon: 'engine', symptoms: [
    Symptom(
        id: 'motor_vuruntu',
        name: 'Motor Vuruntu Sesi',
        description: 'Motordan metalik vuruntu sesi geliyor',
        category: 'Motor Sesleri',
        severity: 'high',
        relatedParts: ['Krank mili', 'Biyel kolu', 'Piston']),
    Symptom(
        id: 'motor_citirti',
        name: 'Motor Cıtırtı Sesi',
        description: 'Motordan cıtırtı veya tıkırtı sesi',
        category: 'Motor Sesleri',
        severity: 'medium',
        relatedParts: ['Supap', 'Hidrolik itici']),
    Symptom(
        id: 'kayis_gicirti',
        name: 'Kayış Gıcırtısı',
        description: 'V kayışından gıcırtı sesi',
        category: 'Motor Sesleri',
        severity: 'low',
        relatedParts: ['V kayışı', 'Gergi rulmanı', 'Alternatör']),
    Symptom(
        id: 'supap_sesi',
        name: 'Supap Takırtısı',
        description: 'Motor üstünden takırtı sesi',
        category: 'Motor Sesleri',
        severity: 'medium',
        relatedParts: ['Supap ayarı', 'Hidrolik itici', 'Eksantrik']),
    Symptom(
        id: 'turbo_sesi',
        name: 'Turbo Islık Sesi',
        description: 'Turbodan anormal ıslık sesi',
        category: 'Motor Sesleri',
        severity: 'medium',
        relatedParts: ['Turbo', 'Intercooler hortumu']),
    Symptom(
        id: 'turbo_ugultu',
        name: 'Turbo Uğultusu',
        description: 'Turbodan metal uğultu sesi',
        category: 'Motor Sesleri',
        severity: 'high',
        relatedParts: ['Turbo şaft', 'Turbo rulman']),
    Symptom(
        id: 'motor_islama',
        name: 'Motor Islak Ses',
        description: 'Motordan ıslak/püskürtme sesi',
        category: 'Motor Sesleri',
        severity: 'medium',
        relatedParts: ['Enjektör', 'Yakıt sistemi']),
    Symptom(
        id: 'motor_tik_tak',
        name: 'Tik-Tak Sesi',
        description: 'Motordan düzenli tik-tak sesi',
        category: 'Motor Sesleri',
        severity: 'medium',
        relatedParts: ['Enjektör', 'Supap']),
    Symptom(
        id: 'triger_sesi',
        name: 'Triger Kayış/Zincir Sesi',
        description: 'Motordan hışırtı veya zincir sesi',
        category: 'Motor Sesleri',
        severity: 'high',
        relatedParts: ['Triger kayışı', 'Triger zinciri', 'Gergi']),
    Symptom(
        id: 'motor_homurtu',
        name: 'Motor Homurtusu',
        description: 'Motordan düşük frekanslı homurtu',
        category: 'Motor Sesleri',
        severity: 'medium',
        relatedParts: ['Egzoz manifoldu', 'Motor takozu']),
    Symptom(
        id: 'soguk_motor_sesi',
        name: 'Soğuk Motorda Ses',
        description: 'Motor soğukken anormal ses, ısınınca geçiyor',
        category: 'Motor Sesleri',
        severity: 'low',
        relatedParts: ['Hidrolik itici', 'Yağ pompası']),
    Symptom(
        id: 'motor_patirtisi',
        name: 'Motor Patırtısı',
        description: 'Motordan patlama benzeri ses',
        category: 'Motor Sesleri',
        severity: 'high',
        relatedParts: ['Ateşleme sistemi', 'Yakıt sistemi']),
    Symptom(
        id: 'alterator_ses',
        name: 'Alternatör Sesi',
        description: 'Alternatörden vınlama sesi',
        category: 'Motor Sesleri',
        severity: 'medium',
        relatedParts: ['Alternatör', 'Rulman']),
    Symptom(
        id: 'klima_kompresor_ses',
        name: 'Klima Kompresör Sesi',
        description: 'Klima açınca metalik ses',
        category: 'Motor Sesleri',
        severity: 'medium',
        relatedParts: ['Klima kompresörü', 'Kavrama']),
  ]),

  // ======= FREN SİSTEMİ =======
  SymptomCategory(name: 'Fren Sistemi', icon: 'brake', symptoms: [
    Symptom(
        id: 'fren_gicirti',
        name: 'Fren Gıcırtısı',
        description: 'Fren yapınca gıcırtı sesi',
        category: 'Fren Sistemi',
        severity: 'low',
        relatedParts: ['Fren balatası', 'Fren diski']),
    Symptom(
        id: 'fren_titreme',
        name: 'Fren Titremesi',
        description: 'Fren yapınca direksiyon titriyor',
        category: 'Fren Sistemi',
        severity: 'medium',
        relatedParts: ['Fren diski', 'Disk tornası']),
    Symptom(
        id: 'fren_metal',
        name: 'Fren Metal Sesi',
        description: 'Frenden metal sürtünme sesi',
        category: 'Fren Sistemi',
        severity: 'high',
        relatedParts: ['Fren balatası', 'Fren diski']),
    Symptom(
        id: 'fren_cekme',
        name: 'Fren Çekme',
        description: 'Fren yapınca araç sağa veya sola çekiyor',
        category: 'Fren Sistemi',
        severity: 'high',
        relatedParts: ['Fren kaliperi', 'Fren hortumu']),
    Symptom(
        id: 'fren_pedal_sert',
        name: 'Sert Fren Pedalı',
        description: 'Fren pedalı çok sert',
        category: 'Fren Sistemi',
        severity: 'high',
        relatedParts: ['Vakum pompası', 'Servo fren']),
    Symptom(
        id: 'fren_pedal_yumusak',
        name: 'Yumuşak Fren Pedalı',
        description: 'Fren pedalı çok yumuşak/dibe gidiyor',
        category: 'Fren Sistemi',
        severity: 'critical',
        relatedParts: ['Fren hidroliği', 'Merkez pompa', 'Hava kabarcığı']),
    Symptom(
        id: 'fren_uyari',
        name: 'Fren Uyarı Lambası',
        description: 'Fren uyarı lambası yanıyor',
        category: 'Fren Sistemi',
        severity: 'high',
        relatedParts: ['Fren hidroliği', 'Sensör', 'ABS']),
    Symptom(
        id: 'abs_aktif',
        name: 'ABS Devamlı Aktif',
        description: 'ABS düşük hızda bile devreye giriyor',
        category: 'Fren Sistemi',
        severity: 'high',
        relatedParts: ['ABS sensörü', 'Tekerlek hız sensörü']),
    Symptom(
        id: 'abs_uyari',
        name: 'ABS Uyarı Lambası',
        description: 'ABS uyarı lambası yanıyor',
        category: 'Fren Sistemi',
        severity: 'high',
        relatedParts: ['ABS sensörü', 'ABS modülü']),
    Symptom(
        id: 'fren_koku',
        name: 'Fren Kokusu',
        description: 'Frenden yanık kokusu geliyor',
        category: 'Fren Sistemi',
        severity: 'high',
        relatedParts: ['Fren kaliperi', 'El freni']),
    Symptom(
        id: 'el_freni_tutmuyor',
        name: 'El Freni Tutmuyor',
        description: 'El freni aracı tutmuyor',
        category: 'Fren Sistemi',
        severity: 'medium',
        relatedParts: ['El freni teli', 'Kampana']),
    Symptom(
        id: 'esp_uyari',
        name: 'ESP/Stabilite Uyarısı',
        description: 'ESP uyarı lambası yanıyor',
        category: 'Fren Sistemi',
        severity: 'medium',
        relatedParts: ['ESP sensörü', 'Direksiyon açı sensörü']),
  ]),

  // ======= SÜSPANSİYON =======
  SymptomCategory(name: 'Süspansiyon', icon: 'suspension', symptoms: [
    Symptom(
        id: 'susp_gicirdama',
        name: 'Süspansiyon Gıcırdaması',
        description: 'Çukurda veya virajda gıcırdama sesi',
        category: 'Süspansiyon',
        severity: 'medium',
        relatedParts: ['Rotil', 'Salıncak burcu']),
    Symptom(
        id: 'susp_takirdama',
        name: 'Takırdama Sesi',
        description: 'Bozuk yolda takırdama sesi',
        category: 'Süspansiyon',
        severity: 'medium',
        relatedParts: ['Amortisör', 'Viraj demir lastiği']),
    Symptom(
        id: 'susp_sert',
        name: 'Sert Süspansiyon',
        description: 'Araç çok sert gidiyor, her çukur hissediliyor',
        category: 'Süspansiyon',
        severity: 'medium',
        relatedParts: ['Amortisör', 'Yay']),
    Symptom(
        id: 'susp_yumusak',
        name: 'Yumuşak Süspansiyon',
        description: 'Araç çok sallanıyor',
        category: 'Süspansiyon',
        severity: 'medium',
        relatedParts: ['Amortisör', 'Yay']),
    Symptom(
        id: 'arac_yatiyor',
        name: 'Araç Yatıyor',
        description: 'Virajda araç çok yatıyor',
        category: 'Süspansiyon',
        severity: 'medium',
        relatedParts: ['Viraj demiri', 'Amortisör']),
    Symptom(
        id: 'on_susp_ses',
        name: 'Ön Süspansiyon Sesi',
        description: 'Ön taraftan takırtı/gıcırtı',
        category: 'Süspansiyon',
        severity: 'medium',
        relatedParts: ['Rotil', 'Rot başı', 'Salıncak']),
    Symptom(
        id: 'arka_susp_ses',
        name: 'Arka Süspansiyon Sesi',
        description: 'Arka taraftan ses geliyor',
        category: 'Süspansiyon',
        severity: 'medium',
        relatedParts: ['Amortisör', 'Arka dingil burcu']),
    Symptom(
        id: 'susp_gurultu',
        name: 'Süspansiyon Gürültüsü',
        description: 'Yolda sürekli gürültü',
        category: 'Süspansiyon',
        severity: 'medium',
        relatedParts: ['Tekerlek rulmanı', 'Amortisör']),
    Symptom(
        id: 'arac_cekiyor',
        name: 'Araç Sağa/Sola Çekiyor',
        description: 'Düz yolda araç kendiliğinden çekiyor',
        category: 'Süspansiyon',
        severity: 'medium',
        relatedParts: ['Rot ayarı', 'Lastik basıncı', 'Ön düzen']),
    Symptom(
        id: 'lastik_asimetrik',
        name: 'Asimetrik Lastik Aşınması',
        description: 'Lastikler düzensiz aşınmış',
        category: 'Süspansiyon',
        severity: 'medium',
        relatedParts: ['Ön düzen ayarı', 'Rotil', 'Salıncak']),
    Symptom(
        id: 'sekme',
        name: 'Araç Sekme Yapıyor',
        description: 'Fren veya gaza basınca sekme oluyor',
        category: 'Süspansiyon',
        severity: 'high',
        relatedParts: ['Ön düzen', 'Amortisör', 'Salıncak burcu']),
    Symptom(
        id: 'tekerlek_gurultusu',
        name: 'Tekerlek Gürültüsü',
        description: 'Tekerleklerden vınlama/uğultu',
        category: 'Süspansiyon',
        severity: 'medium',
        relatedParts: ['Tekerlek rulmanı', 'Lastik']),
  ]),

  // ======= ŞANZIMAN =======
  SymptomCategory(name: 'Şanzıman', icon: 'transmission', symptoms: [
    Symptom(
        id: 'sanziman_atlama',
        name: 'Vites Atlama',
        description: 'Vites kendiliğinden atlıyor',
        category: 'Şanzıman',
        severity: 'high',
        relatedParts: ['Şanzıman senkromeç', 'Vites kolu']),
    Symptom(
        id: 'sanziman_takilma',
        name: 'Vites Takılma',
        description: 'Vites geçişi zor oluyor',
        category: 'Şanzıman',
        severity: 'medium',
        relatedParts: ['Debriyaj', 'Şanzıman yağı', 'Senkromeç']),
    Symptom(
        id: 'sanziman_ses',
        name: 'Şanzıman Uğultusu',
        description: 'Viteste uğultu sesi',
        category: 'Şanzıman',
        severity: 'medium',
        relatedParts: ['Şanzıman rulman', 'Dişli']),
    Symptom(
        id: 'debriyaj_kayma',
        name: 'Debriyaj Kayması',
        description: 'Devriye basınca motor devir alıyor ama hız artmıyor',
        category: 'Şanzıman',
        severity: 'high',
        relatedParts: ['Debriyaj balatası', 'Debriyaj seti']),
    Symptom(
        id: 'debriyaj_agir',
        name: 'Ağır Debriyaj',
        description: 'Debriyaj pedalı çok ağır',
        category: 'Şanzıman',
        severity: 'medium',
        relatedParts: ['Debriyaj teli', 'Debriyaj merkez pompası']),
    Symptom(
        id: 'debriyaj_titreme',
        name: 'Debriyaj Titremesi',
        description: 'Kalkışta titreme oluyor',
        category: 'Şanzıman',
        severity: 'medium',
        relatedParts: ['Volan', 'Debriyaj seti']),
    Symptom(
        id: 'geri_vites_ses',
        name: 'Geri Vites Sesi',
        description: 'Geri viteste gürültü',
        category: 'Şanzıman',
        severity: 'medium',
        relatedParts: ['Senkromeç', 'Şanzıman dişlisi']),
    Symptom(
        id: 'oto_vites_gecmiyor',
        name: 'Otomatik Vites Geçmiyor',
        description: 'Otomatik şanzıman vites geçmiyor',
        category: 'Şanzıman',
        severity: 'high',
        relatedParts: ['Şanzıman yağı', 'Solenoid', 'TCM']),
    Symptom(
        id: 'oto_vites_atlama',
        name: 'Otomatik Vites Sert Geçiş',
        description: 'Vites geçişlerinde sarsıntı',
        category: 'Şanzıman',
        severity: 'medium',
        relatedParts: ['Şanzıman yağı', 'Tork konvertör']),
    Symptom(
        id: 'oto_acil_mod',
        name: 'Otomatik Şanzıman Acil Mod',
        description: 'Şanzıman acil moda geçti (limp mode)',
        category: 'Şanzıman',
        severity: 'critical',
        relatedParts: ['TCM', 'Sensör', 'Solenoid']),
    Symptom(
        id: 'cvt_gurultu',
        name: 'CVT Gürültüsü',
        description: 'CVT şanzımandan vınlama',
        category: 'Şanzıman',
        severity: 'medium',
        relatedParts: ['CVT kayışı', 'CVT yağı']),
    Symptom(
        id: 'dsg_titreme',
        name: 'DSG Titreme',
        description: 'DSG şanzımanda düşük hızda titreme',
        category: 'Şanzıman',
        severity: 'medium',
        relatedParts: ['DSG kavrama', 'Mekatronik']),
  ]),

  // ======= EGZOZ SİSTEMİ =======
  SymptomCategory(name: 'Egzoz Sistemi', icon: 'exhaust', symptoms: [
    Symptom(
        id: 'egzoz_ses',
        name: 'Yüksek Egzoz Sesi',
        description: 'Egzozdan yüksek ses geliyor',
        category: 'Egzoz',
        severity: 'medium',
        relatedParts: ['Egzoz borusu', 'Susturucu']),
    Symptom(
        id: 'egzoz_duman_beyaz',
        name: 'Beyaz Duman',
        description: 'Egzozdan beyaz duman çıkıyor',
        category: 'Egzoz',
        severity: 'high',
        relatedParts: ['Conta', 'Silindir kapağı', 'Antifriz kaçağı']),
    Symptom(
        id: 'egzoz_duman_siyah',
        name: 'Siyah Duman',
        description: 'Egzozdan siyah duman çıkıyor',
        category: 'Egzoz',
        severity: 'medium',
        relatedParts: ['Enjektör', 'Hava filtresi', 'Turbo']),
    Symptom(
        id: 'egzoz_duman_mavi',
        name: 'Mavi Duman',
        description: 'Egzozdan mavimsi duman çıkıyor',
        category: 'Egzoz',
        severity: 'high',
        relatedParts: ['Segman', 'Supap keçesi', 'Turbo']),
    Symptom(
        id: 'egzoz_koku',
        name: 'Egzoz Kokusu',
        description: 'İçeriye egzoz kokusu geliyor',
        category: 'Egzoz',
        severity: 'high',
        relatedParts: ['Egzoz kaçağı', 'Conta']),
    Symptom(
        id: 'katalitik_ses',
        name: 'Katalitik Ses',
        description: 'Katalitik konvertörden çıngırak sesi',
        category: 'Egzoz',
        severity: 'medium',
        relatedParts: ['Katalitik konvertör']),
    Symptom(
        id: 'dpf_doldu',
        name: 'DPF Uyarısı',
        description: 'DPF/Partikül filtresi uyarısı',
        category: 'Egzoz',
        severity: 'high',
        relatedParts: ['DPF', 'Kurum birikimi']),
    Symptom(
        id: 'egzoz_patlamasi',
        name: 'Egzoz Patlaması',
        description: 'Egzozdan patlama sesi (geri tepme)',
        category: 'Egzoz',
        severity: 'medium',
        relatedParts: ['Ateşleme', 'Yakıt sistemi']),
    Symptom(
        id: 'egr_ariza',
        name: 'EGR Arızası',
        description: 'Check Engine + düzensiz rölanti',
        category: 'Egzoz',
        severity: 'medium',
        relatedParts: ['EGR valfi', 'Karbon birikimi']),
    Symptom(
        id: 'adblue_uyari',
        name: 'AdBlue Uyarısı',
        description: 'AdBlue seviyesi düşük uyarısı',
        category: 'Egzoz',
        severity: 'medium',
        relatedParts: ['AdBlue deposu', 'SCR sistemi']),
  ]),

  // ======= MOTOR PERFORMANS =======
  SymptomCategory(name: 'Motor Performans', icon: 'performance', symptoms: [
    Symptom(
        id: 'perf_guc_kaybi',
        name: 'Güç Kaybı',
        description: 'Motor eski gücünü vermiyor',
        category: 'Performans',
        severity: 'medium',
        relatedParts: ['Turbo', 'Yakıt sistemi', 'Filtreler']),
    Symptom(
        id: 'perf_rolanti',
        name: 'Düzensiz Rölanti',
        description: 'Rölantide motor titriyor veya düzensiz',
        category: 'Performans',
        severity: 'medium',
        relatedParts: ['Bobin', 'Buji', 'Enjektör']),
    Symptom(
        id: 'perf_calistirma',
        name: 'Çalıştırma Zorluğu',
        description: 'Motor zor çalışıyor',
        category: 'Performans',
        severity: 'medium',
        relatedParts: ['Akü', 'Marş motoru', 'Yakıt pompası']),
    Symptom(
        id: 'perf_stop',
        name: 'Motor Stop Ediyor',
        description: 'Motor beklenmedik şekilde duruyor',
        category: 'Performans',
        severity: 'high',
        relatedParts: ['Yakıt pompası', 'Sensör', 'İmmobilizer']),
    Symptom(
        id: 'perf_yakit',
        name: 'Yüksek Yakıt Tüketimi',
        description: 'Yakıt tüketimi normalin üzerinde',
        category: 'Performans',
        severity: 'medium',
        relatedParts: ['Lambda sensörü', 'Hava filtresi', 'Lastik basıncı']),
    Symptom(
        id: 'perf_hizlanma',
        name: 'Hızlanma Sorunu',
        description: 'Gaza basınca tepki gecikiyor',
        category: 'Performans',
        severity: 'medium',
        relatedParts: ['Gaz kelebeği', 'MAF sensörü', 'Yakıt filtresi']),
    Symptom(
        id: 'perf_misfire',
        name: 'Ateşleme Hatası (Misfire)',
        description: 'Motor sarsılıyor, ateşleme kaçırıyor',
        category: 'Performans',
        severity: 'high',
        relatedParts: ['Buji', 'Bobin', 'Enjektör']),
    Symptom(
        id: 'perf_kesik',
        name: 'Motor Kesik Kesik Çalışıyor',
        description: 'Motor düzensiz, kesik kesik çalışıyor',
        category: 'Performans',
        severity: 'high',
        relatedParts: ['Yakıt sistemi', 'Ateşleme', 'Sensör']),
    Symptom(
        id: 'soguk_calismiyor',
        name: 'Soğukta Çalışmıyor',
        description: 'Soğuk havalarda motor zor çalışıyor',
        category: 'Performans',
        severity: 'medium',
        relatedParts: ['Akü', 'Kızdırma bujisi', 'Yakıt']),
    Symptom(
        id: 'sicak_calismiyor',
        name: 'Sıcakta Çalışmıyor',
        description: 'Motor ısınınca çalışmıyor',
        category: 'Performans',
        severity: 'high',
        relatedParts: ['Marş motoru', 'Yakıt buharlaşması']),
    Symptom(
        id: 'motor_surumeme',
        name: 'Motor Yavaş Sürüm Modu',
        description: 'Araç acil moda geçti (limp mode)',
        category: 'Performans',
        severity: 'critical',
        relatedParts: ['Turbo', 'Sensör', 'ECU']),
    Symptom(
        id: 'motor_titreme',
        name: 'Motor Titremesi',
        description: 'Motor duruyorken bile titriyor',
        category: 'Performans',
        severity: 'medium',
        relatedParts: ['Motor takozu', 'Ateşleme', 'Rölanti valfi']),
    Symptom(
        id: 'tersepme',
        name: 'Geri Tepme (Backfire)',
        description: 'Gaza basınca motor geri tepiyor',
        category: 'Performans',
        severity: 'high',
        relatedParts: ['Ateşleme zamanı', 'Supap ayarı', 'Yakıt sistemi']),
    Symptom(
        id: 'check_engine',
        name: 'Check Engine Lambası',
        description: 'Motor arıza lambası yanıyor',
        category: 'Performans',
        severity: 'high',
        relatedParts: ['Çeşitli sensörler', 'Emisyon sistemi']),
  ]),

  // ======= ELEKTRİK SİSTEMİ =======
  SymptomCategory(name: 'Elektrik Sistemi', icon: 'electric', symptoms: [
    Symptom(
        id: 'elektrik_aku',
        name: 'Akü Şarj Sorunu',
        description: 'Akü şarj olmuyor veya boşalıyor',
        category: 'Elektrik',
        severity: 'high',
        relatedParts: ['Akü', 'Alternatör', 'Şarj kablosu']),
    Symptom(
        id: 'elektrik_far',
        name: 'Far Titremesi',
        description: 'Farlar titriyor veya kararsız',
        category: 'Elektrik',
        severity: 'medium',
        relatedParts: ['Alternatör', 'Kablo bağlantısı']),
    Symptom(
        id: 'elektrik_uyari',
        name: 'Gösterge Işıkları',
        description: 'Birden fazla uyarı lambası yanıyor',
        category: 'Elektrik',
        severity: 'high',
        relatedParts: ['Akü', 'Toprak kablosu', 'CAN bus']),
    Symptom(
        id: 'elektrik_calistirmama',
        name: 'Marş Basmıyor',
        description: 'Kontak çevirince hiç tepki yok',
        category: 'Elektrik',
        severity: 'critical',
        relatedParts: ['Akü', 'Marş motoru', 'Kontak']),
    Symptom(
        id: 'elektrik_mars_ses',
        name: 'Marş Sesi Var Çalışmıyor',
        description: 'Marş dönüyor ama motor çalışmıyor',
        category: 'Elektrik',
        severity: 'high',
        relatedParts: ['Yakıt pompası', 'Buji', 'Sensör']),
    Symptom(
        id: 'elektrik_cam',
        name: 'Elektrikli Cam Çalışmıyor',
        description: 'Camlar açılmıyor/kapanmıyor',
        category: 'Elektrik',
        severity: 'low',
        relatedParts: ['Cam motoru', 'Sigorta', 'Düğme']),
    Symptom(
        id: 'elektrik_merkezi',
        name: 'Merkezi Kilit Sorunu',
        description: 'Merkezi kilit çalışmıyor',
        category: 'Elektrik',
        severity: 'low',
        relatedParts: ['Kilit motoru', 'Sigorta', 'Kumanda']),
    Symptom(
        id: 'elektrik_klima',
        name: 'Klima Çalışmıyor',
        description: 'Klima soğutmuyor',
        category: 'Elektrik',
        severity: 'low',
        relatedParts: ['Kompresör', 'Freon', 'Sigorta']),
    Symptom(
        id: 'elektrik_fan',
        name: 'İç Mekan Fanı Çalışmıyor',
        description: 'Kalorifer/klima fanı çalışmıyor',
        category: 'Elektrik',
        severity: 'low',
        relatedParts: ['Fan motoru', 'Rezistans', 'Sigorta']),
    Symptom(
        id: 'elektrik_gosterge',
        name: 'Gösterge Arızası',
        description: 'Göstergeler yanlış değer gösteriyor',
        category: 'Elektrik',
        severity: 'medium',
        relatedParts: ['Gösterge paneli', 'Sensör']),
    Symptom(
        id: 'elektrik_silecek',
        name: 'Silecek Çalışmıyor',
        description: 'Silecekler çalışmıyor',
        category: 'Elektrik',
        severity: 'medium',
        relatedParts: ['Silecek motoru', 'Sigorta', 'Kol']),
    Symptom(
        id: 'elektrik_anahtar',
        name: 'Anahtar Tanımıyor',
        description: 'Araç anahtarı tanımıyor',
        category: 'Elektrik',
        severity: 'high',
        relatedParts: ['İmmobilizer', 'Anahtar pili', 'Anten']),
    Symptom(
        id: 'elektrik_radyo',
        name: 'Radyo/Multimedya Sorunu',
        description: 'Radyo açılmıyor veya donuyor',
        category: 'Elektrik',
        severity: 'low',
        relatedParts: ['Teyp ünitesi', 'Sigorta']),
  ]),

  // ======= SOĞUTMA SİSTEMİ =======
  SymptomCategory(name: 'Soğutma Sistemi', icon: 'cooling', symptoms: [
    Symptom(
        id: 'sogutma_isinma',
        name: 'Aşırı Isınma',
        description: 'Motor sıcaklık ibresi kırmızıya çıkıyor',
        category: 'Soğutma',
        severity: 'critical',
        relatedParts: ['Termostat', 'Su pompası', 'Radyatör']),
    Symptom(
        id: 'sogutma_kacak',
        name: 'Antifriz Kaçağı',
        description: 'Antifriz seviyesi sürekli düşüyor',
        category: 'Soğutma',
        severity: 'high',
        relatedParts: ['Radyatör', 'Hortum', 'Su pompası']),
    Symptom(
        id: 'sogutma_fan',
        name: 'Fan Çalışmıyor',
        description: 'Soğutma fanı hiç çalışmıyor',
        category: 'Soğutma',
        severity: 'high',
        relatedParts: ['Fan motoru', 'Fan rölesi', 'Sensör']),
    Symptom(
        id: 'sogutma_isınmiyor',
        name: 'Motor Isınmıyor',
        description: 'Motor uzun süre ısınmıyor',
        category: 'Soğutma',
        severity: 'medium',
        relatedParts: ['Termostat']),
    Symptom(
        id: 'sogutma_buhar',
        name: 'Kaputtan Buhar',
        description: 'Kaputtan buhar/duman çıkıyor',
        category: 'Soğutma',
        severity: 'critical',
        relatedParts: ['Radyatör', 'Hortum', 'Kapak']),
    Symptom(
        id: 'sogutma_koku',
        name: 'Tatlı Koku',
        description: 'Antifriz kokusu içeriye geliyor',
        category: 'Soğutma',
        severity: 'medium',
        relatedParts: ['Kalorifer peteği', 'Hortum']),
    Symptom(
        id: 'sogutma_basınc',
        name: 'Radyatör Basınç Sorunu',
        description: 'Radyatör hortumları şişik',
        category: 'Soğutma',
        severity: 'high',
        relatedParts: ['Radyatör kapağı', 'Conta']),
    Symptom(
        id: 'kalorifer_soguk',
        name: 'Kalorifer Soğuk Kalıyor',
        description: 'Kalorifer ısıtmıyor',
        category: 'Soğutma',
        severity: 'low',
        relatedParts: ['Kalorifer peteği', 'Termostat', 'Hava kilidi']),
    Symptom(
        id: 'fan_surekli',
        name: 'Fan Sürekli Çalışıyor',
        description: 'Soğutma fanı motor kapalıyken bile çalışıyor',
        category: 'Soğutma',
        severity: 'medium',
        relatedParts: ['Fan rölesi', 'ECT sensörü']),
  ]),

  // ======= DİREKSİYON =======
  SymptomCategory(name: 'Direksiyon', icon: 'steering', symptoms: [
    Symptom(
        id: 'direksiyon_agir',
        name: 'Ağır Direksiyon',
        description: 'Direksiyon çevirmesi zor, ağır',
        category: 'Direksiyon',
        severity: 'high',
        relatedParts: ['Direksiyon pompası', 'Hidrolik yağ', 'Kayış']),
    Symptom(
        id: 'direksiyon_titreme',
        name: 'Direksiyon Titremesi',
        description: 'Yüksek hızda direksiyon titriyor',
        category: 'Direksiyon',
        severity: 'medium',
        relatedParts: ['Balans', 'Rotil', 'Fren diski']),
    Symptom(
        id: 'direksiyon_oyun',
        name: 'Direksiyon Boşluğu',
        description: 'Direksiyonda fazla oyun/boşluk var',
        category: 'Direksiyon',
        severity: 'high',
        relatedParts: ['Kremayer', 'Rot başı', 'Direksiyon kutusu']),
    Symptom(
        id: 'direksiyon_ses',
        name: 'Direksiyon Sesi',
        description: 'Direksiyon çevirince ses geliyor',
        category: 'Direksiyon',
        severity: 'medium',
        relatedParts: ['Direksiyon pompası', 'Mafsal', 'Yağ seviyesi']),
    Symptom(
        id: 'direksiyon_cekme',
        name: 'Direksiyon Çekme',
        description: 'Araç direksiyonu bir tarafa çekiyor',
        category: 'Direksiyon',
        severity: 'medium',
        relatedParts: ['Rot ayarı', 'Lastik basıncı']),
    Symptom(
        id: 'direksiyon_kilit',
        name: 'Direksiyon Kilitleniyor',
        description: 'Direksiyon bazen kilitleniyor',
        category: 'Direksiyon',
        severity: 'critical',
        relatedParts: ['Direksiyon kutusu', 'EPS motoru']),
    Symptom(
        id: 'eps_uyari',
        name: 'EPS/Elektrikli Direksiyon Uyarısı',
        description: 'Direksiyon uyarı lambası yanıyor',
        category: 'Direksiyon',
        severity: 'high',
        relatedParts: ['EPS motoru', 'Sensör', 'ECU']),
    Symptom(
        id: 'direksiyon_donmuyor',
        name: 'Direksiyon Ortalanmıyor',
        description: 'Virajdan sonra direksiyon geri dönmüyor',
        category: 'Direksiyon',
        severity: 'medium',
        relatedParts: ['Ön düzen', 'Kremayer']),
  ]),

  // ======= KAPI VE KAPORTA =======
  SymptomCategory(name: 'Kapı ve Kaporta', icon: 'door', symptoms: [
    Symptom(
        id: 'kapi_kapanmiyor',
        name: 'Kapı Kapanmıyor',
        description: 'Kapı düzgün kapanmıyor',
        category: 'Kaporta',
        severity: 'low',
        relatedParts: ['Kilit mekanizması', 'Menteşe']),
    Symptom(
        id: 'kapi_ses',
        name: 'Kapı Gıcırdaması',
        description: 'Kapı açılırken/kapanırken gıcırdıyor',
        category: 'Kaporta',
        severity: 'low',
        relatedParts: ['Menteşe', 'Yağlama']),
    Symptom(
        id: 'bagaj_kapanmiyor',
        name: 'Bagaj Kapanmıyor',
        description: 'Bagaj kapağı düzgün kapanmıyor',
        category: 'Kaporta',
        severity: 'low',
        relatedParts: ['Kilit', 'Amortisör']),
    Symptom(
        id: 'kaput_acilmiyor',
        name: 'Kaput Açılmıyor',
        description: 'Kaput açma kolu çalışmıyor',
        category: 'Kaporta',
        severity: 'low',
        relatedParts: ['Kaput teli', 'Kilit']),
    Symptom(
        id: 'cam_sizinti',
        name: 'Cam Kenarından Su Sızıntısı',
        description: 'Yağmurda içeri su giriyor',
        category: 'Kaporta',
        severity: 'low',
        relatedParts: ['Cam fitili', 'Conta']),
    Symptom(
        id: 'sunroof_sizinti',
        name: 'Sunroof Sızıntısı',
        description: 'Sunrooftan su sızıyor',
        category: 'Kaporta',
        severity: 'medium',
        relatedParts: ['Sunroof tahliyesi', 'Conta']),
    Symptom(
        id: 'ruzgar_sesi',
        name: 'Rüzgar Sesi',
        description: 'Yüksek hızda rüzgar sesi',
        category: 'Kaporta',
        severity: 'low',
        relatedParts: ['Kapı contası', 'Ayna', 'Cam fitili']),
  ]),

  // ======= YAKIT SİSTEMİ =======
  SymptomCategory(name: 'Yakıt Sistemi', icon: 'fuel', symptoms: [
    Symptom(
        id: 'yakit_koku',
        name: 'Benzin/Mazot Kokusu',
        description: 'Araçta yakıt kokusu var',
        category: 'Yakıt',
        severity: 'high',
        relatedParts: ['Yakıt hattı', 'Enjektör', 'Yakıt kapağı']),
    Symptom(
        id: 'yakit_gosterge',
        name: 'Yakıt Göstergesi Yanlış',
        description: 'Yakıt göstergesi doğru göstermiyor',
        category: 'Yakıt',
        severity: 'low',
        relatedParts: ['Yakıt sensörü', 'Gösterge']),
    Symptom(
        id: 'yakit_pompa_ses',
        name: 'Yakıt Pompası Sesi',
        description: 'Kontak açınca vızıltı sesi',
        category: 'Yakıt',
        severity: 'medium',
        relatedParts: ['Yakıt pompası']),
    Symptom(
        id: 'yakit_kesinti',
        name: 'Yakıt Kesintisi',
        description: 'Seyir halinde güç kesintisi',
        category: 'Yakıt',
        severity: 'high',
        relatedParts: ['Yakıt filtresi', 'Yakıt pompası', 'Enjektör']),
    Symptom(
        id: 'lpg_gecmiyor',
        name: 'LPG\'ye Geçmiyor',
        description: 'Araç LPG\'ye geçmiyor',
        category: 'Yakıt',
        severity: 'medium',
        relatedParts: ['LPG ECU', 'Sıcaklık sensörü', 'Enjektör']),
    Symptom(
        id: 'lpg_ses',
        name: 'LPG\'de Ses',
        description: 'LPG\'de çalışırken anormal ses',
        category: 'Yakıt',
        severity: 'medium',
        relatedParts: ['LPG enjektör', 'Regülatör']),
  ]),

  // ======= LASTİK VE JANT =======
  SymptomCategory(name: 'Lastik ve Jant', icon: 'tire', symptoms: [
    Symptom(
        id: 'lastik_basinc',
        name: 'Düşük Lastik Basıncı',
        description: 'Lastik basıncı sürekli düşüyor',
        category: 'Lastik',
        severity: 'medium',
        relatedParts: ['Lastik', 'Sibop', 'Jant']),
    Symptom(
        id: 'lastik_asinma',
        name: 'Düzensiz Lastik Aşınması',
        description: 'Lastikler eşit aşınmıyor',
        category: 'Lastik',
        severity: 'medium',
        relatedParts: ['Rot ayarı', 'Amortisör', 'Balans']),
    Symptom(
        id: 'lastik_titreme',
        name: 'Lastik Titremesi',
        description: 'Belirli hızda titreme',
        category: 'Lastik',
        severity: 'medium',
        relatedParts: ['Balans', 'Jant']),
    Symptom(
        id: 'lastik_patlak',
        name: 'Lastik Patlağı',
        description: 'Lastik patlamış veya yırtık',
        category: 'Lastik',
        severity: 'critical',
        relatedParts: ['Lastik']),
    Symptom(
        id: 'jant_cizik',
        name: 'Jant Hasarı',
        description: 'Jantta çizik veya çatlak',
        category: 'Lastik',
        severity: 'medium',
        relatedParts: ['Jant']),
    Symptom(
        id: 'tpms_uyari',
        name: 'TPMS Uyarısı',
        description: 'Lastik basınç uyarı lambası',
        category: 'Lastik',
        severity: 'medium',
        relatedParts: ['TPMS sensörü', 'Lastik basıncı']),
  ]),

  // ======= AYNA VE CAM =======
  SymptomCategory(name: 'Ayna ve Cam', icon: 'mirror', symptoms: [
    Symptom(
        id: 'ayna_titriyor',
        name: 'Ayna Titremesi',
        description: 'Yan ayna yüksek hızda titriyor',
        category: 'Ayna/Cam',
        severity: 'low',
        relatedParts: ['Ayna mekanizması']),
    Symptom(
        id: 'ayna_kapanmiyor',
        name: 'Elektrikli Ayna Çalışmıyor',
        description: 'Ayna açılmıyor/kapanmıyor',
        category: 'Ayna/Cam',
        severity: 'low',
        relatedParts: ['Ayna motoru', 'Sigorta']),
    Symptom(
        id: 'cam_bugulanma',
        name: 'Cam Buğulanması',
        description: 'Camlar sürekli buğulanıyor',
        category: 'Ayna/Cam',
        severity: 'low',
        relatedParts: ['Klima filtresi', 'Hava çıkışı']),
    Symptom(
        id: 'cam_catladı',
        name: 'Ön Cam Çatlağı',
        description: 'Ön camda çatlak var',
        category: 'Ayna/Cam',
        severity: 'medium',
        relatedParts: ['Ön cam']),
    Symptom(
        id: 'isitma_calismiyor',
        name: 'Arka Cam Isıtma Çalışmıyor',
        description: 'Arka cam rezistansı çalışmıyor',
        category: 'Ayna/Cam',
        severity: 'low',
        relatedParts: ['Rezistans', 'Sigorta']),
  ]),
];

List<Symptom> getAllSymptoms() {
  return symptomCategories.expand((cat) => cat.symptoms).toList();
}

List<Symptom> searchSymptoms(String query) {
  final searchTerm = query.toLowerCase();
  return getAllSymptoms()
      .where((symptom) =>
          symptom.name.toLowerCase().contains(searchTerm) ||
          symptom.description.toLowerCase().contains(searchTerm) ||
          symptom.category.toLowerCase().contains(searchTerm))
      .toList();
}

List<Symptom> getSymptomsByCategory(String category) {
  final cat = symptomCategories.firstWhere(
    (c) => c.name == category,
    orElse: () => SymptomCategory(name: '', icon: '', symptoms: []),
  );
  return cat.symptoms;
}

List<Symptom> getSymptomsBySeverity(String severity) {
  return getAllSymptoms().where((s) => s.severity == severity).toList();
}

int getTotalSymptomCount() {
  return getAllSymptoms().length;
}
