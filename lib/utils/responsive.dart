// Responsive Utility Class - Mobil, Tablet ve Masaüstü ekran uyumu
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late bool isSmallScreen;
  static late bool isMediumScreen;
  static late bool isLargeScreen;
  static late bool isTablet;
  static late bool isDesktop;
  static late double _scaleFactor;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;

    // Ekran boyutu kategorileri
    isSmallScreen = screenWidth < 360;
    isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    isLargeScreen = screenWidth >= 600 && screenWidth < 1024;
    isTablet = _mediaQueryData.size.shortestSide >= 600;
    isDesktop = screenWidth >= 1024 || _isDesktopPlatform;

    // Ölçek faktörü - masaüstünde aşırı büyüme olmasın
    if (isDesktop) {
      _scaleFactor = (screenWidth / 1280).clamp(0.75, 1.1);
    } else if (isTablet) {
      _scaleFactor = (screenWidth / 375).clamp(0.8, 1.5);
    } else {
      _scaleFactor = (screenWidth / 375).clamp(0.8, 1.2);
    }
  }

  static bool get _isDesktopPlatform {
    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  // Yatay ölçekleme (genişlik bazlı)
  static double wp(double percentage) => blockSizeHorizontal * percentage;

  // Dikey ölçekleme (yükseklik bazlı)
  static double hp(double percentage) => blockSizeVertical * percentage;

  // Güvenli alan içinde yatay ölçekleme
  static double swp(double percentage) => safeBlockHorizontal * percentage;

  // Güvenli alan içinde dikey ölçekleme
  static double shp(double percentage) => safeBlockVertical * percentage;

  // Dinamik font boyutu
  static double fontSize(double size) => size * _scaleFactor;

  // Dinamik padding
  static double padding(double size) => size * _scaleFactor;

  // Dinamik icon boyutu
  static double iconSize(double size) => size * _scaleFactor;

  // Dinamik border radius
  static double radius(double size) => size * _scaleFactor;

  // Dinamik widget boyutu (genişlik/yükseklik)
  static double size(double value) => value * _scaleFactor;

  // Grid için sütun sayısı
  static int gridColumns(int defaultCount) {
    if (isDesktop) return defaultCount + 3;
    if (isTablet) return defaultCount + 2;
    if (isSmallScreen) return (defaultCount - 1).clamp(1, 10);
    if (isLargeScreen) return defaultCount + 1;
    return defaultCount;
  }

  // Menü grid sütun sayısı
  static int get menuColumns {
    if (isDesktop) return 5;
    if (isTablet) return 4;
    return 3;
  }

  // Durum kartları sütun sayısı
  static int get statusColumns {
    if (isDesktop) return 4;
    if (isTablet) return 4;
    return 2;
  }

  // Kart boyutları için aspect ratio
  static double cardAspectRatio({double defaultRatio = 1.0}) {
    if (isDesktop) return defaultRatio * 1.3;
    if (isTablet) return defaultRatio * 1.2;
    if (isSmallScreen) return defaultRatio * 0.9;
    if (isLargeScreen) return defaultRatio * 1.1;
    return defaultRatio;
  }

  // Tarama alanı yüksekliği
  static double get scanAreaHeight {
    if (isDesktop) return 350;
    return isTablet ? 320 : 220;
  }

  static double get scanPainterWidth {
    if (isDesktop) return 450;
    return isTablet ? 400 : 280;
  }

  static double get scanPainterHeight {
    if (isDesktop) return 280;
    return isTablet ? 260 : 180;
  }

  // Araç görseli boyutu
  static double get vehicleImageWidth {
    if (isDesktop) return 350;
    return isTablet ? 300 : 200;
  }

  static double get vehicleImageHeight {
    if (isDesktop) return 230;
    return isTablet ? 200 : 130;
  }

  // Responsive padding
  static EdgeInsets get horizontalPadding => EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : (isTablet ? 32 : 16),
      );

  // Max content width - masaüstünde içeriği sınırla
  static double get maxContentWidth {
    if (isDesktop) return 900;
    if (isTablet) return 800;
    return screenWidth;
  }

  // Dialog genişliği
  static double get dialogWidth {
    if (isDesktop) return 550;
    if (isTablet) return 500;
    return 340;
  }
}

// Responsive Widget Builder
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
      BuildContext context, bool isSmall, bool isMedium, bool isLarge) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isSmall = width < 360;
        final isMedium = width >= 360 && width < 600;
        final isLarge = width >= 600;

        Responsive.init(context);

        return builder(context, isSmall, isMedium, isLarge);
      },
    );
  }
}

// Extension methods for responsive sizing
extension ResponsiveExtension on num {
  double get w => Responsive.wp(toDouble());
  double get h => Responsive.hp(toDouble());
  double get sp => Responsive.fontSize(toDouble());
}

/// Masaüstünde içeriği ortada ve sınırlı genişlikte tutan wrapper
class DesktopContentWrapper extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const DesktopContentWrapper({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? Responsive.maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}
