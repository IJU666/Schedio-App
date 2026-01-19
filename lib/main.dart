import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/mata_kuliah.dart';
import 'models/tugas.dart';
import 'models/jadwal.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Indonesian locale
  await initializeDateFormatting('id_ID', null);
  
  await Hive.initFlutter();
  
  Hive.registerAdapter(MataKuliahAdapter());
  Hive.registerAdapter(TugasAdapter());
  Hive.registerAdapter(JadwalAdapter());
  
  await Hive.openBox<MataKuliah>('mataKuliahBox');
  await Hive.openBox<Tugas>('tugasBox');
  await Hive.openBox<Jadwal>('jadwalBox');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule App',
      theme: ThemeData(
        primaryColor: const Color(0xFF1E2936),
        scaffoldBackgroundColor: const Color(0xFF1E2936),
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}