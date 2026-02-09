// Platform Utility - Platform bağımlı kontroller
import 'dart:io' show Platform;

class PlatformUtils {
  /// Masaüstü platformu mu?
  static bool get isDesktop {
    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  /// Mobil platform mu?
  static bool get isMobile {
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }

  /// Bluetooth destekleniyor mu?
  static bool get isBluetoothSupported {
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }

  /// Mikrofon/ses kaydı destekleniyor mu?
  static bool get isAudioRecordingSupported {
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }

  /// İzin sistemi destekleniyor mu?
  static bool get isPermissionSupported {
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }
}
