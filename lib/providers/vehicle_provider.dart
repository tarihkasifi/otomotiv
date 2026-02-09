// Araç Bilgisi Provider
import 'package:flutter/foundation.dart';

class VehicleInfo {
  final String brand;
  final String model;
  final int? year;
  final String fuelType;

  VehicleInfo({
    required this.brand,
    required this.model,
    this.year,
    required this.fuelType,
  });

  bool get isComplete => brand.isNotEmpty && model.isNotEmpty && fuelType.isNotEmpty;

  String get displayName {
    final yearStr = year != null ? ' ($year)' : '';
    return '$brand $model$yearStr - $fuelType';
  }

  Map<String, dynamic> toJson() => {
    'brand': brand,
    'model': model,
    'year': year,
    'fuelType': fuelType,
  };
}

class VehicleProvider with ChangeNotifier {
  String _brand = '';
  String _model = '';
  int? _year;
  String _fuelType = '';

  String get brand => _brand;
  String get model => _model;
  int? get year => _year;
  String get fuelType => _fuelType;

  bool get isVehicleSelected => _brand.isNotEmpty && _model.isNotEmpty && _fuelType.isNotEmpty;

  VehicleInfo get vehicleInfo => VehicleInfo(
    brand: _brand,
    model: _model,
    year: _year,
    fuelType: _fuelType,
  );

  void setBrand(String brand) {
    _brand = brand;
    _model = ''; // Reset model when brand changes
    notifyListeners();
  }

  void setModel(String model) {
    _model = model;
    notifyListeners();
  }

  void setYear(int? year) {
    _year = year;
    notifyListeners();
  }

  void setFuelType(String fuelType) {
    _fuelType = fuelType;
    notifyListeners();
  }

  void reset() {
    _brand = '';
    _model = '';
    _year = null;
    _fuelType = '';
    notifyListeners();
  }
}
