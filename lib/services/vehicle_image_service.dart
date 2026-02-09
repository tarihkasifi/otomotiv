// Araç Görsel Servisi
// VIN ve araç bilgisine göre araç görseli URL'si döndürür

class VehicleImageService {
  // Araç marka logoları
  static final Map<String, String> _brandLogos = {
    'toyota': 'https://www.carlogos.org/car-logos/toyota-logo.png',
    'ford': 'https://www.carlogos.org/car-logos/ford-logo.png',
    'volkswagen': 'https://www.carlogos.org/car-logos/volkswagen-logo.png',
    'bmw': 'https://www.carlogos.org/car-logos/bmw-logo.png',
    'mercedes': 'https://www.carlogos.org/car-logos/mercedes-benz-logo.png',
    'audi': 'https://www.carlogos.org/car-logos/audi-logo.png',
    'honda': 'https://www.carlogos.org/car-logos/honda-logo.png',
    'hyundai': 'https://www.carlogos.org/car-logos/hyundai-logo.png',
    'kia': 'https://www.carlogos.org/car-logos/kia-logo.png',
    'renault': 'https://www.carlogos.org/car-logos/renault-logo.png',
    'fiat': 'https://www.carlogos.org/car-logos/fiat-logo.png',
    'peugeot': 'https://www.carlogos.org/car-logos/peugeot-logo.png',
    'opel': 'https://www.carlogos.org/car-logos/opel-logo.png',
    'nissan': 'https://www.carlogos.org/car-logos/nissan-logo.png',
    'mazda': 'https://www.carlogos.org/car-logos/mazda-logo.png',
    'chevrolet': 'https://www.carlogos.org/car-logos/chevrolet-logo.png',
    'volvo': 'https://www.carlogos.org/car-logos/volvo-logo.png',
    'skoda': 'https://www.carlogos.org/car-logos/skoda-logo.png',
    'seat': 'https://www.carlogos.org/car-logos/seat-logo.png',
    'citroen': 'https://www.carlogos.org/car-logos/citroen-logo.png',
    'dacia': 'https://www.carlogos.org/car-logos/dacia-logo.png',
    'suzuki': 'https://www.carlogos.org/car-logos/suzuki-logo.png',
    'mitsubishi': 'https://www.carlogos.org/car-logos/mitsubishi-logo.png',
    'subaru': 'https://www.carlogos.org/car-logos/subaru-logo.png',
    'lexus': 'https://www.carlogos.org/car-logos/lexus-logo.png',
    'porsche': 'https://www.carlogos.org/car-logos/porsche-logo.png',
    'jaguar': 'https://www.carlogos.org/car-logos/jaguar-logo.png',
    'land rover': 'https://www.carlogos.org/car-logos/land-rover-logo.png',
    'jeep': 'https://www.carlogos.org/car-logos/jeep-logo.png',
    'alfa romeo': 'https://www.carlogos.org/car-logos/alfa-romeo-logo.png',
    'mini': 'https://www.carlogos.org/car-logos/mini-logo.png',
    'tesla': 'https://www.carlogos.org/car-logos/tesla-logo.png',
  };

  // VIN kodundan üretici belirleme (WMI - ilk 3 karakter)
  static final Map<String, String> _vinManufacturers = {
    'WVW': 'Volkswagen',
    'WBA': 'BMW',
    'WDB': 'Mercedes-Benz',
    'WAU': 'Audi',
    'TMB': 'Skoda',
    'VF1': 'Renault',
    'VF3': 'Peugeot',
    'VF7': 'Citroen',
    'ZFA': 'Fiat',
    'ZAR': 'Alfa Romeo',
    'JTD': 'Toyota',
    'JHM': 'Honda',
    'KMH': 'Hyundai',
    'KNA': 'Kia',
    '1FA': 'Ford',
    '1G1': 'Chevrolet',
    '5TD': 'Toyota',
    'JN1': 'Nissan',
    'JMZ': 'Mazda',
    'YV1': 'Volvo',
    'VSS': 'Seat',
    'UU1': 'Dacia',
    'JS1': 'Suzuki',
    'JA3': 'Mitsubishi',
    'JF1': 'Subaru',
    'WP0': 'Porsche',
    'SAJ': 'Jaguar',
    'SAL': 'Land Rover',
    '1C4': 'Jeep',
    'WMW': 'Mini',
    '5YJ': 'Tesla',
    'JTH': 'Lexus',
  };

  /// VIN'den üretici adını çöz
  static String? getManufacturerFromVin(String vin) {
    if (vin.length < 3) return null;
    final wmi = vin.substring(0, 3).toUpperCase();
    return _vinManufacturers[wmi];
  }

  /// Marka adından logo URL'si al
  static String? getBrandLogoUrl(String brandName) {
    final normalizedBrand = brandName.toLowerCase().trim();

    // Direkt eşleşme
    if (_brandLogos.containsKey(normalizedBrand)) {
      return _brandLogos[normalizedBrand];
    }

    // Kısmi eşleşme
    for (final entry in _brandLogos.entries) {
      if (normalizedBrand.contains(entry.key) ||
          entry.key.contains(normalizedBrand)) {
        return entry.value;
      }
    }

    return null;
  }

  /// Araç bilgisinden görsel URL'si oluştur
  static Future<VehicleImageResult> getVehicleImage(
      String? vin, String? vehicleName) async {
    String? manufacturer;
    String? logoUrl;
    String displayName = 'Bilinmeyen Araç';

    // Önce VIN'den üreticiyi bulmaya çalış
    if (vin != null && vin.length >= 3) {
      manufacturer = getManufacturerFromVin(vin);
      if (manufacturer != null) {
        logoUrl = getBrandLogoUrl(manufacturer);
        displayName = manufacturer;
      }
    }

    // VIN'den bulunamadıysa araç adından dene
    if (logoUrl == null && vehicleName != null) {
      for (final brand in _brandLogos.keys) {
        if (vehicleName.toLowerCase().contains(brand)) {
          logoUrl = _brandLogos[brand];
          displayName = brand[0].toUpperCase() + brand.substring(1);
          break;
        }
      }
    }

    return VehicleImageResult(
      logoUrl: logoUrl,
      displayName: displayName,
      manufacturer: manufacturer,
    );
  }

  /// Google Custom Search API ile araç görseli ara (opsiyonel)
  static Future<String?> searchVehicleImage(String query) async {
    // Not: Bu özellik için Google Custom Search API key gerekli
    // Şimdilik logo kullanıyoruz
    return null;
  }
}

class VehicleImageResult {
  final String? logoUrl;
  final String displayName;
  final String? manufacturer;

  VehicleImageResult({
    this.logoUrl,
    required this.displayName,
    this.manufacturer,
  });
}
