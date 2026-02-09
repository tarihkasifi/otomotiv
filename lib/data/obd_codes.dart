// OBD-II Hata Kodları Veritabanı - Genişletilmiş Türkiye Versiyonu
import 'dart:ui';

class OBDCode {
  final String code;
  final String description;
  final String category;
  final String severity; // low, medium, high, critical
  final List<String> possibleCauses;
  final String? detailedExplanation;
  final List<String>? affectedBrands; // Hangi markalarda sık görülür

  const OBDCode({
    required this.code,
    required this.description,
    required this.category,
    required this.severity,
    required this.possibleCauses,
    this.detailedExplanation,
    this.affectedBrands,
  });
}

// Marka bazlı özel arıza kodları
class BrandSpecificCode {
  final String brandCode;
  final String genericCode;
  final String brand;
  final String description;
  final String detailedCause;
  final String solution;
  final String estimatedCost;

  const BrandSpecificCode({
    required this.brandCode,
    required this.genericCode,
    required this.brand,
    required this.description,
    required this.detailedCause,
    required this.solution,
    required this.estimatedCost,
  });
}

final List<OBDCode> obdCodes = [
  // ======= ATEŞLEMEStSTEMİ =======
  OBDCode(
    code: 'P0300',
    description: 'Rastgele/Çoklu Silindir Ateşleme Hatası',
    category: 'Ateşleme',
    severity: 'high',
    possibleCauses: [
      'Bujiler aşınmış',
      'Ateşleme bobini arızalı',
      'Yakıt enjektörleri kirli',
      'Düşük yakıt basıncı',
      'Vakum kaçağı'
    ],
    detailedExplanation:
        'Motor birden fazla silindirde düzensiz yanma tespit ediyor. Bu durum motor sarsıntısına ve güç kaybına neden olur.',
    affectedBrands: ['Tüm markalar'],
  ),
  OBDCode(
    code: 'P0301',
    description: '1. Silindir Ateşleme Hatası',
    category: 'Ateşleme',
    severity: 'high',
    possibleCauses: [
      '1. silindir bujisi arızalı',
      'Ateşleme bobini arızalı',
      'Enjektör tıkalı',
      'Supap ayarı bozuk'
    ],
    detailedExplanation:
        'Birinci silindirde yanma gerçekleşmiyor veya düzensiz.',
  ),
  OBDCode(
    code: 'P0302',
    description: '2. Silindir Ateşleme Hatası',
    category: 'Ateşleme',
    severity: 'high',
    possibleCauses: [
      '2. silindir bujisi arızalı',
      'Ateşleme bobini arızalı',
      'Enjektör tıkalı'
    ],
  ),
  OBDCode(
    code: 'P0303',
    description: '3. Silindir Ateşleme Hatası',
    category: 'Ateşleme',
    severity: 'high',
    possibleCauses: [
      '3. silindir bujisi arızalı',
      'Ateşleme bobini arızalı',
      'Enjektör tıkalı'
    ],
  ),
  OBDCode(
    code: 'P0304',
    description: '4. Silindir Ateşleme Hatası',
    category: 'Ateşleme',
    severity: 'high',
    possibleCauses: [
      '4. silindir bujisi arızalı',
      'Ateşleme bobini arızalı',
      'Enjektör tıkalı'
    ],
  ),

  // ======= OKSİJEN SENSÖRLERİ =======
  OBDCode(
    code: 'P0130',
    description: 'O2 Sensörü Devre Arızası (Bank 1 Sensör 1)',
    category: 'Emisyon',
    severity: 'medium',
    possibleCauses: [
      'Lambda sensörü arızalı',
      'Kablo hasarlı',
      'Konnektör oksitlenmiş',
      'ECU arızası'
    ],
    detailedExplanation:
        'Katalitik konvertör öncesi oksijen sensörü düzgün sinyal vermiyor.',
  ),
  OBDCode(
    code: 'P0131',
    description: 'O2 Sensörü Düşük Voltaj (Bank 1 Sensör 1)',
    category: 'Emisyon',
    severity: 'medium',
    possibleCauses: [
      'Lambda sensörü arızalı',
      'Fakir karışım',
      'Hava kaçağı',
      'Egzoz kaçağı'
    ],
  ),
  OBDCode(
    code: 'P0132',
    description: 'O2 Sensörü Yüksek Voltaj (Bank 1 Sensör 1)',
    category: 'Emisyon',
    severity: 'medium',
    possibleCauses: [
      'Lambda sensörü arızalı',
      'Zengin karışım',
      'Yakıt basıncı yüksek'
    ],
  ),
  OBDCode(
    code: 'P0133',
    description: 'O2 Sensörü Yavaş Tepki (Bank 1 Sensör 1)',
    category: 'Emisyon',
    severity: 'medium',
    possibleCauses: [
      'Eskimiş lambda sensörü',
      'Egzoz sızıntısı',
      'Yakıt kalitesi düşük'
    ],
    affectedBrands: ['Toyota', 'Honda', 'Hyundai'],
  ),
  OBDCode(
    code: 'P0420',
    description: 'Katalitik Konvertör Verimliliği Düşük (Bank 1)',
    category: 'Emisyon',
    severity: 'high',
    possibleCauses: [
      'Katalitik konvertör ömrünü tamamlamış',
      'O2 sensörü arızalı',
      'Motor iç yağ yakıyor',
      'Egzoz kaçağı'
    ],
    detailedExplanation:
        'Egzoz emisyon değerleri standartların üzerinde. Araç muayeneden geçmeyebilir.',
    affectedBrands: ['Tüm markalar - özellikle yüksek kilometreli araçlar'],
  ),

  // ======= HAVA SİSTEMİ (MAF/MAP/TPS) =======
  OBDCode(
    code: 'P0100',
    description: 'MAF Sensörü Devre Arızası',
    category: 'Hava Sistemi',
    severity: 'high',
    possibleCauses: [
      'MAF sensörü kirli veya arızalı',
      'Kablo kesik',
      'Sigorta atmış',
      'ECU arızası'
    ],
    detailedExplanation:
        'Kütle hava akış sensörü motorun çektiği hava miktarını ölçemez. Yakıt hesaplaması yanlış olur.',
    affectedBrands: ['BMW', 'Mercedes', 'Volkswagen'],
  ),
  OBDCode(
    code: 'P0101',
    description: 'MAF Sensörü Performans/Aralık Sorunu',
    category: 'Hava Sistemi',
    severity: 'medium',
    possibleCauses: [
      'MAF sensörü kirli',
      'Hava filtresi tıkalı',
      'Vakum kaçağı',
      'Hava kanalı yırtık'
    ],
    detailedExplanation:
        'MAF sensörü çalışıyor ama beklenen değerler dışında okuyor.',
  ),
  OBDCode(
    code: 'P0102',
    description: 'MAF Sensörü Düşük Giriş',
    category: 'Hava Sistemi',
    severity: 'medium',
    possibleCauses: ['MAF sensör arızalı', 'Vakum sızıntısı', 'Kablo sorunu'],
  ),
  OBDCode(
    code: 'P0103',
    description: 'MAF Sensörü Yüksek Giriş',
    category: 'Hava Sistemi',
    severity: 'medium',
    possibleCauses: ['MAF sensör arızalı', 'Kısa devre'],
  ),
  OBDCode(
    code: 'P0106',
    description: 'MAP Sensörü Performans Sorunu',
    category: 'Hava Sistemi',
    severity: 'medium',
    possibleCauses: [
      'MAP sensörü arızalı',
      'Vakum hortumu kaçak',
      'Turbo basınç sorunu'
    ],
    affectedBrands: ['Fiat', 'Renault', 'Peugeot'],
  ),
  OBDCode(
    code: 'P0120',
    description: 'Gaz Kelebeği Pozisyon Sensörü (TPS) Devre Arızası',
    category: 'Hava Sistemi',
    severity: 'high',
    possibleCauses: [
      'TPS arızalı',
      'Kablo hasarı',
      'Gaz kelebeği gövdesi kirli',
      'Konnektör oksitlenmiş'
    ],
    detailedExplanation:
        'Motor gaz pedalı pozisyonunu algılayamıyor. Acil müdahale gerekir.',
  ),
  OBDCode(
    code: 'P0121',
    description: 'TPS Performans Sorunu',
    category: 'Hava Sistemi',
    severity: 'medium',
    possibleCauses: ['TPS aşınmış', 'Gaz kelebeği kirli', 'Kablo gevşek'],
  ),
  OBDCode(
    code: 'P0122',
    description: 'TPS Düşük Giriş',
    category: 'Hava Sistemi',
    severity: 'high',
    possibleCauses: ['TPS arızalı', 'Toprak bağlantısı zayıf'],
  ),

  // ======= SOĞUTMA SİSTEMİ =======
  OBDCode(
    code: 'P0115',
    description: 'Motor Sıcaklık Sensörü (ECT) Devre Arızası',
    category: 'Soğutma',
    severity: 'medium',
    possibleCauses: [
      'ECT sensörü arızalı',
      'Kablo hasarı',
      'Konnektör oksitli'
    ],
    detailedExplanation:
        'Motor sıcaklık sensörü çalışmıyor. Motor ısınma durumu algılanamaz.',
  ),
  OBDCode(
    code: 'P0116',
    description: 'ECT Sensörü Performans Sorunu',
    category: 'Soğutma',
    severity: 'medium',
    possibleCauses: [
      'Termostat arızalı',
      'Sensör arızalı',
      'Antifriz seviyesi düşük'
    ],
    affectedBrands: ['Opel', 'Ford', 'Renault'],
  ),
  OBDCode(
    code: 'P0117',
    description: 'ECT Sensörü Düşük Giriş',
    category: 'Soğutma',
    severity: 'medium',
    possibleCauses: ['Sensör kısa devre', 'Kablo hasarlı'],
  ),
  OBDCode(
    code: 'P0118',
    description: 'ECT Sensörü Yüksek Giriş',
    category: 'Soğutma',
    severity: 'medium',
    possibleCauses: ['Sensör açık devre', 'Kablo kopuk'],
  ),
  OBDCode(
    code: 'P0125',
    description: 'Kapalı Döngü Yakıt Kontrolü İçin Yetersiz Soğutma Sıcaklığı',
    category: 'Soğutma',
    severity: 'medium',
    possibleCauses: [
      'Termostat açık kalmış',
      'ECT sensörü arızalı',
      'Düşük antifriz'
    ],
    detailedExplanation: 'Motor yeterince ısınamıyor, yakıt ekonomisi düşer.',
  ),
  OBDCode(
    code: 'P0128',
    description: 'Termostat (Soğutma Sıcaklığı Eşik Altında)',
    category: 'Soğutma',
    severity: 'medium',
    possibleCauses: ['Termostat açık kalmış', 'ECT sensörü arızalı'],
    affectedBrands: ['Volkswagen', 'Audi', 'Skoda', 'Seat'],
  ),

  // ======= YAKIT SİSTEMİ =======
  OBDCode(
    code: 'P0171',
    description: 'Sistem Çok Fakir (Bank 1)',
    category: 'Yakıt',
    severity: 'medium',
    possibleCauses: [
      'Vakum kaçağı',
      'Düşük yakıt basıncı',
      'MAF sensörü kirli',
      'Enjektör tıkalı',
      'Egzoz manifoldu sızıntısı'
    ],
    detailedExplanation:
        'Hava-yakıt karışımında hava fazla, yakıt az. Motor güçsüz çalışır ve ısınır.',
    affectedBrands: ['BMW', 'Ford', 'Hyundai'],
  ),
  OBDCode(
    code: 'P0172',
    description: 'Sistem Çok Zengin (Bank 1)',
    category: 'Yakıt',
    severity: 'medium',
    possibleCauses: [
      'Enjektör sızıntısı',
      'Yüksek yakıt basıncı',
      'MAF arızalı',
      'O2 sensör arızalı',
      'EVAP sistemi arızalı'
    ],
    detailedExplanation:
        'Hava-yakıt karışımında yakıt fazla. Siyah egzoz dumanı ve yüksek yakıt tüketimi.',
  ),
  OBDCode(
    code: 'P0174',
    description: 'Sistem Çok Fakir (Bank 2)',
    category: 'Yakıt',
    severity: 'medium',
    possibleCauses: ['Vakum kaçağı', 'Düşük yakıt basıncı', 'Enjektör tıkalı'],
  ),
  OBDCode(
    code: 'P0175',
    description: 'Sistem Çok Zengin (Bank 2)',
    category: 'Yakıt',
    severity: 'medium',
    possibleCauses: ['Enjektör sızıntısı', 'MAF arızalı'],
  ),
  OBDCode(
    code: 'P0087',
    description: 'Yakıt Rail Basıncı Çok Düşük',
    category: 'Yakıt',
    severity: 'critical',
    possibleCauses: [
      'Yakıt pompası arızalı',
      'Yakıt filtresi tıkalı',
      'Yakıt basınç regülatörü arızalı',
      'Yakıt hattında kaçak'
    ],
    detailedExplanation:
        'Motor yeterli yakıt alamıyor. Güç kaybı ve stop etme riski var.',
    affectedBrands: ['Dizel araçlar - özellikle VW, Audi, BMW'],
  ),
  OBDCode(
    code: 'P0088',
    description: 'Yakıt Rail Basıncı Çok Yüksek',
    category: 'Yakıt',
    severity: 'high',
    possibleCauses: [
      'Yakıt basınç regülatörü arızalı',
      'Basınç sensörü arızalı',
      'Enjektör kısıtlı'
    ],
  ),
  OBDCode(
    code: 'P0190',
    description: 'Yakıt Rail Basınç Sensörü Devre Arızası',
    category: 'Yakıt',
    severity: 'high',
    possibleCauses: ['Sensör arızalı', 'Kablo hasarı', 'Konnektör sorunu'],
  ),
  OBDCode(
    code: 'P0201',
    description: 'Enjektör Devre Arızası - Silindir 1',
    category: 'Yakıt',
    severity: 'high',
    possibleCauses: ['Enjektör arızalı', 'Kablo kopuk', 'ECU arızalı'],
  ),
  OBDCode(
    code: 'P0202',
    description: 'Enjektör Devre Arızası - Silindir 2',
    category: 'Yakıt',
    severity: 'high',
    possibleCauses: ['Enjektör arızalı', 'Kablo kopuk'],
  ),
  OBDCode(
    code: 'P0203',
    description: 'Enjektör Devre Arızası - Silindir 3',
    category: 'Yakıt',
    severity: 'high',
    possibleCauses: ['Enjektör arızalı', 'Kablo kopuk'],
  ),
  OBDCode(
    code: 'P0204',
    description: 'Enjektör Devre Arızası - Silindir 4',
    category: 'Yakıt',
    severity: 'high',
    possibleCauses: ['Enjektör arızalı', 'Kablo kopuk'],
  ),

  // ======= EGR SİSTEMİ =======
  OBDCode(
    code: 'P0400',
    description: 'EGR Akış Arızası',
    category: 'Emisyon',
    severity: 'medium',
    possibleCauses: [
      'EGR valfi tıkalı',
      'Karbon birikimi',
      'Vakum hattı sızıntısı',
      'EGR pozisyon sensörü arızalı'
    ],
    detailedExplanation:
        'Egzoz gazı geri dönüşüm sistemi düzgün çalışmıyor. Emisyon artışı ve performans kaybı.',
    affectedBrands: ['Volkswagen', 'Ford', 'Renault'],
  ),
  OBDCode(
    code: 'P0401',
    description: 'EGR Akışı Yetersiz',
    category: 'Emisyon',
    severity: 'medium',
    possibleCauses: ['EGR valfi tıkalı', 'Kanallar karbonlu', 'Vakum kaçağı'],
  ),
  OBDCode(
    code: 'P0402',
    description: 'EGR Akışı Aşırı',
    category: 'Emisyon',
    severity: 'medium',
    possibleCauses: ['EGR valfi açık kalmış', 'Vakum sorunu'],
  ),
  OBDCode(
    code: 'P0404',
    description: 'EGR Valfi Aralık/Performans',
    category: 'Emisyon',
    severity: 'medium',
    possibleCauses: ['EGR valfi arızalı', 'Pozisyon sensörü arızalı'],
  ),

  // ======= EVAP SİSTEMİ =======
  OBDCode(
    code: 'P0440',
    description: 'EVAP Sistemi Arızası',
    category: 'EVAP',
    severity: 'low',
    possibleCauses: [
      'Yakıt kapağı gevşek',
      'EVAP kanistresi arızalı',
      'Hortum çatlak'
    ],
    detailedExplanation:
        'Yakıt buharı sistemi sızdırmazlık testi başarısız. Genellikle basit bir sorun.',
  ),
  OBDCode(
    code: 'P0441',
    description: 'EVAP Yanlış Purge Akışı',
    category: 'EVAP',
    severity: 'low',
    possibleCauses: ['Purge valfi arızalı', 'Vakum hattı sızıntısı'],
  ),
  OBDCode(
    code: 'P0442',
    description: 'EVAP Küçük Sızıntı',
    category: 'EVAP',
    severity: 'low',
    possibleCauses: [
      'Yakıt kapağı contası aşınmış',
      'Hortum bağlantısı gevşek'
    ],
  ),
  OBDCode(
    code: 'P0446',
    description: 'EVAP Havalandırma Kontrolü Devre Arızası',
    category: 'EVAP',
    severity: 'low',
    possibleCauses: ['Vent valfi arızalı', 'Kablo sorunu'],
  ),
  OBDCode(
    code: 'P0455',
    description: 'EVAP Büyük Sızıntı',
    category: 'EVAP',
    severity: 'medium',
    possibleCauses: [
      'Yakıt kapağı eksik veya hasarlı',
      'Yakıt deposu sızıntısı',
      'Büyük hortum çatlağı'
    ],
    affectedBrands: ['Toyota', 'Honda', 'Hyundai'],
  ),

  // ======= ŞANZIMAN =======
  OBDCode(
    code: 'P0700',
    description: 'Şanzıman Kontrol Sistemi Arızası',
    category: 'Şanzıman',
    severity: 'high',
    possibleCauses: [
      'TCM arızası',
      'Alt hata kodu mevcut - diagnostikle kontrol edin'
    ],
    detailedExplanation:
        'Şanzıman bilgisayarı bir arıza tespit etti. Detaylar için alt kodlara bakın.',
  ),
  OBDCode(
    code: 'P0705',
    description: 'Şanzıman Aralık Sensörü Devre Arızası',
    category: 'Şanzıman',
    severity: 'high',
    possibleCauses: [
      'Park/Nötr kontak arızalı',
      'Kablo hasarı',
      'Konnektör oksitli'
    ],
  ),
  OBDCode(
    code: 'P0715',
    description: 'Türbin (Giriş) Hız Sensörü Arızası',
    category: 'Şanzıman',
    severity: 'high',
    possibleCauses: [
      'Hız sensörü arızalı',
      'Kablo hasarı',
      'Metal talaş birikimi'
    ],
    affectedBrands: ['Renault', 'Peugeot', 'Citroen'],
  ),
  OBDCode(
    code: 'P0720',
    description: 'Çıkış Hız Sensörü Arızası',
    category: 'Şanzıman',
    severity: 'high',
    possibleCauses: ['Hız sensörü arızalı', 'Kablo hasarı'],
  ),
  OBDCode(
    code: 'P0730',
    description: 'Yanlış Vites Oranı',
    category: 'Şanzıman',
    severity: 'critical',
    possibleCauses: [
      'Şanzıman iç aşınma',
      'Düşük şanzıman yağı',
      'Kaygan kavrama diskleri',
      'Hidrolik arıza'
    ],
    detailedExplanation:
        'Şanzıman vitesi düzgün tutamıyor. Ciddi iç hasar riski.',
    affectedBrands: ['Otomatik şanzımanlı tüm araçlar'],
  ),
  OBDCode(
    code: 'P0740',
    description: 'Tork Konvertör Kavrama Solenoid Arızası',
    category: 'Şanzıman',
    severity: 'high',
    possibleCauses: ['Solenoid arızalı', 'Kablo hasarı', 'Düşük şanzıman yağı'],
  ),
  OBDCode(
    code: 'P0750',
    description: 'Vites Solenoidi A Arızası',
    category: 'Şanzıman',
    severity: 'high',
    possibleCauses: ['Solenoid arızalı', 'Kablo hasarı', 'Şanzıman yağı kirli'],
  ),

  // ======= ZAMANLA SİSTEMİ =======
  OBDCode(
    code: 'P0335',
    description: 'Krank Mili Pozisyon Sensörü A Devre Arızası',
    category: 'Zamanlama',
    severity: 'critical',
    possibleCauses: [
      'Sensör arızalı',
      'Volan dişleri hasarlı',
      'Kablo kopuk',
      'Sensör mesafesi bozuk'
    ],
    detailedExplanation:
        'Motor hareket halindeyken konum bilgisi alınamıyor. Motor çalışmayabilir.',
    affectedBrands: ['Tüm markalar'],
  ),
  OBDCode(
    code: 'P0336',
    description: 'Krank Sensörü Performans Sorunu',
    category: 'Zamanlama',
    severity: 'high',
    possibleCauses: ['Sensör yıpranmış', 'Volan hasarlı', 'Kablo gevşek'],
  ),
  OBDCode(
    code: 'P0340',
    description: 'Eksantrik Mili Pozisyon Sensörü A Devre Arızası',
    category: 'Zamanlama',
    severity: 'high',
    possibleCauses: [
      'Sensör arızalı',
      'Triger kayışı/zinciri uzamış',
      'Kablo hasarı'
    ],
    detailedExplanation:
        'Eksantrik mili konumu algılanamıyor. Enjeksiyon zamanlaması bozulabilir.',
    affectedBrands: ['Ford', 'Hyundai', 'Kia'],
  ),
  OBDCode(
    code: 'P0341',
    description: 'Eksantrik Sensörü Performans Sorunu',
    category: 'Zamanlama',
    severity: 'high',
    possibleCauses: ['Triger uzamış', 'Sensör mesafesi bozuk'],
  ),
  OBDCode(
    code: 'P0011',
    description: 'Eksantrik Avansı Pozisyon A - Gecikmiş (Bank 1)',
    category: 'Zamanlama',
    severity: 'high',
    possibleCauses: [
      'VVT solenoid arızalı',
      'Motor yağı düşük',
      'Yağ kanalları tıkalı',
      'Triger zinciri uzamış'
    ],
    affectedBrands: ['BMW', 'Toyota', 'Hyundai', 'Kia'],
  ),
  OBDCode(
    code: 'P0012',
    description: 'Eksantrik Avansı Pozisyon A - Erken (Bank 1)',
    category: 'Zamanlama',
    severity: 'high',
    possibleCauses: ['VVT solenoid arızalı', 'Yağ basıncı düşük', 'Yağ kirli'],
  ),
  OBDCode(
    code: 'P0016',
    description: 'Krank-Eksantrik Pozisyon Korelasyonu (Bank 1 Sensör A)',
    category: 'Zamanlama',
    severity: 'critical',
    possibleCauses: [
      'Triger zinciri/kayışı atlamış',
      'VVT sistemi arızalı',
      'Sensör arızalı'
    ],
    detailedExplanation:
        'Krank ve eksantrik milleri senkronize değil. Motor hasarı riski!',
    affectedBrands: ['Volkswagen', 'Audi', 'BMW', 'Mini'],
  ),

  // ======= TURBO/SÜPERŞARJ =======
  OBDCode(
    code: 'P0234',
    description: 'Turbo/Süperşarj Aşırı Basınç',
    category: 'Turbo',
    severity: 'critical',
    possibleCauses: [
      'Wastegate arızalı',
      'Boost basınç sensörü arızalı',
      'Turbo kontrol solenoidi arızalı'
    ],
    detailedExplanation:
        'Turbo basıncı güvenli limitlerin üzerinde. Motor hasarı riski.',
    affectedBrands: ['Tüm turbo araçlar'],
  ),
  OBDCode(
    code: 'P0235',
    description: 'Turbo Boost Sensörü A Devre Arızası',
    category: 'Turbo',
    severity: 'high',
    possibleCauses: ['Boost sensörü arızalı', 'Kablo hasarı', 'Vakum kaçağı'],
  ),
  OBDCode(
    code: 'P0299',
    description: 'Turbo/Süperşarj Düşük Basınç',
    category: 'Turbo',
    severity: 'medium',
    possibleCauses: [
      'Turbo kaçağı',
      'Intercooler sızıntısı',
      'Turbo şaft aşınması',
      'Boost hortumu patlamış',
      'Wastegate açık kalmış'
    ],
    detailedExplanation: 'Turbo yeterli basınç üretemiyor. Güç kaybı belirgin.',
    affectedBrands: ['Volkswagen', 'Audi', 'BMW', 'Ford', 'Renault'],
  ),
  OBDCode(
    code: 'P0243',
    description: 'Turbo Wastegate Solenoid A Arızası',
    category: 'Turbo',
    severity: 'high',
    possibleCauses: [
      'Wastegate solenoid arızalı',
      'Vakum hattı kaçak',
      'Mekanik sıkışma'
    ],
  ),
  OBDCode(
    code: 'P0245',
    description: 'Turbo Wastegate Solenoid A Düşük',
    category: 'Turbo',
    severity: 'high',
    possibleCauses: ['Solenoid arızalı', 'Kablo kısa devre'],
  ),

  // ======= DİZEL ÖZEL =======
  OBDCode(
    code: 'P2002',
    description: 'DPF Verimliliği Eşik Altında (Bank 1)',
    category: 'Dizel',
    severity: 'high',
    possibleCauses: [
      'DPF tıkalı',
      'Rejenerasyon başarısız',
      'Basınç sensörü arızalı',
      'Sıcaklık sensörü arızalı'
    ],
    detailedExplanation:
        'Dizel partikül filtresi temizlenemiyor. Rejenerasyon gerekli.',
    affectedBrands: ['Tüm dizel araçlar'],
  ),
  OBDCode(
    code: 'P2463',
    description: 'DPF Kurum Birikimi Yüksek',
    category: 'Dizel',
    severity: 'high',
    possibleCauses: [
      'Kısa mesafe kullanım',
      'Enjektör arızalı',
      'EGR sorunu',
      'Turbo yağ kaçağı'
    ],
    detailedExplanation:
        'Partikül filtresi aşırı kurum biriktirmiş. Zorunlu rejenerasyon gerekli.',
  ),
  OBDCode(
    code: 'P2458',
    description: 'DPF Rejenerasyon Süresi Aşıldı',
    category: 'Dizel',
    severity: 'medium',
    possibleCauses: ['Şehir içi kısa kullanım', 'Motor tam ısınmıyor'],
  ),
  OBDCode(
    code: 'P20E8',
    description: 'AdBlue/DEF Seviyesi Çok Düşük',
    category: 'SCR',
    severity: 'high',
    possibleCauses: ['AdBlue deposu boş', 'Seviye sensörü arızalı'],
    detailedExplanation:
        'AdBlue bitmek üzere. Dolum yapılmazsa motor çalışmayabilir.',
    affectedBrands: ['Tüm Euro 6 dizel araçlar'],
  ),
  OBDCode(
    code: 'P20EE',
    description: 'SCR NOx Katalitik Verimliliği Düşük',
    category: 'SCR',
    severity: 'high',
    possibleCauses: [
      'Kalitesiz AdBlue kullanımı',
      'SCR katalitik arızalı',
      'NOx sensörü arızalı'
    ],
  ),
  OBDCode(
    code: 'P0671',
    description: '1. Silindir Kızdırma Bujisi Arızası',
    category: 'Dizel',
    severity: 'medium',
    possibleCauses: ['Kızdırma bujisi yanık', 'Kablo hasarı'],
    affectedBrands: ['Dizel araçlar'],
  ),
  OBDCode(
    code: 'P0380',
    description: 'Kızdırma Bujisi/Isıtıcı Devre A Arızası',
    category: 'Dizel',
    severity: 'medium',
    possibleCauses: ['Kızdırma bujisi arızalı', 'Röle arızalı', 'Kablo hasarı'],
  ),

  // ======= ABS/ESP =======
  OBDCode(
    code: 'C0035',
    description: 'Sol Ön Tekerlek Hız Sensörü Arızası',
    category: 'ABS',
    severity: 'high',
    possibleCauses: [
      'ABS sensörü arızalı',
      'Sensör kirli',
      'Kablo kopuk',
      'Dişli çark hasarlı'
    ],
    detailedExplanation:
        'Sol ön tekerlek hız bilgisi alınamıyor. ABS/ESP devre dışı kalabilir.',
  ),
  OBDCode(
    code: 'C0040',
    description: 'Sağ Ön Tekerlek Hız Sensörü Arızası',
    category: 'ABS',
    severity: 'high',
    possibleCauses: ['ABS sensörü arızalı', 'Sensör kirli', 'Kablo kopuk'],
  ),
  OBDCode(
    code: 'C0045',
    description: 'Sol Arka Tekerlek Hız Sensörü Arızası',
    category: 'ABS',
    severity: 'high',
    possibleCauses: ['ABS sensörü arızalı', 'Sensör kirli', 'Kablo kopuk'],
  ),
  OBDCode(
    code: 'C0050',
    description: 'Sağ Arka Tekerlek Hız Sensörü Arızası',
    category: 'ABS',
    severity: 'high',
    possibleCauses: ['ABS sensörü arızalı', 'Sensör kirli', 'Kablo kopuk'],
  ),
  OBDCode(
    code: 'C0121',
    description: 'Direksiyon Açısı Sensörü Arızası',
    category: 'ESP',
    severity: 'high',
    possibleCauses: [
      'Sensör arızalı',
      'Sensör kalibrasyonu bozuk',
      'Kablo hasarı'
    ],
    affectedBrands: ['Volkswagen', 'Audi', 'BMW', 'Mercedes'],
  ),
  OBDCode(
    code: 'C0226',
    description: 'ESP Yaw Rate Sensörü Arızası',
    category: 'ESP',
    severity: 'high',
    possibleCauses: ['Sensör arızalı', 'Montaj gevşek'],
  ),

  // ======= İLETİŞİM (CAN BUS) =======
  OBDCode(
    code: 'U0100',
    description: 'ECM (Motor Kontrol Modülü) ile İletişim Kaybı',
    category: 'CAN Bus',
    severity: 'critical',
    possibleCauses: [
      'CAN bus kablo hasarı',
      'ECM arızalı',
      'Akü voltajı düşük',
      'Toprak bağlantısı zayıf'
    ],
    detailedExplanation: 'Beyin ile iletişim kurulamıyor. Araç çalışmayabilir.',
  ),
  OBDCode(
    code: 'U0101',
    description: 'TCM (Şanzıman Kontrol Modülü) ile İletişim Kaybı',
    category: 'CAN Bus',
    severity: 'high',
    possibleCauses: ['CAN bus sorunu', 'TCM arızalı'],
  ),
  OBDCode(
    code: 'U0121',
    description: 'ABS Modülü ile İletişim Kaybı',
    category: 'CAN Bus',
    severity: 'high',
    possibleCauses: ['CAN bus sorunu', 'ABS modülü arızalı'],
  ),
  OBDCode(
    code: 'U0140',
    description: 'BCM (Gövde Kontrol Modülü) ile İletişim Kaybı',
    category: 'CAN Bus',
    severity: 'medium',
    possibleCauses: ['CAN bus sorunu', 'BCM arızalı'],
  ),
  OBDCode(
    code: 'U0155',
    description: 'Gösterge Paneli ile İletişim Kaybı',
    category: 'CAN Bus',
    severity: 'medium',
    possibleCauses: ['CAN bus sorunu', 'Gösterge arızalı'],
  ),

  // ======= ELEKTRİK/AKÜ =======
  OBDCode(
    code: 'P0560',
    description: 'Sistem Voltajı Arızası',
    category: 'Elektrik',
    severity: 'medium',
    possibleCauses: ['Akü zayıf', 'Şarj sistemi arızalı', 'Kablo gevşek'],
    detailedExplanation:
        'Sistem voltajı normal aralık dışında. Akü veya şarj kontrolü gerekli.',
  ),
  OBDCode(
    code: 'P0562',
    description: 'Sistem Voltajı Düşük',
    category: 'Elektrik',
    severity: 'high',
    possibleCauses: [
      'Akü bitmek üzere',
      'Alternatör arızalı',
      'V-kayışı gevşek/kopuk'
    ],
    affectedBrands: ['Tüm markalar - özellikle eski araçlar'],
  ),
  OBDCode(
    code: 'P0563',
    description: 'Sistem Voltajı Yüksek',
    category: 'Elektrik',
    severity: 'high',
    possibleCauses: ['Voltaj regülatörü arızalı', 'Alternatör arızalı'],
  ),
  OBDCode(
    code: 'P0602',
    description: 'ECU Programlama Hatası',
    category: 'ECU',
    severity: 'high',
    possibleCauses: ['Yazılım bozulmuş', 'Flash işlemi yarım kalmış'],
  ),
  OBDCode(
    code: 'P0606',
    description: 'ECU/PCM İşlemci Arızası',
    category: 'ECU',
    severity: 'critical',
    possibleCauses: ['ECU iç arıza', 'Yazılım bozuk'],
  ),

  // ======= HAVA YASTIKLARI =======
  OBDCode(
    code: 'B0001',
    description: 'Sürücü Ön Hava Yastığı Devre Arızası',
    category: 'SRS',
    severity: 'critical',
    possibleCauses: [
      'Airbag modülü arızalı',
      'Saat yayı (kablo spirali) arızalı',
      'Kablo hasarı'
    ],
    detailedExplanation: 'Sürücü hava yastığı çalışmayabilir. Güvenlik riski!',
  ),
  OBDCode(
    code: 'B0002',
    description: 'Yolcu Ön Hava Yastığı Devre Arızası',
    category: 'SRS',
    severity: 'critical',
    possibleCauses: ['Airbag modülü arızalı', 'Kablo hasarı'],
  ),
  OBDCode(
    code: 'B0100',
    description: 'Sürücü Yan Hava Yastığı Arızası',
    category: 'SRS',
    severity: 'critical',
    possibleCauses: ['Airbag modülü arızalı', 'Kablo hasarı'],
  ),
  OBDCode(
    code: 'B1000',
    description: 'SRS Kontrol Ünitesi Arızası',
    category: 'SRS',
    severity: 'critical',
    possibleCauses: ['Airbag kontrol ünitesi arızalı', 'Voltaj sorunu'],
  ),

  OBDCode(
    code: 'P0530',
    description: 'Klima Basınç Sensörü Arızası',
    category: 'Klima',
    severity: 'low',
    possibleCauses: ['Basınç sensörü arızalı', 'Kablo hasarı', 'Düşük freon'],
  ),
  OBDCode(
    code: 'B1201',
    description: 'Klima Kompresörü Arızası',
    category: 'Klima',
    severity: 'medium',
    possibleCauses: [
      'Kompresör kavraması arızalı',
      'Kompresör motoru yanık',
      'Düşük yağ'
    ],
  ),

  // ======= EK ATEŞLİME KODLARI =======
  OBDCode(
      code: 'P0305',
      description: '5. Silindir Ateşleme Hatası',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: [
        '5. silindir bujisi arızalı',
        'Ateşleme bobini arızalı',
        'Enjektör tıkalı'
      ]),
  OBDCode(
      code: 'P0306',
      description: '6. Silindir Ateşleme Hatası',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: [
        '6. silindir bujisi arızalı',
        'Ateşleme bobini arızalı',
        'Enjektör tıkalı'
      ]),
  OBDCode(
      code: 'P0307',
      description: '7. Silindir Ateşleme Hatası',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: [
        '7. silindir bujisi arızalı',
        'Ateşleme bobini arızalı'
      ]),
  OBDCode(
      code: 'P0308',
      description: '8. Silindir Ateşleme Hatası',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: [
        '8. silindir bujisi arızalı',
        'Ateşleme bobini arızalı'
      ]),
  OBDCode(
      code: 'P0351',
      description: 'Ateşleme Bobini A Birincil/İkincil Devre',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: [
        'Ateşleme bobini arızalı',
        'Kablo hasarı',
        'ECU arızası'
      ]),
  OBDCode(
      code: 'P0352',
      description: 'Ateşleme Bobini B Birincil/İkincil Devre',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: ['Ateşleme bobini arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P0353',
      description: 'Ateşleme Bobini C Birincil/İkincil Devre',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: ['Ateşleme bobini arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P0354',
      description: 'Ateşleme Bobini D Birincil/İkincil Devre',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: ['Ateşleme bobini arızalı', 'Kablo hasarı']),

  // ======= EK OKSİJEN SENSÖRLERİ =======
  OBDCode(
      code: 'P0134',
      description: 'O2 Sensörü Aktivite Yok (Bank 1 Sensör 1)',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: [
        'Lambda sensörü arızalı',
        'Kablo kopuk',
        'Sigorta atmış'
      ]),
  OBDCode(
      code: 'P0135',
      description: 'O2 Sensörü Isıtıcı Arızası (Bank 1 Sensör 1)',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: [
        'Isıtıcı devresi arızalı',
        'Lambda sensörü arızalı',
        'Sigorta atmış'
      ]),
  OBDCode(
      code: 'P0136',
      description: 'O2 Sensörü Devre Arızası (Bank 1 Sensör 2)',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: [
        'Lambda sensörü arızalı',
        'Kablo hasarlı',
        'Katalitik konvertör sorunu'
      ]),
  OBDCode(
      code: 'P0137',
      description: 'O2 Sensörü Düşük Voltaj (Bank 1 Sensör 2)',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Lambda sensörü arızalı', 'Egzoz kaçağı']),
  OBDCode(
      code: 'P0138',
      description: 'O2 Sensörü Yüksek Voltaj (Bank 1 Sensör 2)',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Lambda sensörü arızalı', 'Kablo kısa devre']),
  OBDCode(
      code: 'P0140',
      description: 'O2 Sensörü Aktivite Yok (Bank 1 Sensör 2)',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Lambda sensörü arızalı', 'Kablo kopuk']),
  OBDCode(
      code: 'P0141',
      description: 'O2 Sensörü Isıtıcı Arızası (Bank 1 Sensör 2)',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Isıtıcı devresi arızalı', 'Sigorta atmış']),
  OBDCode(
      code: 'P0150',
      description: 'O2 Sensörü Devre Arızası (Bank 2 Sensör 1)',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Lambda sensörü arızalı', 'Kablo hasarlı']),
  OBDCode(
      code: 'P0151',
      description: 'O2 Sensörü Düşük Voltaj (Bank 2 Sensör 1)',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Lambda sensörü arızalı', 'Fakir karışım']),
  OBDCode(
      code: 'P0152',
      description: 'O2 Sensörü Yüksek Voltaj (Bank 2 Sensör 1)',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Lambda sensörü arızalı', 'Zengin karışım']),
  OBDCode(
      code: 'P0155',
      description: 'O2 Sensörü Isıtıcı Arızası (Bank 2 Sensör 1)',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Isıtıcı devresi arızalı', 'Sigorta atmış']),
  OBDCode(
      code: 'P0156',
      description: 'O2 Sensörü Devre Arızası (Bank 2 Sensör 2)',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Lambda sensörü arızalı', 'Kablo hasarlı']),
  OBDCode(
      code: 'P0430',
      description: 'Katalitik Konvertör Verimliliği Düşük (Bank 2)',
      category: 'Emisyon',
      severity: 'high',
      possibleCauses: [
        'Katalitik konvertör ömrünü tamamlamış',
        'O2 sensörü arızalı'
      ]),

  // ======= EK YAKIT SİSTEMİ =======
  OBDCode(
      code: 'P0205',
      description: 'Enjektör Devre Arızası - Silindir 5',
      category: 'Yakıt',
      severity: 'high',
      possibleCauses: ['Enjektör arızalı', 'Kablo kopuk']),
  OBDCode(
      code: 'P0206',
      description: 'Enjektör Devre Arızası - Silindir 6',
      category: 'Yakıt',
      severity: 'high',
      possibleCauses: ['Enjektör arızalı', 'Kablo kopuk']),
  OBDCode(
      code: 'P0207',
      description: 'Enjektör Devre Arızası - Silindir 7',
      category: 'Yakıt',
      severity: 'high',
      possibleCauses: ['Enjektör arızalı', 'Kablo kopuk']),
  OBDCode(
      code: 'P0208',
      description: 'Enjektör Devre Arızası - Silindir 8',
      category: 'Yakıt',
      severity: 'high',
      possibleCauses: ['Enjektör arızalı', 'Kablo kopuk']),
  OBDCode(
      code: 'P0217',
      description: 'Motor Aşırı Isınma',
      category: 'Soğutma',
      severity: 'critical',
      possibleCauses: [
        'Soğutma suyu eksik',
        'Termostat arızalı',
        'Fan çalışmıyor',
        'Radyatör tıkalı'
      ]),
  OBDCode(
      code: 'P0218',
      description: 'Şanzıman Aşırı Isınma',
      category: 'Şanzıman',
      severity: 'critical',
      possibleCauses: [
        'Şanzıman yağı düşük',
        'Şanzıman soğutucu tıkalı',
        'Aşırı yük'
      ]),
  OBDCode(
      code: 'P0219',
      description: 'Motor Aşırı Devir',
      category: 'Motor',
      severity: 'high',
      possibleCauses: [
        'Gaz pedalı sensörü arızalı',
        'ECU arızası',
        'Sürücü hatası'
      ]),
  OBDCode(
      code: 'P0230',
      description: 'Yakıt Pompası Birincil Devre Arızası',
      category: 'Yakıt',
      severity: 'high',
      possibleCauses: [
        'Yakıt pompası arızalı',
        'Röle arızalı',
        'Sigorta atmış',
        'Kablo hasarı'
      ]),
  OBDCode(
      code: 'P0231',
      description: 'Yakıt Pompası İkincil Devre Düşük',
      category: 'Yakıt',
      severity: 'high',
      possibleCauses: ['Yakıt pompası zayıf', 'Voltaj düşük']),
  OBDCode(
      code: 'P0232',
      description: 'Yakıt Pompası İkincil Devre Yüksek',
      category: 'Yakıt',
      severity: 'high',
      possibleCauses: ['Yakıt pompası arızalı', 'Kablo kısa devre']),
  OBDCode(
      code: 'P0251',
      description: 'Enjeksiyon Pompası Yakıt Vanası A Arızası (Dizel)',
      category: 'Dizel',
      severity: 'high',
      possibleCauses: ['Enjeksiyon pompası arızalı', 'Yakıt vanası tıkalı']),
  OBDCode(
      code: 'P0252',
      description: 'Enjeksiyon Pompası Yakıt Vanası A Performans',
      category: 'Dizel',
      severity: 'high',
      possibleCauses: ['Yakıt vanası kirli', 'Yakıt kalitesi düşük']),

  // ======= EK ŞANZIMAN KODLARI =======
  OBDCode(
      code: 'P0751',
      description: 'Vites Solenoidi A Performans/Sıkışma',
      category: 'Şanzıman',
      severity: 'high',
      possibleCauses: [
        'Solenoid sıkışmış',
        'Şanzıman yağı kirli',
        'Hidrolik arıza'
      ]),
  OBDCode(
      code: 'P0752',
      description: 'Vites Solenoidi A Açık Kalmış',
      category: 'Şanzıman',
      severity: 'high',
      possibleCauses: ['Solenoid arızalı', 'Elektrik sorunu']),
  OBDCode(
      code: 'P0753',
      description: 'Vites Solenoidi A Elektrik Arızası',
      category: 'Şanzıman',
      severity: 'high',
      possibleCauses: ['Solenoid arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P0755',
      description: 'Vites Solenoidi B Arızası',
      category: 'Şanzıman',
      severity: 'high',
      possibleCauses: ['Solenoid arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P0760',
      description: 'Vites Solenoidi C Arızası',
      category: 'Şanzıman',
      severity: 'high',
      possibleCauses: ['Solenoid arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P0765',
      description: 'Vites Solenoidi D Arızası',
      category: 'Şanzıman',
      severity: 'high',
      possibleCauses: ['Solenoid arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P0770',
      description: 'Vites Solenoidi E Arızası',
      category: 'Şanzıman',
      severity: 'high',
      possibleCauses: ['Solenoid arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P0731',
      description: '1. Vites Yanlış Oran',
      category: 'Şanzıman',
      severity: 'critical',
      possibleCauses: [
        'Kavrama aşınmış',
        'Şanzıman iç hasar',
        'Düşük yağ seviyesi'
      ]),
  OBDCode(
      code: 'P0732',
      description: '2. Vites Yanlış Oran',
      category: 'Şanzıman',
      severity: 'critical',
      possibleCauses: ['Kavrama aşınmış', 'Şanzıman iç hasar']),
  OBDCode(
      code: 'P0733',
      description: '3. Vites Yanlış Oran',
      category: 'Şanzıman',
      severity: 'critical',
      possibleCauses: ['Kavrama aşınmış', 'Şanzıman iç hasar']),
  OBDCode(
      code: 'P0734',
      description: '4. Vites Yanlış Oran',
      category: 'Şanzıman',
      severity: 'critical',
      possibleCauses: ['Kavrama aşınmış', 'Şanzıman iç hasar']),
  OBDCode(
      code: 'P0741',
      description: 'Tork Konvertör Kavrama Performans/Sıkışma',
      category: 'Şanzıman',
      severity: 'high',
      possibleCauses: ['Kavrama arızalı', 'Solenoid sıkışmış', 'Düşük yağ']),

  // ======= DİREKSİYON SİSTEMİ =======
  OBDCode(
      code: 'C0460',
      description: 'Direksiyon Açısı Sensörü Hatalı',
      category: 'Direksiyon',
      severity: 'high',
      possibleCauses: ['Sensör arızalı', 'Kalibrasyon bozuk', 'Kablo hasarı']),
  OBDCode(
      code: 'C0545',
      description: 'Elektrikli Direksiyon Motoru Arızası',
      category: 'Direksiyon',
      severity: 'critical',
      possibleCauses: [
        'EPS motor arızalı',
        'Kontrol ünitesi arızalı',
        'Sigorta atmış'
      ]),
  OBDCode(
      code: 'P0550',
      description: 'Direksiyon Hidrolık Basınç Sensörü Arızası',
      category: 'Direksiyon',
      severity: 'medium',
      possibleCauses: ['Basınç sensörü arızalı', 'Hidrolik yağı düşük']),
  OBDCode(
      code: 'P0551',
      description: 'Direksiyon Basınç Sensörü Performans',
      category: 'Direksiyon',
      severity: 'medium',
      possibleCauses: ['Sensör arızalı', 'Hidrolik pompa zayıf']),

  // ======= FREN SİSTEMİ =======
  OBDCode(
      code: 'C0265',
      description: 'EBCM Motor Rölesi Arızası',
      category: 'Fren',
      severity: 'critical',
      possibleCauses: ['ABS motor rölesi arızalı', 'EBCM arızalı']),
  OBDCode(
      code: 'C0267',
      description: 'ABS Pompa Motoru Devre Açık',
      category: 'Fren',
      severity: 'high',
      possibleCauses: ['ABS pompası arızalı', 'Kablo kopuk']),
  OBDCode(
      code: 'C0268',
      description: 'ABS Pompa Motoru Devre Düşük',
      category: 'Fren',
      severity: 'high',
      possibleCauses: ['ABS pompası zayıf', 'Voltaj düşük']),
  OBDCode(
      code: 'C0269',
      description: 'ABS Pompa Motoru Devre Yüksek',
      category: 'Fren',
      severity: 'high',
      possibleCauses: ['ABS pompası arızalı', 'Kısa devre']),
  OBDCode(
      code: 'P0571',
      description: 'Fren Lambası Anahtarı Devre Arızası',
      category: 'Fren',
      severity: 'medium',
      possibleCauses: ['Stop lambası anahtarı arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P0572',
      description: 'Fren Anahtarı Düşük Giriş',
      category: 'Fren',
      severity: 'medium',
      possibleCauses: ['Anahtar arızalı', 'Kablo kısa devre']),

  // ======= HİBRİT/ELEKTRİKLİ ARAÇ =======
  OBDCode(
      code: 'P0A00',
      description: 'Motor Elektrik Depolama Cihazı Arızası',
      category: 'Hibrit/EV',
      severity: 'critical',
      possibleCauses: ['Yüksek voltaj aküsü arızalı', 'BMS arızalı']),
  OBDCode(
      code: 'P0A01',
      description: 'Motor Elektrik Depolama Cihazı Performans',
      category: 'Hibrit/EV',
      severity: 'high',
      possibleCauses: ['Akü kapasitesi düşmüş', 'Hücre dengesizliği']),
  OBDCode(
      code: 'P0A0D',
      description: 'Yüksek Voltaj Sistemi Kilitleme Kayıp',
      category: 'Hibrit/EV',
      severity: 'critical',
      possibleCauses: ['HV güvenlik kilidi arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P0A0F',
      description: 'Motor Dönüştürücü/Inverter Sıcaklık Yüksek',
      category: 'Hibrit/EV',
      severity: 'high',
      possibleCauses: ['Inverter aşırı ısınmış', 'Soğutma sistemi arızalı']),
  OBDCode(
      code: 'P0A1A',
      description: 'Jeneratör/Motor A Sıcaklık Yüksek',
      category: 'Hibrit/EV',
      severity: 'high',
      possibleCauses: ['Elektrik motoru aşırı ısınmış', 'Soğutma yetersiz']),
  OBDCode(
      code: 'P0A3B',
      description: 'HV Akü Sıcaklık Sensörü Arızası',
      category: 'Hibrit/EV',
      severity: 'high',
      possibleCauses: ['Sıcaklık sensörü arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P0A78',
      description: 'Motor/Jeneratör A Dönüştürücü Arızası',
      category: 'Hibrit/EV',
      severity: 'critical',
      possibleCauses: ['Inverter arızalı', 'Kontrol modülü arızalı']),
  OBDCode(
      code: 'P0A80',
      description: 'Hareket Aküsü Paketi Değişim Gerekli',
      category: 'Hibrit/EV',
      severity: 'critical',
      possibleCauses: ['Akü ömrünü tamamlamış', 'Hücreler arızalı'],
      detailedExplanation:
          'Yüksek voltaj aküsü kullanım ömrünü tamamlamış ve değiştirilmeli.',
      affectedBrands: ['Toyota Prius', 'Lexus', 'Honda', 'Tüm hibrit araçlar']),
  OBDCode(
      code: 'P1A00',
      description: 'Elektrikli Tahrik Sistemi Arızası',
      category: 'Hibrit/EV',
      severity: 'critical',
      possibleCauses: [
        'Tahrik motoru arızalı',
        'Dönüştürücü arızalı',
        'HV sistemi sorunu'
      ]),
  OBDCode(
      code: 'P3000',
      description: 'HV Akü Kontrol Sistemi Arızası',
      category: 'Hibrit/EV',
      severity: 'critical',
      possibleCauses: ['BMS arızalı', 'Akü hücresi arızalı', 'Soğutma sorunu']),

  // ======= STOP-START SİSTEMİ =======
  OBDCode(
      code: 'P0A94',
      description: 'DC/DC Dönüştürücü Performans',
      category: 'Hibrit/EV',
      severity: 'high',
      possibleCauses: ['DC/DC dönüştürücü arızalı', 'Voltaj dönüşüm sorunu']),
  OBDCode(
      code: 'U1000',
      description: 'CAN İletişim Veriyolu Arızası',
      category: 'CAN Bus',
      severity: 'critical',
      possibleCauses: [
        'CAN bus kablo hasarı',
        'Sonlandırma direnci eksik',
        'Modül arızalı'
      ]),
  OBDCode(
      code: 'U1001',
      description: 'Yüksek Hızlı CAN İletişim Veriyolu Arızası',
      category: 'CAN Bus',
      severity: 'critical',
      possibleCauses: ['CAN-H veya CAN-L kablo hasarı', 'ECU arızalı']),

  // ======= YAKIT SİSTEMİ EK =======
  OBDCode(
      code: 'P0443',
      description: 'EVAP Kanister Purge Valf Devre Arızası',
      category: 'EVAP',
      severity: 'low',
      possibleCauses: ['Purge valf arızalı', 'Kablo hasarı', 'ECU arızası']),
  OBDCode(
      code: 'P0444',
      description: 'EVAP Purge Valf Devre Açık',
      category: 'EVAP',
      severity: 'low',
      possibleCauses: ['Purge valf arızalı', 'Kablo kopuk']),
  OBDCode(
      code: 'P0445',
      description: 'EVAP Purge Valf Devre Kısa Devre',
      category: 'EVAP',
      severity: 'low',
      possibleCauses: ['Purge valf arızalı', 'Kablo kısa devre']),
  OBDCode(
      code: 'P0447',
      description: 'EVAP Vent Valf Devre Açık',
      category: 'EVAP',
      severity: 'low',
      possibleCauses: ['Vent valf arızalı', 'Kablo kopuk']),
  OBDCode(
      code: 'P0448',
      description: 'EVAP Vent Valf Devre Kısa Devre',
      category: 'EVAP',
      severity: 'low',
      possibleCauses: ['Vent valf arızalı', 'Kablo kısa devre']),
  OBDCode(
      code: 'P0449',
      description: 'EVAP Vent Valf Solenoid Arızası',
      category: 'EVAP',
      severity: 'low',
      possibleCauses: ['Vent solenoid arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P0452',
      description: 'EVAP Basınç Sensörü Düşük Giriş',
      category: 'EVAP',
      severity: 'low',
      possibleCauses: ['Basınç sensörü arızalı', 'Kablo kısa devre']),
  OBDCode(
      code: 'P0453',
      description: 'EVAP Basınç Sensörü Yüksek Giriş',
      category: 'EVAP',
      severity: 'low',
      possibleCauses: ['Basınç sensörü arızalı', 'Kablo açık']),

  // ======= EK MOTOR KODLARI =======
  OBDCode(
      code: 'P0013',
      description: 'Egzoz Eksantrik Avansı Pozisyon Bank 1',
      category: 'Zamanlama',
      severity: 'high',
      possibleCauses: [
        'Egzoz VVT solenoid arızalı',
        'Yağ basıncı düşük',
        'Yağ kirli'
      ]),
  OBDCode(
      code: 'P0014',
      description: 'Egzoz Eksantrik Avansı Pozisyon - Erken Bank 1',
      category: 'Zamanlama',
      severity: 'high',
      possibleCauses: ['VVT solenoid arızalı', 'Yağ kanalları tıkalı']),
  OBDCode(
      code: 'P0017',
      description: 'Krank-Egzoz Eksantrik Pozisyon Korelasyonu Bank 1',
      category: 'Zamanlama',
      severity: 'critical',
      possibleCauses: ['Triger zinciri/kayışı atlamış', 'Sensör arızalı']),
  OBDCode(
      code: 'P0018',
      description: 'Krank-Eksantrik Pozisyon Korelasyonu Bank 2 Sensör A',
      category: 'Zamanlama',
      severity: 'critical',
      possibleCauses: ['Triger atlamış', 'VVT arızalı', 'Sensör arızalı']),
  OBDCode(
      code: 'P0019',
      description: 'Krank-Eksantrik Pozisyon Korelasyonu Bank 2 Sensör B',
      category: 'Zamanlama',
      severity: 'critical',
      possibleCauses: ['Triger atlamış', 'VVT arızalı']),
  OBDCode(
      code: 'P0021',
      description: 'Eksantrik Avansı Pozisyon A - Gecikmiş Bank 2',
      category: 'Zamanlama',
      severity: 'high',
      possibleCauses: ['VVT solenoid arızalı', 'Yağ basıncı düşük']),
  OBDCode(
      code: 'P0022',
      description: 'Eksantrik Avansı Pozisyon A - Erken Bank 2',
      category: 'Zamanlama',
      severity: 'high',
      possibleCauses: ['VVT solenoid arızalı', 'Yağ kirli']),

  // ======= DİZEL EK =======
  OBDCode(
      code: 'P0672',
      description: '2. Silindir Kızdırma Bujisi Arızası',
      category: 'Dizel',
      severity: 'medium',
      possibleCauses: ['Kızdırma bujisi yanık', 'Kablo hasarı']),
  OBDCode(
      code: 'P0673',
      description: '3. Silindir Kızdırma Bujisi Arızası',
      category: 'Dizel',
      severity: 'medium',
      possibleCauses: ['Kızdırma bujisi yanık', 'Kablo hasarı']),
  OBDCode(
      code: 'P0674',
      description: '4. Silindir Kızdırma Bujisi Arızası',
      category: 'Dizel',
      severity: 'medium',
      possibleCauses: ['Kızdırma bujisi yanık', 'Kablo hasarı']),
  OBDCode(
      code: 'P0675',
      description: '5. Silindir Kızdırma Bujisi Arızası',
      category: 'Dizel',
      severity: 'medium',
      possibleCauses: ['Kızdırma bujisi yanık']),
  OBDCode(
      code: 'P0676',
      description: '6. Silindir Kızdırma Bujisi Arızası',
      category: 'Dizel',
      severity: 'medium',
      possibleCauses: ['Kızdırma bujisi yanık']),
  OBDCode(
      code: 'P2004',
      description: 'Emme Manifoldu Koşucu Kontrolü Açık Kalmış Bank 1',
      category: 'Hava Sistemi',
      severity: 'medium',
      possibleCauses: [
        'Swirl flap arızalı',
        'Vakum sorunu',
        'Aktüatör arızalı'
      ]),
  OBDCode(
      code: 'P2006',
      description: 'Emme Manifoldu Koşucu Kontrolü Kapalı Kalmış Bank 1',
      category: 'Hava Sistemi',
      severity: 'medium',
      possibleCauses: ['Swirl flap sıkışmış', 'Karbon birikimi']),
  OBDCode(
      code: 'P2008',
      description: 'Emme Manifoldu Koşucu Kontrolü Devre Açık Bank 1',
      category: 'Hava Sistemi',
      severity: 'medium',
      possibleCauses: ['Aktüatör arızalı', 'Kablo kopuk']),
  OBDCode(
      code: 'P2009',
      description: 'Emme Manifoldu Koşucu Kontrolü Devre Düşük Bank 1',
      category: 'Hava Sistemi',
      severity: 'medium',
      possibleCauses: ['Aktüatör arızalı', 'Kablo kısa devre']),

  // ======= EK ECU KODLARI =======
  OBDCode(
      code: 'P0600',
      description: 'Seri İletişim Bağlantı Arızası',
      category: 'ECU',
      severity: 'medium',
      possibleCauses: ['ECU iç iletişim sorunu', 'CAN bus hatası']),
  OBDCode(
      code: 'P0601',
      description: 'İç Kontrol Modülü Bellek Kontrol Hatası',
      category: 'ECU',
      severity: 'high',
      possibleCauses: ['ECU belllek arızalı', 'Yazılım bozuk']),
  OBDCode(
      code: 'P0603',
      description: 'İç Kontrol Modülü KAM Hatası',
      category: 'ECU',
      severity: 'medium',
      possibleCauses: ['Akü bağlantısı kesilmiş', 'ECU arızalı']),
  OBDCode(
      code: 'P0604',
      description: 'İç Kontrol Modülü RAM Hatası',
      category: 'ECU',
      severity: 'high',
      possibleCauses: ['ECU RAM arızalı', 'Voltaj dalgalanması']),
  OBDCode(
      code: 'P0605',
      description: 'İç Kontrol Modülü ROM Hatası',
      category: 'ECU',
      severity: 'critical',
      possibleCauses: ['ECU ROM arızalı', 'Yazılım bozuk']),
  OBDCode(
      code: 'P0607',
      description: 'Kontrol Modülü Performans',
      category: 'ECU',
      severity: 'high',
      possibleCauses: ['ECU iç arıza', 'Voltaj sorunu']),

  // ======= EMİSYON EK =======
  OBDCode(
      code: 'P0405',
      description: 'EGR Pozisyon Sensörü A Düşük',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['EGR pozisyon sensörü arızalı', 'Kablo kısa devre']),
  OBDCode(
      code: 'P0406',
      description: 'EGR Pozisyon Sensörü A Yüksek',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['EGR pozisyon sensörü arızalı', 'Kablo açık']),
  OBDCode(
      code: 'P0410',
      description: 'İkincil Hava Enjeksiyonu Sistemi Arızası',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: [
        'İkincil hava pompası arızalı',
        'Valf arızalı',
        'Hortum yırtık'
      ]),
  OBDCode(
      code: 'P0411',
      description: 'İkincil Hava Enjeksiyonu Sistemi Yanlış Akış',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Pompa zayıf', 'Valf tıkalı', 'Kaçak var']),
  OBDCode(
      code: 'P0412',
      description: 'İkincil Hava Enjeksiyonu Valf A Devre Arızası',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Valf arızalı', 'Kablo hasarı']),

  // ======= GÖVDE KODLARI (B - BODY) =======
  // Aydınlatma
  OBDCode(
      code: 'B1318',
      description: 'Akü Voltajı Düşük',
      category: 'Elektrik',
      severity: 'medium',
      possibleCauses: ['Akü zayıf', 'Şarj sistemi arızalı', 'Parazit akım']),
  OBDCode(
      code: 'B1319',
      description: 'Akü Voltajı Yüksek',
      category: 'Elektrik',
      severity: 'medium',
      possibleCauses: ['Voltaj regülatörü arızalı', 'Alternatör arızalı']),
  OBDCode(
      code: 'B1342',
      description: 'ECU Arızalı',
      category: 'ECU',
      severity: 'critical',
      possibleCauses: ['ECU iç arıza', 'Yazılım bozuk']),
  OBDCode(
      code: 'B1352',
      description: 'Kontak Anahtarı Devre Arızası',
      category: 'Elektrik',
      severity: 'high',
      possibleCauses: ['Kontak kilidi arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'B1600',
      description: 'PATS Alıcı Arızası',
      category: 'Immobilizer',
      severity: 'high',
      possibleCauses: [
        'Immobilizer alıcı arızalı',
        'Anahtar transponder arızalı'
      ]),
  OBDCode(
      code: 'B1601',
      description: 'PATS Anahtar Geçersiz',
      category: 'Immobilizer',
      severity: 'high',
      possibleCauses: ['Yanlış anahtar', 'Transponder programlanmamış']),
  OBDCode(
      code: 'B1602',
      description: 'PATS Anahtar Sayısı <2',
      category: 'Immobilizer',
      severity: 'medium',
      possibleCauses: ['Sadece 1 anahtar programlı', 'Yedek anahtar gerekli']),
  OBDCode(
      code: 'B2799',
      description: 'Motor Immobilizer Sistemi Arızası',
      category: 'Immobilizer',
      severity: 'critical',
      possibleCauses: [
        'Anahtar tanınmıyor',
        'ECU-Immobilizer iletişim hatası'
      ]),

  // Kapı ve Kilit
  OBDCode(
      code: 'B1213',
      description: 'Kapı Kilidi Sürücü Devre Arızası',
      category: 'Gövde',
      severity: 'low',
      possibleCauses: ['Kapı kilidi motoru arızalı', 'Anahtar arızalı']),
  OBDCode(
      code: 'B1214',
      description: 'Kapı Kilidi Yolcu Devre Arızası',
      category: 'Gövde',
      severity: 'low',
      possibleCauses: ['Kapı kilidi motoru arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'B1231',
      description: 'Kapı Açık Anahtarı Arızası',
      category: 'Gövde',
      severity: 'low',
      possibleCauses: ['Kapı anahtar sensörü arızalı']),
  OBDCode(
      code: 'B1676',
      description: 'Akü Şarj Sıfırlama Gerekli',
      category: 'Elektrik',
      severity: 'low',
      possibleCauses: ['Akü değiştirilmiş', 'Sistem sıfırlama gerekli']),

  // Cam ve Ayna
  OBDCode(
      code: 'B1259',
      description: 'Cam Kaldırma Motoru Sürücü Arızası',
      category: 'Gövde',
      severity: 'low',
      possibleCauses: [
        'Cam motoru arızalı',
        'Sigorta atmış',
        'Switch arızalı'
      ]),
  OBDCode(
      code: 'B1260',
      description: 'Cam Kaldırma Motoru Yolcu Arızası',
      category: 'Gövde',
      severity: 'low',
      possibleCauses: ['Cam motoru arızalı', 'Sigorta atmış']),
  OBDCode(
      code: 'B1282',
      description: 'Ayna Isıtma Devre Arızası',
      category: 'Gövde',
      severity: 'low',
      possibleCauses: ['Ayna ısıtma elementi arızalı', 'Sigorta atmış']),
  OBDCode(
      code: 'B1285',
      description: 'Elektrikli Ayna Motoru Arızası',
      category: 'Gövde',
      severity: 'low',
      possibleCauses: ['Ayna motoru arızalı', 'Switch arızalı']),

  // Koltuk
  OBDCode(
      code: 'B1325',
      description: 'Koltuk Motoru Arızası',
      category: 'Gövde',
      severity: 'low',
      possibleCauses: [
        'Koltuk motoru arızalı',
        'Sigorta atmış',
        'Switch arızalı'
      ]),
  OBDCode(
      code: 'B1326',
      description: 'Koltuk Hafıza Modülü Arızası',
      category: 'Gövde',
      severity: 'low',
      possibleCauses: ['Hafıza modülü arızalı', 'Yazılım hatası']),
  OBDCode(
      code: 'B1328',
      description: 'Koltuk Isıtma Arızası',
      category: 'Gövde',
      severity: 'low',
      possibleCauses: ['Isıtma elementi arızalı', 'Termostat arızalı']),

  // Aydınlatma
  OBDCode(
      code: 'B1361',
      description: 'Far Kontrol Modülü Arızası',
      category: 'Aydınlatma',
      severity: 'medium',
      possibleCauses: ['Far modülü arızalı', 'CAN bus hatası']),
  OBDCode(
      code: 'B1362',
      description: 'Ön Far Sol Arızası',
      category: 'Aydınlatma',
      severity: 'medium',
      possibleCauses: ['Ampul yanık', 'Balast arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'B1363',
      description: 'Ön Far Sağ Arızası',
      category: 'Aydınlatma',
      severity: 'medium',
      possibleCauses: ['Ampul yanık', 'Balast arızalı']),
  OBDCode(
      code: 'B1372',
      description: 'Gündüz Farı (DRL) Sol Arızası',
      category: 'Aydınlatma',
      severity: 'low',
      possibleCauses: ['LED modülü arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'B1373',
      description: 'Gündüz Farı (DRL) Sağ Arızası',
      category: 'Aydınlatma',
      severity: 'low',
      possibleCauses: ['LED modülü arızalı']),
  OBDCode(
      code: 'B1381',
      description: 'Stop Lambası Sol Arızası',
      category: 'Aydınlatma',
      severity: 'medium',
      possibleCauses: ['Ampul yanık', 'Kablo kısa devre']),
  OBDCode(
      code: 'B1382',
      description: 'Stop Lambası Sağ Arızası',
      category: 'Aydınlatma',
      severity: 'medium',
      possibleCauses: ['Ampul yanık']),
  OBDCode(
      code: 'B1391',
      description: 'Sinyal Lambası Sol Ön Arızası',
      category: 'Aydınlatma',
      severity: 'medium',
      possibleCauses: ['Ampul yanık', 'Flaşör arızalı']),
  OBDCode(
      code: 'B1392',
      description: 'Sinyal Lambası Sağ Ön Arızası',
      category: 'Aydınlatma',
      severity: 'medium',
      possibleCauses: ['Ampul yanık']),
  OBDCode(
      code: 'B1393',
      description: 'Sinyal Lambası Sol Arka Arızası',
      category: 'Aydınlatma',
      severity: 'medium',
      possibleCauses: ['Ampul yanık']),
  OBDCode(
      code: 'B1394',
      description: 'Sinyal Lambası Sağ Arka Arızası',
      category: 'Aydınlatma',
      severity: 'medium',
      possibleCauses: ['Ampul yanık']),

  // ======= ŞASİ KODLARI (C - CHASSIS) =======
  // ABS Ek Kodları
  OBDCode(
      code: 'C0055',
      description: 'Arka Tekerlek Hız Sensörü Arızası',
      category: 'ABS',
      severity: 'high',
      possibleCauses: ['ABS sensörü arızalı', 'Sensör kirli', 'Kablo kopuk']),
  OBDCode(
      code: 'C0060',
      description: 'Sol Ön ABS Solenoid Arızası',
      category: 'ABS',
      severity: 'high',
      possibleCauses: ['ABS solenoid arızalı', 'Hidrolik ünite arızalı']),
  OBDCode(
      code: 'C0065',
      description: 'Sağ Ön ABS Solenoid Arızası',
      category: 'ABS',
      severity: 'high',
      possibleCauses: ['ABS solenoid arızalı', 'Hidrolik ünite arızalı']),
  OBDCode(
      code: 'C0070',
      description: 'Sol Arka ABS Solenoid Arızası',
      category: 'ABS',
      severity: 'high',
      possibleCauses: ['ABS solenoid arızalı', 'Hidrolik ünite arızalı']),
  OBDCode(
      code: 'C0075',
      description: 'Sağ Arka ABS Solenoid Arızası',
      category: 'ABS',
      severity: 'high',
      possibleCauses: ['ABS solenoid arızalı']),
  OBDCode(
      code: 'C0110',
      description: 'ABS Pompa Motoru Aşırı Akım',
      category: 'ABS',
      severity: 'high',
      possibleCauses: ['ABS pompası arızalı', 'Kablo kısa devre']),
  OBDCode(
      code: 'C0131',
      description: 'ABS/TCS Röle Devre Arızası',
      category: 'ABS',
      severity: 'high',
      possibleCauses: ['Röle arızalı', 'Sigorta atmış']),
  OBDCode(
      code: 'C0161',
      description: 'ABS/TCS Fren Anahtarı Devre Arızası',
      category: 'ABS',
      severity: 'medium',
      possibleCauses: ['Fren anahtarı arızalı', 'Kablo hasarı']),

  // ESP/Stabilite
  OBDCode(
      code: 'C0196',
      description: 'Yaw Rate Sensörü Sapması',
      category: 'ESP',
      severity: 'high',
      possibleCauses: ['Sensör kalibrasyonu bozuk', 'Sensör arızalı']),
  OBDCode(
      code: 'C0235',
      description: 'ESP Arka Tekerlek Hız Sensörü Sapması',
      category: 'ESP',
      severity: 'high',
      possibleCauses: ['Sensör arızalı', 'Lastik boyutu uyumsuz']),
  OBDCode(
      code: 'C0236',
      description: 'ESP Ön Tekerlek Hız Sensörü Sapması',
      category: 'ESP',
      severity: 'high',
      possibleCauses: ['Sensör arızalı', 'Lastik boyutu uyumsuz']),
  OBDCode(
      code: 'C0241',
      description: 'EBCM Kontrol Valfi Arızası',
      category: 'ABS',
      severity: 'critical',
      possibleCauses: ['Kontrol valfi arızalı', 'Hidrolik ünite arızalı']),
  OBDCode(
      code: 'C0245',
      description: 'Tekerlek Hız Sensörü Frekans Hatası',
      category: 'ABS',
      severity: 'high',
      possibleCauses: ['Sensör arızalı', 'Tekerlek rulmanı arızalı']),
  OBDCode(
      code: 'C0252',
      description: 'EBCM İstenen Tork Düşürme Yapılamadı',
      category: 'ESP',
      severity: 'high',
      possibleCauses: ['ECU-EBCM iletişim hatası', 'Gaz kelebeği arızalı']),
  OBDCode(
      code: 'C0281',
      description: 'Direksiyon Tork Sensörü Arızası',
      category: 'Direksiyon',
      severity: 'high',
      possibleCauses: ['Tork sensörü arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'C0283',
      description: 'Elektrikli Direksiyon Motoru Sıcaklık Yüksek',
      category: 'Direksiyon',
      severity: 'high',
      possibleCauses: ['EPS motor aşırı ısınmış', 'Soğutma yetersiz']),
  OBDCode(
      code: 'C0284',
      description: 'Elektrikli Direksiyon Kontrol Modülü Arızası',
      category: 'Direksiyon',
      severity: 'critical',
      possibleCauses: ['EPS kontrol ünitesi arızalı', 'Yazılım hatası']),

  // Park Freni
  OBDCode(
      code: 'C0501',
      description: 'Elektronik Park Freni Arızası',
      category: 'Fren',
      severity: 'high',
      possibleCauses: ['EPB motor arızalı', 'Switch arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'C0502',
      description: 'EPB Motor Sol Arızası',
      category: 'Fren',
      severity: 'high',
      possibleCauses: ['Sol EPB motoru arızalı']),
  OBDCode(
      code: 'C0503',
      description: 'EPB Motor Sağ Arızası',
      category: 'Fren',
      severity: 'high',
      possibleCauses: ['Sağ EPB motoru arızalı']),
  OBDCode(
      code: 'C0508',
      description: 'EPB Serbest Bırakma Hatası',
      category: 'Fren',
      severity: 'high',
      possibleCauses: ['Motor arızalı', 'Mekanik sıkışma']),

  // Lastik Basınç (TPMS)
  OBDCode(
      code: 'C0750',
      description: 'Sol Ön TPMS Sensörü Arızası',
      category: 'TPMS',
      severity: 'medium',
      possibleCauses: ['Sensör pili bitmiş', 'Sensör arızalı']),
  OBDCode(
      code: 'C0755',
      description: 'Sağ Ön TPMS Sensörü Arızası',
      category: 'TPMS',
      severity: 'medium',
      possibleCauses: ['Sensör pili bitmiş', 'Sensör arızalı']),
  OBDCode(
      code: 'C0760',
      description: 'Sol Arka TPMS Sensörü Arızası',
      category: 'TPMS',
      severity: 'medium',
      possibleCauses: ['Sensör pili bitmiş', 'Sensör arızalı']),
  OBDCode(
      code: 'C0765',
      description: 'Sağ Arka TPMS Sensörü Arızası',
      category: 'TPMS',
      severity: 'medium',
      possibleCauses: ['Sensör pili bitmiş', 'Sensör arızalı']),
  OBDCode(
      code: 'C0775',
      description: 'TPMS Alıcı Modülü Arızası',
      category: 'TPMS',
      severity: 'medium',
      possibleCauses: ['Alıcı modülü arızalı', 'Anten hasarlı']),

  // Süspansiyon
  OBDCode(
      code: 'C1130',
      description: 'Hava Süspansiyonu Kompresör Arızası',
      category: 'Süspansiyon',
      severity: 'high',
      possibleCauses: ['Kompresör arızalı', 'Sigorta atmış', 'Röle arızalı']),
  OBDCode(
      code: 'C1135',
      description: 'Hava Süspansiyonu Sol Ön Hava Yastığı Arızası',
      category: 'Süspansiyon',
      severity: 'high',
      possibleCauses: ['Hava yastığı yırtık', 'Hava kaçağı']),
  OBDCode(
      code: 'C1140',
      description: 'Hava Süspansiyonu Sağ Ön Hava Yastığı Arızası',
      category: 'Süspansiyon',
      severity: 'high',
      possibleCauses: ['Hava yastığı yırtık']),
  OBDCode(
      code: 'C1145',
      description: 'Hava Süspansiyonu Sol Arka Hava Yastığı Arızası',
      category: 'Süspansiyon',
      severity: 'high',
      possibleCauses: ['Hava yastığı yırtık']),
  OBDCode(
      code: 'C1150',
      description: 'Hava Süspansiyonu Sağ Arka Hava Yastığı Arızası',
      category: 'Süspansiyon',
      severity: 'high',
      possibleCauses: ['Hava yastığı yırtık']),
  OBDCode(
      code: 'C1155',
      description: 'Süspansiyon Yükseklik Sensörü Arızası',
      category: 'Süspansiyon',
      severity: 'medium',
      possibleCauses: ['Yükseklik sensörü arızalı', 'Kablo hasarı']),

  // ======= AĞ/İLETİŞİM KODLARI (U - NETWORK) =======
  OBDCode(
      code: 'U0001',
      description: 'Yüksek Hızlı CAN İletişim Veriyolu',
      category: 'CAN Bus',
      severity: 'critical',
      possibleCauses: ['CAN bus kablo hasarı', 'Modül arızalı']),
  OBDCode(
      code: 'U0002',
      description: 'Yüksek Hızlı CAN Veriyolu Performans',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Sinyal kalitesi düşük', 'Kablo paraziti']),
  OBDCode(
      code: 'U0003',
      description: 'Yüksek Hızlı CAN Veriyolu (+) Açık',
      category: 'CAN Bus',
      severity: 'critical',
      possibleCauses: ['CAN-H kablosu kopuk', 'Konnektör arızalı']),
  OBDCode(
      code: 'U0004',
      description: 'Yüksek Hızlı CAN Veriyolu (-) Açık',
      category: 'CAN Bus',
      severity: 'critical',
      possibleCauses: ['CAN-L kablosu kopuk', 'Konnektör arızalı']),
  OBDCode(
      code: 'U0010',
      description: 'Orta Hızlı CAN İletişim Veriyolu',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['CAN bus kablo hasarı', 'Modül arızalı']),
  OBDCode(
      code: 'U0028',
      description: 'Araç İletişim Veriyolu A Veri Eksik',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Modül arızalı', 'CAN bus sorunu']),
  OBDCode(
      code: 'U0029',
      description: 'Araç İletişim Veriyolu B Veri Eksik',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Modül arızalı', 'CAN bus sorunu']),
  OBDCode(
      code: 'U0073',
      description: 'Kontrol Modülü İletişimi Kapalı',
      category: 'CAN Bus',
      severity: 'critical',
      possibleCauses: [
        'Birden fazla modül iletişim yok',
        'CAN bus ana arızası'
      ]),
  OBDCode(
      code: 'U0101',
      description: 'TCM ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Şanzıman kontrol modülü arızalı', 'CAN bus hatası']),
  OBDCode(
      code: 'U0102',
      description: 'Aktarma Organı Kontrol Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Aktarma modülü arızalı', 'CAN bus hatası']),
  OBDCode(
      code: 'U0103',
      description: 'Vites Değiştirme Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Vites modülü arızalı']),
  OBDCode(
      code: 'U0104',
      description: 'Cruise Control Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'medium',
      possibleCauses: ['Cruise kontrol modülü arızalı']),
  OBDCode(
      code: 'U0105',
      description: 'Yakıt Enjektör Kontrol Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Enjektör modülü arızalı']),
  OBDCode(
      code: 'U0107',
      description: 'Gaz Kelebeği Aktüatör Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'critical',
      possibleCauses: ['Gaz kelebeği modülü arızalı']),
  OBDCode(
      code: 'U0109',
      description: 'Yakıt Pompası Kontrol Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Yakıt pompası modülü arızalı']),
  OBDCode(
      code: 'U0111',
      description: 'Akü Enerji Kontrol Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['BMS modülü arızalı (Hibrit/EV)']),
  OBDCode(
      code: 'U0115',
      description: 'Klima Kontrol Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'medium',
      possibleCauses: ['Klima modülü arızalı']),
  OBDCode(
      code: 'U0122',
      description: 'Araç Dinamik Kontrol Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['ESP/ESC modülü arızalı']),
  OBDCode(
      code: 'U0126',
      description: 'Direksiyon Açısı Sensör Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Direksiyon açı sensörü modülü arızalı']),
  OBDCode(
      code: 'U0127',
      description: 'TPMS Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'medium',
      possibleCauses: ['TPMS modülü arızalı']),
  OBDCode(
      code: 'U0128',
      description: 'Park Yardım Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'low',
      possibleCauses: ['Park sensörü modülü arızalı']),
  OBDCode(
      code: 'U0129',
      description: 'Fren Sistemi Kontrol Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'critical',
      possibleCauses: ['ABS modülü arızalı']),
  OBDCode(
      code: 'U0131',
      description: 'Direksiyon Kontrol Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'critical',
      possibleCauses: ['EPS modülü arızalı']),
  OBDCode(
      code: 'U0142',
      description: 'Gövde Kontrol Modülü B ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'medium',
      possibleCauses: ['BCM B arızalı']),
  OBDCode(
      code: 'U0146',
      description: 'Gateway A ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'critical',
      possibleCauses: ['Ağ geçidi arızalı']),
  OBDCode(
      code: 'U0151',
      description: 'SRS Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'critical',
      possibleCauses: ['Airbag modülü arızalı']),
  OBDCode(
      code: 'U0154',
      description: 'Yol Tutuş Kontrol Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Traction control modülü arızalı']),
  OBDCode(
      code: 'U0159',
      description: 'Park Freni Kontrol Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['EPB modülü arızalı']),
  OBDCode(
      code: 'U0164',
      description: 'Klima Kontrol Modülü A ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'low',
      possibleCauses: ['Klima kontrol paneli arızalı']),
  OBDCode(
      code: 'U0167',
      description: 'Araç Immobilizer Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'critical',
      possibleCauses: ['Immobilizer modülü arızalı']),
  OBDCode(
      code: 'U0168',
      description: 'Araç Güvenlik Kontrol Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Güvenlik modülü arızalı']),
  OBDCode(
      code: 'U0184',
      description: 'Radyo ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'low',
      possibleCauses: ['Radyo ünitesi arızalı']),
  OBDCode(
      code: 'U0199',
      description: 'Arazi Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'medium',
      possibleCauses: ['4WD modülü arızalı']),
  OBDCode(
      code: 'U0212',
      description: 'Direksiyon Kolon Kontrol Modülü ile İletişim Kaybı',
      category: 'CAN Bus',
      severity: 'medium',
      possibleCauses: ['Direksiyon kolon modülü arızalı']),
  OBDCode(
      code: 'U0300',
      description: 'İç Yazılım Uyumsuzluğu',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Modül yazılımları uyumsuz', 'Güncelleme gerekli']),
  OBDCode(
      code: 'U0401',
      description: 'Geçersiz Veri Alındı - ECM',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['ECU veri hatası', 'CAN bus paraziti']),
  OBDCode(
      code: 'U0402',
      description: 'Geçersiz Veri Alındı - TCM',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Şanzıman modülü veri hatası']),
  OBDCode(
      code: 'U0404',
      description: 'Geçersiz Veri Alındı - Vites Modülü',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Vites pozisyon verisi hatalı']),
  OBDCode(
      code: 'U0415',
      description: 'Geçersiz Veri Alındı - Klima',
      category: 'CAN Bus',
      severity: 'low',
      possibleCauses: ['Klima sistem verisi hatalı']),
  OBDCode(
      code: 'U0421',
      description: 'Geçersiz Veri Alındı - ABS',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['ABS veri hatası']),
  OBDCode(
      code: 'U0426',
      description: 'Geçersiz Veri Alındı - Direksiyon Açı Sensörü',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Direksiyon açı verisi hatalı']),
  OBDCode(
      code: 'U0428',
      description: 'Geçersiz Veri Alındı - Direksiyon',
      category: 'CAN Bus',
      severity: 'high',
      possibleCauses: ['Direksiyon verisi hatalı']),

  // ======= ÜRETİCİ ÖZEL KODLAR (P1xxx-P3xxx) =======
  // Genel P1 Kodları
  OBDCode(
      code: 'P1000',
      description: 'OBD Sistemi Hazırlık Testi Tamamlanmadı',
      category: 'OBD',
      severity: 'low',
      possibleCauses: [
        'ECU sıfırlandı',
        'Akü bağlantısı kesildi',
        'Sürüş döngüsü tamamlanmadı'
      ]),
  OBDCode(
      code: 'P1100',
      description: 'MAF Sensörü Aralık Dışı',
      category: 'Hava Sistemi',
      severity: 'medium',
      possibleCauses: ['MAF sensörü kirli', 'Hava kanalı çatlak']),
  OBDCode(
      code: 'P1101',
      description: 'MAF Sensörü Beklenmeyen Değer',
      category: 'Hava Sistemi',
      severity: 'medium',
      possibleCauses: ['MAF sensörü arızalı', 'Vakum kaçağı']),
  OBDCode(
      code: 'P1105',
      description: 'MAP Sensörü Aralık Dışı',
      category: 'Hava Sistemi',
      severity: 'medium',
      possibleCauses: ['MAP sensörü arızalı']),
  OBDCode(
      code: 'P1130',
      description: 'O2 Sensörü Sinyal Birliği Yok Bank 1',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Lambda sensörü arızalı', 'Yakıt sisteminde sorun']),
  OBDCode(
      code: 'P1135',
      description: 'O2 Sensörü Isıtıcı Performans Bank 1 Sensör 1',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Isıtıcı devresi arızalı']),
  OBDCode(
      code: 'P1150',
      description: 'O2 Sensörü Sinyal Birliği Yok Bank 2',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Lambda sensörü arızalı']),
  OBDCode(
      code: 'P1200',
      description: 'Enjektör Kontrol Devresi',
      category: 'Yakıt',
      severity: 'high',
      possibleCauses: ['Enjektör sürücü arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P1220',
      description: 'Gaz Kelebeği Pozisyon Sensörü B Devre Arızası',
      category: 'Hava Sistemi',
      severity: 'high',
      possibleCauses: ['TPS B arızalı', 'Gaz kelebeği arızalı']),
  OBDCode(
      code: 'P1300',
      description: 'Rastgele Ateşleme Tespit Edildi',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: ['Buji arızalı', 'Bobin arızalı', 'Vakum kaçağı']),
  OBDCode(
      code: 'P1310',
      description: 'Ateşleme Bobini 1 Arızası',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: ['Bobin 1 arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P1315',
      description: 'Ateşleme Bobini 2 Arızası',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: ['Bobin 2 arızalı']),
  OBDCode(
      code: 'P1320',
      description: 'Ateşleme Bobini 3 Arızası',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: ['Bobin 3 arızalı']),
  OBDCode(
      code: 'P1325',
      description: 'Ateşleme Bobini 4 Arızası',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: ['Bobin 4 arızalı']),
  OBDCode(
      code: 'P1400',
      description: 'EGR Solenoid Kontrol Devresi',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['EGR solenoid arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P1450',
      description: 'EVAP Fazla Vakum',
      category: 'EVAP',
      severity: 'medium',
      possibleCauses: ['Purge valf sürekli açık', 'Yakıt kapağı sorunu']),
  OBDCode(
      code: 'P1500',
      description: 'Marş Kesici Rölesi Arızası',
      category: 'Elektrik',
      severity: 'medium',
      possibleCauses: ['Marş rölesi arızalı']),
  OBDCode(
      code: 'P1516',
      description: 'Gaz Kelebeği Aktüatör Kontrol Modülü TAC',
      category: 'Hava Sistemi',
      severity: 'high',
      possibleCauses: [
        'Elektronik gaz kelebeği arızalı',
        'TAC modülü arızalı'
      ]),
  OBDCode(
      code: 'P1600',
      description: 'ECM Şerit Test Arızası',
      category: 'ECU',
      severity: 'high',
      possibleCauses: ['ECU iç arıza', 'Yazılım hatası']),
  OBDCode(
      code: 'P1626',
      description: 'Immobilizer Sistemi Arızası',
      category: 'Immobilizer',
      severity: 'critical',
      possibleCauses: [
        'Anahtar transponder arızalı',
        'Immobilizer modülü arızalı'
      ]),
  OBDCode(
      code: 'P1700',
      description: 'Şanzıman Arıza Lambası Talep Devresi',
      category: 'Şanzıman',
      severity: 'high',
      possibleCauses: ['Şanzıman kontrol modülü hata tespit etti']),
  OBDCode(
      code: 'P1705',
      description: 'Şanzıman Giriş Hız Sensörü Arızası',
      category: 'Şanzıman',
      severity: 'high',
      possibleCauses: ['Giriş hız sensörü arızalı']),
  OBDCode(
      code: 'P1800',
      description: 'Şanzıman 4WD Düşük Aralık Solenoidi',
      category: 'Şanzıman',
      severity: 'medium',
      possibleCauses: ['4WD solenoid arızalı']),

  // P2xxx Kodları - Daha Fazla
  OBDCode(
      code: 'P2100',
      description: 'Gaz Kelebeği Aktüatör Kontrol Motor Devre Açık',
      category: 'Hava Sistemi',
      severity: 'critical',
      possibleCauses: ['Gaz kelebeği motoru arızalı', 'Kablo kopuk']),
  OBDCode(
      code: 'P2101',
      description: 'Gaz Kelebeği Aktüatör Kontrol Motor Performans',
      category: 'Hava Sistemi',
      severity: 'critical',
      possibleCauses: ['Gaz kelebeği kirli', 'Motor arızalı']),
  OBDCode(
      code: 'P2106',
      description: 'Gaz Kelebeği Aktüatör Sistemi - Zorla Rölanti',
      category: 'Hava Sistemi',
      severity: 'high',
      possibleCauses: ['Sistem güvenlik moduna girdi', 'APP veya TPS arızalı']),
  OBDCode(
      code: 'P2107',
      description: 'Gaz Kelebeği Aktüatör Kontrol Modülü İşlemci',
      category: 'Hava Sistemi',
      severity: 'critical',
      possibleCauses: ['TAC modülü arızalı']),
  OBDCode(
      code: 'P2108',
      description: 'Gaz Kelebeği Aktüatör Kontrol Modülü Performans',
      category: 'Hava Sistemi',
      severity: 'critical',
      possibleCauses: ['TAC modülü arızalı', 'Gaz kelebeği arızalı']),
  OBDCode(
      code: 'P2110',
      description: 'Gaz Kelebeği Aktüatör Sistemi - Zorla Sınırlı RPM',
      category: 'Hava Sistemi',
      severity: 'high',
      possibleCauses: ['Güvenlik modu aktif', 'Sensor arızası']),
  OBDCode(
      code: 'P2111',
      description: 'Gaz Kelebeği Aktüatör Sistemi Sıkışık Açık',
      category: 'Hava Sistemi',
      severity: 'critical',
      possibleCauses: ['Gaz kelebeği açık kalmış', 'Motor arızalı']),
  OBDCode(
      code: 'P2112',
      description: 'Gaz Kelebeği Aktüatör Sistemi Sıkışık Kapalı',
      category: 'Hava Sistemi',
      severity: 'critical',
      possibleCauses: ['Gaz kelebeği kapalı kalmış', 'Motor arızalı']),
  OBDCode(
      code: 'P2135',
      description: 'Gaz Pedal Konum Sensörü/Switch A/B Voltaj Korelasyonu',
      category: 'Hava Sistemi',
      severity: 'critical',
      possibleCauses: ['Gaz pedalı sensörü arızalı', 'Kablo hasarı']),
  OBDCode(
      code: 'P2138',
      description: 'Gaz Pedal Konum Sensörü D/E Voltaj Korelasyonu',
      category: 'Hava Sistemi',
      severity: 'critical',
      possibleCauses: ['APP sensörü arızalı']),
  OBDCode(
      code: 'P2176',
      description: 'Gaz Kelebeği Rölanti Pozisyon Öğrenilmedi',
      category: 'Hava Sistemi',
      severity: 'medium',
      possibleCauses: [
        'Adaptasyon yapılması gerekli',
        'Gaz kelebeği temizlendi'
      ]),
  OBDCode(
      code: 'P2177',
      description: 'Sistem Çok Fakir Sabit Rölanti Bank 1',
      category: 'Yakıt',
      severity: 'medium',
      possibleCauses: ['Vakum kaçağı', 'Enjektör tıkalı']),
  OBDCode(
      code: 'P2178',
      description: 'Sistem Çok Zengin Sabit Rölanti Bank 1',
      category: 'Yakıt',
      severity: 'medium',
      possibleCauses: ['Enjektör sızıntısı', 'MAP/MAF arızalı']),
  OBDCode(
      code: 'P2187',
      description: 'Sistem Çok Fakir Rölanti Bank 1',
      category: 'Yakıt',
      severity: 'medium',
      possibleCauses: ['Vakum kaçağı', 'Enjektör tıkalı']),
  OBDCode(
      code: 'P2188',
      description: 'Sistem Çok Zengin Rölanti Bank 1',
      category: 'Yakıt',
      severity: 'medium',
      possibleCauses: ['Enjektör sızıntısı']),
  OBDCode(
      code: 'P2195',
      description: 'O2 Sensörü Sürekli Fakir Bank 1 Sensör 1',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Vakum kaçağı', 'Lambda sensörü arızalı']),
  OBDCode(
      code: 'P2196',
      description: 'O2 Sensörü Sürekli Zengin Bank 1 Sensör 1',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Enjektör sızıntısı', 'Lambda sensörü arızalı']),
  OBDCode(
      code: 'P2197',
      description: 'O2 Sensörü Sürekli Fakir Bank 2 Sensör 1',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Vakum kaçağı']),
  OBDCode(
      code: 'P2198',
      description: 'O2 Sensörü Sürekli Zengin Bank 2 Sensör 1',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Enjektör sızıntısı']),
  OBDCode(
      code: 'P2270',
      description: 'O2 Sensörü Sürekli Fakir Bank 1 Sensör 2',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Katalitik konvertör sorunu', 'Lambda sensörü arızalı']),
  OBDCode(
      code: 'P2271',
      description: 'O2 Sensörü Sürekli Zengin Bank 1 Sensör 2',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Katalitik konvertör sorunu']),
  OBDCode(
      code: 'P2279',
      description: 'Hava Kaçağı Tespit Edildi',
      category: 'Hava Sistemi',
      severity: 'medium',
      possibleCauses: ['Emme manifoldu conta kaçağı', 'Hortum çatlak']),
  OBDCode(
      code: 'P2096',
      description: 'Katalitik Sonrası Yakıt Trim Çok Fakir Bank 1',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Katalitik konvertör verimsiz', 'Sensör arızalı']),
  OBDCode(
      code: 'P2097',
      description: 'Katalitik Sonrası Yakıt Trim Çok Zengin Bank 1',
      category: 'Emisyon',
      severity: 'medium',
      possibleCauses: ['Katalitik konvertör verimsiz']),
  OBDCode(
      code: 'P2263',
      description: 'Turbo Boost Sistemi Performans',
      category: 'Turbo',
      severity: 'high',
      possibleCauses: [
        'Turbo kaçağı',
        'Wastegate arızalı',
        'Boost hortumu patlamış'
      ]),
  OBDCode(
      code: 'P2300',
      description: 'Ateşleme Bobini A Birincil Düşük',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: ['Bobin arızalı', 'Kablo kısa devre']),
  OBDCode(
      code: 'P2301',
      description: 'Ateşleme Bobini A Birincil Yüksek',
      category: 'Ateşleme',
      severity: 'high',
      possibleCauses: ['Bobin arızalı']),
];

// Marka bazlı özel arıza kodları
final List<BrandSpecificCode> brandSpecificCodes = [
  // VOLKSWAGEN / AUDI / SKODA / SEAT (VAG)
  BrandSpecificCode(
    brandCode: 'VAG: 16395',
    genericCode: 'P0011',
    brand: 'Volkswagen/Audi/Skoda/Seat',
    description: 'Eksantrik Mili Pozisyonu Bank 1 Gecikmiş',
    detailedCause:
        'VVT (Variable Valve Timing) sistemi eksantrik milini zamanında konumlandıramıyor. Genellikle yağ basıncı düşük veya VVT solenoid arızalı.',
    solution:
        '1. Motor yağı seviyesi ve kalitesini kontrol edin\n2. VVT solenoid değiştirin\n3. Triger zinciri gerginliğini kontrol edin',
    estimatedCost: '500-3000 TL',
  ),
  BrandSpecificCode(
    brandCode: 'VAG: 16685',
    genericCode: 'P0301',
    brand: 'Volkswagen/Audi/Skoda/Seat',
    description: '1. Silindir Ateşleme Arızası',
    detailedCause:
        'TSI/TFSI motorlarda sık görülen buji/bobin arızası veya Karbon birikimi.',
    solution:
        '1. Buji değişimi\n2. Ateşleme bobini kontrolü\n3. Supap karbon temizliği',
    estimatedCost: '200-2000 TL',
  ),
  BrandSpecificCode(
    brandCode: 'VAG: 18034',
    genericCode: 'P1626',
    brand: 'Volkswagen/Audi/Skoda/Seat',
    description: 'Immobilizer Veri Yolu Hatası',
    detailedCause:
        'Anahtar tanıma sorunu veya immobilizer sisteminde iletişim hatası.',
    solution:
        '1. Anahtar bataryasını kontrol edin\n2. Yedek anahtarla deneyin\n3. Immobilizer programlama',
    estimatedCost: '200-1500 TL',
  ),

  // BMW
  BrandSpecificCode(
    brandCode: 'BMW: 2A82',
    genericCode: 'P0015',
    brand: 'BMW',
    description: 'VANOS Eksantrik Pozisyon Hatası',
    detailedCause:
        'VANOS sistemi (değişken valf zamanlaması) düzgün çalışmıyor. N20/N26 motorlarda yaygın.',
    solution:
        '1. VANOS solenoid temizliği veya değişimi\n2. Yağ filtresi ve yağ değişimi\n3. Triger zinciri kontrolü',
    estimatedCost: '1000-5000 TL',
  ),
  BrandSpecificCode(
    brandCode: 'BMW: 2A87',
    genericCode: 'P0012',
    brand: 'BMW',
    description: 'Emme VANOS Pozisyon Sapması',
    detailedCause:
        'Emme eksantrik VANOS aktüatörü belirlenen pozisyona ulaşamıyor.',
    solution:
        '1. VANOS solenoid değişimi\n2. Yağ basıncı kontrolü\n3. Motor yağı değişimi (BMW onaylı)',
    estimatedCost: '800-3000 TL',
  ),
  BrandSpecificCode(
    brandCode: 'BMW: 30FF',
    genericCode: 'N/A',
    brand: 'BMW',
    description: 'Yüksek Basınç Yakıt Sistemi Arızası',
    detailedCause:
        'Doğrudan enjeksiyonlu motorlarda yakıt pompası veya enjektör arızası.',
    solution:
        '1. Yüksek basınç pompası kontrolü\n2. Yakıt enjektör testi\n3. Yakıt basınç sensörü kontrolü',
    estimatedCost: '2000-8000 TL',
  ),

  // MERCEDES-BENZ
  BrandSpecificCode(
    brandCode: 'MB: P0455',
    genericCode: 'P0455',
    brand: 'Mercedes-Benz',
    description: 'EVAP Büyük Kaçak Tespit Edildi',
    detailedCause:
        'Mercedes modellerinde sık karşılaşılan yakıt kapağı veya EVAP sistemi sızıntısı.',
    solution:
        '1. Yakıt kapağını kontrol edin ve sıkıca kapatın\n2. EVAP kanistresi ve hortumları kontrol edin',
    estimatedCost: '100-1500 TL',
  ),
  BrandSpecificCode(
    brandCode: 'MB: P2008',
    genericCode: 'P2008',
    brand: 'Mercedes-Benz',
    description: 'Emme Manifoldu Klapesi Açık Kalmış',
    detailedCause:
        'Swirl flap veya emme manifoldu içindeki klapeler karbon birikimi nedeniyle sıkışmış.',
    solution:
        '1. Emme manifoldu temizliği\n2. Klape aktüatör değişimi\n3. Manifold yenileme',
    estimatedCost: '1500-5000 TL',
  ),

  // RENAULT
  BrandSpecificCode(
    brandCode: 'DF002',
    genericCode: 'P0100',
    brand: 'Renault',
    description: 'Hava Debimetresi Arızası',
    detailedCause: 'Renault motorlarda sık görülen hava akış sensörü arızası.',
    solution:
        '1. Debimetre temizliği\n2. Debimetre değişimi\n3. Hava filtresi kontrolü',
    estimatedCost: '300-1500 TL',
  ),
  BrandSpecificCode(
    brandCode: 'DF019',
    genericCode: 'P0340',
    brand: 'Renault',
    description: 'Eksantrik Mili Sensörü Sinyal Yok',
    detailedCause: 'Dacia/Renault K9K dizel motorlarda yaygın sensör arızası.',
    solution: '1. Sensör değişimi\n2. Kablo kontrolü\n3. ECU bağlantı kontrolü',
    estimatedCost: '200-800 TL',
  ),

  // FIAT
  BrandSpecificCode(
    brandCode: 'FIAT: P1139',
    genericCode: 'P0131',
    brand: 'Fiat',
    description: 'Lambda Sensörü Bank 1 Düşük Voltaj',
    detailedCause:
        'Egea ve Doblo modellerinde sık görülen lambda sensörü arızası.',
    solution:
        '1. Lambda sensörü değişimi\n2. Egzoz sızıntısı kontrolü\n3. Kablo kontrolü',
    estimatedCost: '400-1200 TL',
  ),
  BrandSpecificCode(
    brandCode: 'FIAT: P0606',
    genericCode: 'P0606',
    brand: 'Fiat',
    description: 'ECU İşlemci Hatası',
    detailedCause: 'MultiJet motorlarda ECU yazılım veya donanım sorunu.',
    solution:
        '1. ECU yazılım güncelleme\n2. Akü bağlantıları temizleme\n3. ECU değişimi (son çare)',
    estimatedCost: '500-5000 TL',
  ),

  // FORD
  BrandSpecificCode(
    brandCode: 'FORD: P0401',
    genericCode: 'P0401',
    brand: 'Ford',
    description: 'EGR Akışı Yetersiz',
    detailedCause: 'Ford Duratorq ve EcoBoost motorlarda EGR karbon birikimi.',
    solution:
        '1. EGR valfi temizliği\n2. EGR soğutucu kontrolü\n3. EGR valfi değişimi',
    estimatedCost: '300-2500 TL',
  ),
  BrandSpecificCode(
    brandCode: 'FORD: P2263',
    genericCode: 'P2263',
    brand: 'Ford',
    description: 'Turbo/Süperşarj Basınç Performans',
    detailedCause: 'Transit ve Focus modellerinde turbo basınç sorunu.',
    solution:
        '1. Turbo hortumları kontrol edin\n2. Wastegate kontrolü\n3. Turbo değişimi',
    estimatedCost: '500-8000 TL',
  ),

  // TOYOTA
  BrandSpecificCode(
    brandCode: 'TOYOTA: P0171',
    genericCode: 'P0171',
    brand: 'Toyota',
    description: 'Sistem Çok Fakir Bank 1',
    detailedCause:
        'Corolla ve Yaris modellerinde vakum kaçağı veya MAF sensörü sorunu.',
    solution:
        '1. Vakum hortumları kontrol edin\n2. MAF sensörü temizliği\n3. Enjektör temizliği',
    estimatedCost: '200-1500 TL',
  ),

  // HYUNDAI/KIA
  BrandSpecificCode(
    brandCode: 'HYU: P0014',
    genericCode: 'P0014',
    brand: 'Hyundai/Kia',
    description: 'CVVT Eksantrik Pozisyon Erken',
    detailedCause:
        'GDI motorlarda CVVT sistemi arızası. Yağ değişimi gecikmelerinde sık görülür.',
    solution:
        '1. Motor yağı ve filtre değişimi\n2. CVVT solenoid değişimi\n3. Yağ pompası kontrolü',
    estimatedCost: '400-3000 TL',
  ),
  BrandSpecificCode(
    brandCode: 'HYU: P1326',
    genericCode: 'N/A',
    brand: 'Hyundai/Kia',
    description: 'KSDS - Motor Vuruntu Tespit Sistemi',
    detailedCause:
        'Theta II motorlarda güvenlik recall kapsamında motor vuruntu uyarısı.',
    solution:
        '1. Yetkili servise başvurun\n2. Motor yazılım güncelleme\n3. Motor iç kontrol',
    estimatedCost: 'Kampanya kapsamında ücretsiz olabilir',
  ),

  // PEUGEOT/CITROEN
  BrandSpecificCode(
    brandCode: 'PSA: P1351',
    genericCode: 'N/A',
    brand: 'Peugeot/Citroen',
    description: 'Kızdırma Bujisi Ön Isıtma Rölesi Arızası',
    detailedCause: 'HDI dizel motorlarda kızdırma sistemi arızası.',
    solution:
        '1. Kızdırma rölesini kontrol edin\n2. Kızdırma bujilerini test edin\n3. Röle değişimi',
    estimatedCost: '200-1000 TL',
  ),
  BrandSpecificCode(
    brandCode: 'PSA: P0492',
    genericCode: 'P0492',
    brand: 'Peugeot/Citroen',
    description: 'İkincil Hava Enjeksiyonu Yetersiz Bank 2',
    detailedCause: 'Emisyon kontrol sistemi pompa veya valf arızası.',
    solution:
        '1. İkincil hava pompası kontrolü\n2. Valf kontrolü\n3. Hortum sızıntısı kontrolü',
    estimatedCost: '300-2000 TL',
  ),

  // OPEL
  BrandSpecificCode(
    brandCode: 'OPEL: P0135',
    genericCode: 'P0135',
    brand: 'Opel',
    description: 'Lambda Sensörü Isıtıcı Arızası Bank 1 Sensör 1',
    detailedCause:
        'Astra ve Corsa modellerinde lambda sensörü ısıtıcı devresi arızası.',
    solution:
        '1. Lambda sensörü değişimi\n2. Sigorta kontrolü\n3. Kablo kontrolü',
    estimatedCost: '400-1200 TL',
  ),
];

// Arama fonksiyonları
List<OBDCode> searchOBDCode(String query) {
  final searchTerm = query.toUpperCase().trim();
  return obdCodes
      .where((code) =>
          code.code.contains(searchTerm) ||
          code.description.toLowerCase().contains(query.toLowerCase()) ||
          code.category.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

List<BrandSpecificCode> searchBrandCode(String query, {String? brand}) {
  final searchTerm = query.toUpperCase().trim();
  return brandSpecificCodes.where((code) {
    final matchesSearch = code.brandCode.toUpperCase().contains(searchTerm) ||
        code.genericCode.toUpperCase().contains(searchTerm) ||
        code.description.toLowerCase().contains(query.toLowerCase());
    final matchesBrand =
        brand == null || code.brand.toLowerCase().contains(brand.toLowerCase());
    return matchesSearch && matchesBrand;
  }).toList();
}

List<OBDCode> getCodesByCategory(String category) {
  return obdCodes.where((code) => code.category == category).toList();
}

List<OBDCode> getCodesBySeverity(String severity) {
  return obdCodes.where((code) => code.severity == severity).toList();
}

List<String> getAllCategories() {
  return obdCodes.map((code) => code.category).toSet().toList()..sort();
}

Color getSeverityColor(String severity) {
  switch (severity) {
    case 'low':
      return const Color(0xFF22C55E);
    case 'medium':
      return const Color(0xFFF59E0B);
    case 'high':
      return const Color(0xFFEF4444);
    case 'critical':
      return const Color(0xFFA855F7);
    default:
      return const Color(0xFF64748B);
  }
}

String getSeverityText(String severity) {
  switch (severity) {
    case 'low':
      return 'Düşük';
    case 'medium':
      return 'Orta';
    case 'high':
      return 'Yüksek';
    case 'critical':
      return 'Kritik';
    default:
      return 'Bilinmiyor';
  }
}

String getSeverityEmoji(String severity) {
  switch (severity) {
    case 'low':
      return '🟢';
    case 'medium':
      return '🟡';
    case 'high':
      return '🟠';
    case 'critical':
      return '🔴';
    default:
      return '⚪';
  }
}
