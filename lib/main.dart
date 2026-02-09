// Ana Uygulama - Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/vehicle_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/entry_screen.dart';
import 'screens/dashboard_home_screen.dart';
import 'screens/audio_analysis_screen.dart';
import 'screens/obd_code_screen.dart';
import 'screens/obd_connection_screen.dart';
import 'screens/symptom_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Araç Arıza Tespit',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            initialRoute: '/',
            routes: {
              '/': (context) => const EntryScreen(),
              '/dashboard-a': (context) => const DashboardHomeScreen(),
              '/audio-analysis': (context) => const AudioAnalysisScreen(),
              '/obd-code': (context) => const OBDCodeScreen(),
              '/obd-connection': (context) => const OBDConnectionScreen(),
              '/symptom': (context) => const SymptomScreen(),
              '/chat': (context) => const ChatScreen(),
            },
          );
        },
      ),
    );
  }
}
