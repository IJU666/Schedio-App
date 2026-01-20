// main.dart
// ========================================
// MAIN - DENGAN THEME PROVIDER
// ========================================

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:schedule_app/views/daftar_tugas_page.dart';
import 'package:schedule_app/views/home_page.dart';
import 'package:schedule_app/views/kalender_page.dart';
import 'package:schedule_app/views/pengaturan_page.dart';
import 'package:schedule_app/views/tambah_kelas_page.dart';
import 'package:schedule_app/views/tambah_tugas_page.dart';
import 'models/mata_kuliah.dart';
import 'models/tugas.dart';
import 'models/jadwal.dart';
import 'controllers/theme_controller.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Indonesian locale
  await initializeDateFormatting('id_ID', null);
  
// Initialize Hive
await Hive.initFlutter();

// Register Adapters
Hive.registerAdapter(MataKuliahAdapter());
Hive.registerAdapter(TugasAdapter());
Hive.registerAdapter(JadwalAdapter());

// Open Boxes
  await Hive.openBox<MataKuliah>('mataKuliahBox');
  await Hive.openBox<Tugas>('tugasBox');
  await Hive.openBox<Jadwal>('jadwalBox');

  
  runApp(
    // Provider untuk Theme Management
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return MaterialApp(
          title: 'Schedule App',
          
          // Dark Theme
          theme: ThemeController.lightTheme,
          
          // Light Theme
          darkTheme: ThemeController.darkTheme,
          
          // Theme Mode dari Controller
          themeMode: themeController.themeMode,
          
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),

          routes: {
            '/home': (context) => const HomePage(),
            '/daftarTugas': (context) => const DaftarTugasPage(),
            '/kalender': (context) => const KalenderPage(),
            '/pengaturan': (context) => const PengaturanPage(),
            '/tambahKelas': (context) => const TambahKelasPage(),
            '/tambahTugas': (context) => const TambahTugasPage()
          },
        );
      },
    );
  }
}