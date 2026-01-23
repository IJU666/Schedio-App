// views/home_page.dart
// ========================================
// HOME PAGE - DENGAN DROPDOWN TUGAS
// ========================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../controllers/jadwal_controller.dart';
import '../controllers/tugas_controller.dart';
import '../controllers/mata_kuliah_controller.dart';
import '../controllers/navigation_controller.dart';
import '../models/jadwal.dart';
import '../models/tugas.dart';
import '../services/schedule_manager.dart';
import '../models/mata_kuliah.dart';
import '../widgets/modern_bottom_navbar.dart';
import 'tambah_tugas_page.dart';
import 'tambah_kelas_page.dart';
import 'edit_kelas_page.dart';
import 'edit_tugas_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final JadwalController _jadwalController = JadwalController();
  final TugasController _tugasController = TugasController();
  final MataKuliahController _mataKuliahController = MataKuliahController();
  final NavigationController _navigationController = NavigationController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _navigationController.setIndex(0);
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexString) {
    if (hexString.isEmpty) return const Color(0xFF7AB8FF);
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  bool _isLate(Tugas tugas) {
    final now = DateTime.now();
    return now.isAfter(tugas.tanggal) && !tugas.checklistStatus.every((s) => s);
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
        bottom: false,
        child: Column(
          children: [
            _buildHeader(textColor),
            _buildDateGridSelector(isDarkMode, cardColor, textColor),
            Expanded(
              child: _buildScheduleList(isDarkMode, cardColor, textColor),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ModernBottomNavbar(
        controller: _navigationController,
        currentIndex: 0,
        onAddPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahKelasPage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        children: [
          Text(
            DateFormat('d MMMM yyyy', 'id_ID').format(selectedDate),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateGridSelector(bool isDarkMode, Color cardColor, Color textColor) {
    final today = DateTime.now();
    final dates = List.generate(7, (index) {
      return today.add(Duration(days: index - 1));
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final isPortraitMobile = screenWidth < 600;
    final dateBorderRadius = isPortraitMobile ? 10.0 : 15.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 0.52,
        ),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year;
          final tugasCount = _tugasController.getTugasByDate(date).length;
          final hasNotification = tugasCount > 0;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFF7AB8FF) 
                    : cardColor,
                borderRadius: BorderRadius.circular(dateBorderRadius),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF7AB8FF).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected 
                            ? Colors.white 
                            : (isDarkMode ? Colors.grey[400] : Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('EEE', 'id_ID').format(date),
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected
                            ? Colors.white
                            : (isDarkMode ? Colors.grey[500] : Colors.grey[600]),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 18,
                      child: hasNotification
                          ? Container(
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6B6B),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  tugasCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleList(bool isDarkMode, Color cardColor, Color textColor) {
    final hariIni = DateFormat('EEEE', 'id_ID').format(selectedDate);
    final jadwalHariIni = _jadwalController.getJadwalByHari(hariIni);
    final tugasHariIni = _tugasController.getTugasByDate(selectedDate);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      children: [
        if (jadwalHariIni.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              'Mata Kuliah',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...jadwalHariIni.map((jadwal) => _buildJadwalCard(jadwal, isDarkMode, cardColor, textColor)),
        ],
        if (tugasHariIni.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.only(
              top: jadwalHariIni.isNotEmpty ? 20 : 0,
              bottom: 15,
            ),
            child: Text(
              'Tugas',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...tugasHariIni.map((tugas) => _buildTugasCard(tugas, isDarkMode, cardColor, textColor)),
        ],
        if (jadwalHariIni.isEmpty && tugasHariIni.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                'Tidak ada jadwal atau tugas hari ini',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildJadwalCard(Jadwal jadwal, bool isDarkMode, Color cardColor, Color textColor) {
    final mataKuliah = _mataKuliahController.getMataKuliahById(jadwal.mataKuliahId);
    bool isExpanded = false;
    
    Color mataKuliahColor = const Color(0xFF7AB8FF);
    if (mataKuliah != null && mataKuliah.warna.isNotEmpty) {
      mataKuliahColor = _hexToColor(mataKuliah.warna);
    }

    return StatefulBuilder(
      builder: (context, setCardState) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setCardState(() {
                    isExpanded = !isExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                        color: textColor,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jadwal.jamMulai,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            jadwal.jamSelesai,
                            style: TextStyle(
                              color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Container(
                        width: 3,
                        height: 60,
                        decoration: BoxDecoration(
                          color: mataKuliahColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mataKuliah?.nama ?? 'Mata Kuliah',
                              style: TextStyle(
                                color: mataKuliahColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              jadwal.ruangan,
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            if (mataKuliah?.dosen != null && mataKuliah!.dosen.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  mataKuliah.dosen,
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                        ),
                        onPressed: () {
                          setCardState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Divider(color: isDarkMode ? Colors.grey : Colors.grey[300]),
                      const SizedBox(height: 10),
                      _buildDropdownButton(
                        icon: Icons.edit,
                        label: 'Edit Kelas',
                        isDarkMode: isDarkMode,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditKelasPage(jadwalId: jadwal.id),
                            ),
                          ).then((_) => setState(() {}));
                        },
                      ),
                      const SizedBox(height: 10),
_buildDropdownButton(
  icon: Icons.assignment_add,
  label: 'Tambah Tugas',
  isDarkMode: isDarkMode,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TambahTugasPage(
          preselectedMataKuliahId: jadwal.mataKuliahId, // Kirim ID mata kuliah
        ),
      ),
    ).then((_) => setState(() {}));
  },
),
                      const SizedBox(height: 10),
                      _buildDropdownButton(
                        icon: Icons.delete,
                        label: 'Hapus Kelas',
                        color: const Color(0xFFFF6B6B),
                        isDarkMode: isDarkMode,
                        onTap: () {
                          _showDeleteDialog(jadwal.id, mataKuliah?.id);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // UPDATED: Card Tugas dengan Dropdown
  Widget _buildTugasCard(Tugas tugas, bool isDarkMode, Color cardColor, Color textColor) {
    bool isExpanded = false;
    final mataKuliah = _mataKuliahController.getMataKuliahById(tugas.mataKuliahId);
    Color tugasColor = const Color(0xFF7AB8FF);
    if (mataKuliah != null && mataKuliah.warna.isNotEmpty) {
      tugasColor = _hexToColor(mataKuliah.warna);
    }

    final isLate = _isLate(tugas);

    return StatefulBuilder(
      builder: (context, setCardState) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15),
            border: isLate 
                ? Border.all(color: const Color(0xFFFF6B6B), width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: (isLate ? const Color(0xFFFF6B6B) : Colors.black)
                    .withOpacity(isLate ? 0.2 : (isDarkMode ? 0.2 : 0.05)),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // HEADER - Clickable untuk expand/collapse
              InkWell(
                onTap: () {
                  setCardState(() {
                    isExpanded = !isExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                        color: textColor,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badge TELAT dan Nama Mata Kuliah
                            Row(
                              children: [
                                if (isLate)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B6B),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'TELAT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    tugas.mataKuliahNama,
                                    style: TextStyle(
                                      color: isLate ? const Color(0xFFFF6B6B) : tugasColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Judul Tugas
                            Text(
                              tugas.judul,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            // Label "Tugas" dengan badge prioritas
                            Row(
                              children: [
                                Text(
                                  'Tugas',
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (tugas.isPrioritas) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B6B),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      '!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                          size: 22,
                        ),
                        onPressed: () {
                          // Navigate ke edit page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTugasPage(tugas: tugas),
                            ),
                          ).then((_) => setState(() {}));
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
              // EXPANDED CONTENT - Detail Tugas
              if (isExpanded)
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Divider(color: isDarkMode ? Colors.grey : Colors.grey[300]),
                      const SizedBox(height: 15),
                      // Waktu Tenggat
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 18,
                            color: isLate 
                                ? const Color(0xFFFF6B6B) 
                                : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tenggat',
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(tugas.tanggal),
                                  style: TextStyle(
                                    color: isLate ? const Color(0xFFFF6B6B) : textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (isLate)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Telat ${_getTimeDifference(tugas.tanggal)}',
                                      style: const TextStyle(
                                        color: Color(0xFFFF6B6B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Keterangan (jika ada)
                      if (tugas.keterangan != null && tugas.keterangan!.isNotEmpty) ...[
                        const SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 18,
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Keterangan',
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    tugas.keterangan!,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 15),
                      // Tombol Hapus
                      _buildDropdownButton(
                        icon: Icons.delete,
                        label: 'Hapus Tugas',
                        color: const Color(0xFFFF6B6B),
                        isDarkMode: isDarkMode,
                        onTap: () {
                          _showDeleteTugasDialog(tugas.id);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdownButton({
    required IconData icon,
    required String label,
    required bool isDarkMode,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E2936) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? const Color(0xFF7AB8FF), size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color ?? (isDarkMode ? Colors.white : const Color(0xFF1E2936)),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(String jadwalId, String? mataKuliahId) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF2A3947) : Colors.white,
        title: Text(
          'Hapus Kelas',
          style: TextStyle(color: isDarkMode ? Colors.white : const Color(0xFF1E2936)),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus kelas ini?',
          style: TextStyle(color: isDarkMode ? Colors.white : const Color(0xFF1E2936)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await ScheduleManager().removeSchedule(jadwalId);
              
              _jadwalController.deleteJadwal(jadwalId);
              if (mataKuliahId != null) {
                _mataKuliahController.deleteMataKuliah(mataKuliahId);
              }
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kelas berhasil dihapus'),
                  backgroundColor: Color(0xFFFF6B6B),
                ),
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteTugasDialog(String tugasId) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF2A3947) : Colors.white,
        title: Text(
          'Hapus Tugas',
          style: TextStyle(color: isDarkMode ? Colors.white : const Color(0xFF1E2936)),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus tugas ini?',
          style: TextStyle(color: isDarkMode ? Colors.white : const Color(0xFF1E2936)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _tugasController.deleteTugas(tugasId);
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tugas berhasil dihapus'),
                  backgroundColor: Color(0xFFFF6B6B),
                ),
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeDifference(DateTime deadline) {
    final now = DateTime.now();
    final difference = now.difference(deadline);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'baru saja';
    }
  }
}