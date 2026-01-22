// views/daftar_tugas_page.dart
// ========================================
// DAFTAR TUGAS PAGE - DENGAN PERINGATAN TELAT
// ========================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../controllers/tugas_controller.dart';
import '../controllers/mata_kuliah_controller.dart';
import '../controllers/navigation_controller.dart';
import '../models/tugas.dart';
import '../widgets/modern_bottom_navbar.dart';
import 'tambah_kelas_page.dart';
import 'edit_tugas_page.dart';

class DaftarTugasPage extends StatefulWidget {
  const DaftarTugasPage({Key? key}) : super(key: key);

  @override
  State<DaftarTugasPage> createState() => _DaftarTugasPageState();
}

class _DaftarTugasPageState extends State<DaftarTugasPage>
    with SingleTickerProviderStateMixin {
  final TugasController _tugasController = TugasController();
  final MataKuliahController _mataKuliahController = MataKuliahController();
  final NavigationController _navigationController = NavigationController();
  TabController? _tabController;
  int _selectedTab = 0;
  Timer? _deletionTimer;
  final Map<String, Timer> _pendingDeletions = {};
  Timer? _blinkTimer;
  bool _showWarning = true;

  @override
  void initState() {
    super.initState();
    _navigationController.setIndex(3);
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _selectedTab = _tabController!.index;
      });
    });
    
    // Timer untuk animasi berkedip peringatan
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() {
          _showWarning = !_showWarning;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _navigationController.dispose();
    _deletionTimer?.cancel();
    _blinkTimer?.cancel();
    for (var timer in _pendingDeletions.values) {
      timer.cancel();
    }
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

  Map<String, List<Tugas>> _groupTugasByDate(List<Tugas> tugasList) {
    final Map<String, List<Tugas>> grouped = {};
    final now = DateTime.now();
    for (var tugas in tugasList) {
      final date = tugas.tanggal;
      String label;
      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        label = 'Hari ini - ${DateFormat('d MMMM yyyy', 'id_ID').format(date)}';
      } else if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day + 1) {
        label = 'Besok - ${DateFormat('d MMMM yyyy', 'id_ID').format(date)}';
      } else {
        label = DateFormat('EEEE - d MMMM yyyy', 'id_ID').format(date);
      }
      if (!grouped.containsKey(label)) {
        grouped[label] = [];
      }
      grouped[label]!.add(tugas);
    }
    return grouped;
  }

  List<Tugas> _getFilteredTugas() {
    final allTugas = _tugasController.getAllTugas();
    switch (_selectedTab) {
      case 0:
        allTugas.sort((a, b) => a.tanggal.compareTo(b.tanggal));
        return allTugas;
      case 1:
        allTugas.sort((a, b) => a.mataKuliahNama.compareTo(b.mataKuliahNama));
        return allTugas;
      case 2:
        return allTugas.where((t) => t.isPrioritas).toList();
      default:
        return allTugas;
    }
  }

  void _scheduleTaskDeletion(String tugasId) {
    _pendingDeletions[tugasId]?.cancel();
    
    _pendingDeletions[tugasId] = Timer(const Duration(minutes: 5), () {
      _tugasController.deleteTugas(tugasId);
      _pendingDeletions.remove(tugasId);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardColor = Theme.of(context).cardColor;

    if (_tabController == null) {
      return Scaffold(
        backgroundColor: bgColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Tugas',
          style: TextStyle(
            color: textColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTabBar(isDarkMode, cardColor),
          Expanded(
            child: _buildTugasList(isDarkMode, cardColor, textColor),
          ),
        ],
      ),
      bottomNavigationBar: ModernBottomNavbar(
        controller: _navigationController,
        currentIndex: 3,
        onAddPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahKelasPage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }

  Widget _buildTabBar(bool isDarkMode, Color cardColor) {
    if (_tabController == null) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF7AB8FF),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Tenggat'),
          Tab(text: 'Kelas'),
          Tab(text: 'Prioritas'),
        ],
      ),
    );
  }

  Widget _buildTugasList(bool isDarkMode, Color cardColor, Color textColor) {
    final tugasList = _getFilteredTugas();
    if (tugasList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada tugas',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[600] : Colors.grey[500],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_selectedTab == 0) {
      final grouped = _groupTugasByDate(tugasList);
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: grouped.length,
        itemBuilder: (context, index) {
          final dateLabel = grouped.keys.elementAt(index);
          final tugasGroup = grouped[dateLabel]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  dateLabel,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...tugasGroup.map((tugas) => _buildTugasCard(tugas, isDarkMode, cardColor, textColor)),
              const SizedBox(height: 16),
            ],
          );
        },
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: tugasList.length,
        itemBuilder: (context, index) {
          return _buildTugasCard(tugasList[index], isDarkMode, cardColor, textColor);
        },
      );
    }
  }

  Widget _buildTugasCard(Tugas tugas, bool isDarkMode, Color cardColor, Color textColor) {
    final mataKuliah = _mataKuliahController.getMataKuliahById(tugas.mataKuliahId);
    Color borderColor = const Color(0xFF7AB8FF);
    if (mataKuliah != null && mataKuliah.warna.isNotEmpty) {
      borderColor = _hexToColor(mataKuliah.warna);
    }

    final isLate = _isLate(tugas);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isLate 
            ? (isDarkMode ? const Color(0xFF3D1F1F) : const Color(0xFFFFEBEE))
            : cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLate ? const Color(0xFFFF6B6B) : borderColor, 
          width: isLate ? 3 : 2,
        ),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan badge TELAT
          if (isLate)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    tugas.mataKuliahNama,
                    style: TextStyle(
                      color: (isDarkMode 
                                ? const Color.fromARGB(255, 255, 255, 255)
                                : (isLate ? const Color.fromARGB(255, 0, 0, 0)! : const Color.fromARGB(255, 0, 0, 0)!)),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTugasPage(tugas: tugas),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.edit,
                      color: (isDarkMode 
                                ? const Color.fromARGB(255, 177, 177, 177)
                                : (isLate ? const Color.fromARGB(255, 0, 0, 0)! : const Color.fromARGB(255, 0, 0, 0)!))
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      final allChecked = tugas.checklistStatus.every((status) => status);
                      for (int i = 0; i < tugas.checklistStatus.length; i++) {
                        _tugasController.updateChecklistStatus(
                          tugas.id,
                          i,
                          !allChecked,
                        );
                      }
                      
                      if (!allChecked) {
                        _scheduleTaskDeletion(tugas.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Tugas akan dihapus dalam 5 menit'),
                            duration: const Duration(seconds: 3),
                            backgroundColor: borderColor,
                            action: SnackBarAction(
                              label: 'BATAL',
                              textColor: Colors.white,
                              onPressed: () {
                                _pendingDeletions[tugas.id]?.cancel();
                                _pendingDeletions.remove(tugas.id);
                              },
                            ),
                          ),
                        );
                      } else {
                        _pendingDeletions[tugas.id]?.cancel();
                        _pendingDeletions.remove(tugas.id);
                      }
                    });
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: tugas.checklistStatus.every((s) => s)
                          ? const Color(0xFFFFB84D)
                          : Colors.transparent,
                      border: Border.all(
                        color: tugas.checklistStatus.every((s) => s)
                            ? const Color(0xFFFFB84D)
                            : (isDarkMode
                                ? const Color.fromARGB(255, 255, 255, 255)
                                : (isLate ? const Color.fromARGB(255, 0, 0, 0)! : const Color.fromARGB(255, 255, 255, 255)!)),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: tugas.checklistStatus.every((s) => s)
                        ? const Icon(Icons.check, color: Color.fromARGB(255, 255, 255, 255), size: 14)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tugas.judul,
                        style: TextStyle(
                          color: tugas.checklistStatus.every((s) => s)
                              ? (isLate? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0))
                              : (isDarkMode ? const Color.fromARGB(255, 255, 255, 255) : textColor),
                          fontSize: 14,
                          fontWeight: isLate ? FontWeight.w600 : FontWeight.w500,
                          decoration: tugas.checklistStatus.every((s) => s)
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (isLate)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Melewati tenggat ${_getTimeDifference(tugas.tanggal)}',
                            style: TextStyle(
                              color: (isDarkMode 
                                ? const Color.fromARGB(255, 255, 255, 255)
                                : (isLate ? const Color.fromARGB(255, 0, 0, 0)! : const Color.fromARGB(255, 0, 0, 0)!)),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: isDarkMode 
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : (isLate ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 0, 0, 0)),
                ),
                const SizedBox(width: 6),
                Text(
                  'Tenggat: ${DateFormat('HH:mm').format(tugas.tanggal)}',
                  style: TextStyle(
                    color: isDarkMode 
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : (isLate ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 0, 0, 0)),
                    fontSize: 12,
                    fontWeight: isLate ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
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