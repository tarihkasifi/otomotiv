# Placeholder Model Directory

TFLite modelleri bu klasöre yerleştirilmelidir.

## Desteklenen Model Formatları
- `.tflite` - TensorFlow Lite model dosyaları

## Kullanım
Model dosyasını bu klasöre koyun ve `TFLiteService` içindeki yolu güncelleyin:

```dart
_interpreter = await Interpreter.fromAsset('models/audio_classifier.tflite');
```

## Not
Şu an placeholder heuristic tabanlı sınıflandırma kullanılmaktadır. 
Gerçek bir model eğitildiğinde buraya eklenmeli.
