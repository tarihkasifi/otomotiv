# 🚗 Araç Arıza Tespit Uygulaması

AI destekli Flutter mobil uygulaması - Gerçek zamanlı ses analizi ile araç arızalarını tespit edin.

## ✨ Özellikler

- 🎤 **Gerçek Zamanlı Ses Kaydı** - flutter_audio_capture ile canlı ses stream'i
- 📟 **OBD-II Kod Analizi** - 35+ hata kodu veritabanı
- 📋 **Semptom Bazlı Teşhis** - 9 kategori, 40+ semptom
- 🤖 **Google Gemini AI** - Akıllı arıza analizi
- 🚙 **20+ Araç Markası** - Türkiye pazarına özel veritabanı

## 🚀 Kurulum

### 1. Flutter SDK Kurulumu

1. [Flutter](https://docs.flutter.dev/get-started/install) indirin
2. Sisteme kurun ve PATH'e ekleyin
3. `flutter doctor` ile kontrol edin

### 2. Bağımlılıkları Yükleyin

```bash
cd c:\Users\forum\Desktop\Otomotiv
flutter pub get
```

### 3. Uygulamayı Çalıştırın

```bash
# Android cihaz/emulator için
flutter run

# Windows için
flutter run -d windows
```

## 📁 Proje Yapısı

```
lib/
├── main.dart                    # Ana uygulama
├── providers/
│   └── vehicle_provider.dart    # Araç state yönetimi
├── screens/
│   ├── home_screen.dart         # Ana ekran
│   ├── audio_analysis_screen.dart # Ses analizi
│   ├── obd_code_screen.dart     # OBD-II kod
│   └── symptom_screen.dart      # Semptom seçimi
├── services/
│   ├── audio_service.dart       # Ses stream servisi
│   └── gemini_service.dart      # AI servisi
├── data/
│   ├── vehicles.dart            # Araç veritabanı
│   ├── obd_codes.dart           # OBD kodları
│   └── symptoms.dart            # Semptomlar
├── widgets/
│   └── diagnosis_result_view.dart # Sonuç görünümü
└── theme/
    └── app_theme.dart           # Tema ayarları
```

## 🔑 API Anahtarı

Google Gemini API anahtarı `lib/services/gemini_service.dart` dosyasında ayarlanmıştır.

## 📱 Desteklenen Platformlar

- ✅ Android
- ✅ iOS
- ✅ Windows (ses kaydı sınırlı)

## ⚠️ Önemli Notlar

- Bu uygulama tahmini teşhis sağlar
- Kesin sonuç için yetkili servise başvurun
- Ses kaydı için mikrofon izni gereklidir
