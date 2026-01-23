// views/pengaturan_page.dart
// ========================================
// PENGATURAN PAGE - DENGAN DYNAMIC DATA DARI DATABASE
// ========================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/theme_controller.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/mata_kuliah_controller.dart';
import '../controllers/jadwal_controller.dart';
import '../controllers/tugas_controller.dart';
import '../services/schedule_manager.dart';
import '../services/notification_preference_service.dart';
import '../models/mata_kuliah.dart';
import '../models/jadwal.dart';
import '../widgets/modern_bottom_navbar.dart';
import 'tambah_kelas_page.dart';
import 'edit_kelas_page.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({Key? key}) : super(key: key);

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  bool isPengingatEnabled = true;
  bool _isLoadingPreference = true;
  final NavigationController _navigationController = NavigationController();
  final MataKuliahController _mataKuliahController = MataKuliahController();
  final JadwalController _jadwalController = JadwalController();
  final TugasController _tugasController = TugasController();
  final ScheduleManager _scheduleManager = ScheduleManager();
  final NotificationPreferenceService _preferenceService = NotificationPreferenceService();
  
  List<CourseItemData> courses = [];

  @override
  void initState() {
    super.initState();
    _navigationController.setIndex(4);
    _loadCourses();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final enabled = await _preferenceService.isNotificationEnabled();
    setState(() {
      isPengingatEnabled = enabled;
      _isLoadingPreference = false;
    });
  }

  void _loadCourses() {
    // Ambil semua mata kuliah dan jadwal dari controller
    final allMataKuliah = _mataKuliahController.getAllMataKuliah();
    final allJadwal = _jadwalController.getAllJadwal();
    
    setState(() {
      courses = allMataKuliah.map((mataKuliah) {
        // Cari jadwal yang sesuai dengan mata kuliah ini
        final jadwal = allJadwal.firstWhere(
          (j) => j.mataKuliahId == mataKuliah.id,
          orElse: () => Jadwal(
            id: '',
            mataKuliahId: mataKuliah.id,
            hari: '',
            jamMulai: '',
            jamSelesai: '',
            ruangan: '',
          ),
        );
        
        return CourseItemData(
          jadwalId: jadwal.id,
          name: '${mataKuliah.kode.isNotEmpty ? mataKuliah.kode + ' - ' : ''}${mataKuliah.nama}',
          color: _hexToColor(mataKuliah.warna),
        );
      }).toList();
    });
  }

  Color _hexToColor(String hexString) {
    if (hexString.isEmpty) return const Color(0xFF7AB8FF);
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToEditKelas(String jadwalId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditKelasPage(jadwalId: jadwalId),
      ),
    );
    
    // Reload courses jika ada perubahan
    if (result == true) {
      _loadCourses();
    }
  }

  Future<void> _navigateToTambahKelas() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TambahKelasPage()),
    );
    
    // Reload courses setelah menambah kelas baru
    if (result == true || result == null) {
      _loadCourses();
    }
  }

  Future<void> _handlePengingatToggle(bool value) async {
    setState(() {
      isPengingatEnabled = value;
    });

    // Simpan preference
    await _preferenceService.setNotificationEnabled(value);

    // Resync semua notifikasi (kelas dan tugas)
    if (value) {
      // Aktifkan: Schedule ulang semua notifikasi
      await _scheduleManager.resyncAllNotifications();
      await _tugasController.resyncAllTaskNotifications();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🔔 Pengingat diaktifkan untuk semua tugas dan kelas'),
            backgroundColor: Color(0xFF4ECCA3),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Nonaktifkan: Cancel semua notifikasi
      await _scheduleManager.resyncAllNotifications(); // Akan cancel semua karena toggle off
      await _tugasController.resyncAllTaskNotifications(); // Akan cancel semua karena toggle off
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🔕 Pengingat dinonaktifkan untuk semua tugas dan kelas'),
            backgroundColor: Color(0xFFFF6B6B),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Pengaturan',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Pengaturan Kelas Section
                Text(
                  'Pengaturan Kelas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Course List - Dynamic from Database
                if (courses.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1A1F3A) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 48,
                            color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada kelas',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tambah kelas baru dengan tombol + di bawah',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.grey[700] : Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...courses.map((course) => _buildCourseItem(
                    course, 
                    isDarkMode, 
                    cardColor, 
                    textColor
                  )).toList(),
                
                const SizedBox(height: 24),
                
                // Pengingat Toggle
                if (_isLoadingPreference)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pengingat',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Notifikasi untuk semua tugas dan kelas',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isPengingatEnabled,
                          onChanged: _handlePengingatToggle,
                          activeColor: const Color(0xFF4ECDC4),
                          activeTrackColor: const Color(0xFF4ECDC4).withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                
                // Dark Mode Toggle
                Consumer<ThemeController>(
                  builder: (context, themeController, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                themeController.isDarkMode 
                                    ? Icons.dark_mode 
                                    : Icons.light_mode,
                                color: const Color(0xFF7AB8FF),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Dark mode',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: themeController.isDarkMode,
                            onChanged: (bool value) {
                              themeController.toggleTheme();
                            },
                            activeColor: const Color(0xFF4ECDC4),
                            activeTrackColor: const Color(0xFF4ECDC4).withOpacity(0.5),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      
      // Modern Bottom Navbar
      bottomNavigationBar: ModernBottomNavbar(
        controller: _navigationController,
        currentIndex: 4,
        onAddPressed: _navigateToTambahKelas,
      ),
    );
  }

  Widget _buildCourseItem(
    CourseItemData course, 
    bool isDarkMode, 
    Color cardColor, 
    Color textColor
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1F3A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _navigateToEditKelas(course.jadwalId),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Color indicator - Warna dari input user
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: course.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              // Course name - Nama dari input user
              Expanded(
                child: Text(
                  course.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              // Edit button
              Row(
                children: [
                  Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    color: textColor,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseItemData {
  final String jadwalId;
  final String name;
  final Color color;

  CourseItemData({
    required this.jadwalId,
    required this.name,
    required this.color,
  });
}