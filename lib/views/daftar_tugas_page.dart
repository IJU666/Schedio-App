import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/tugas_controller.dart';
import '../controllers/mata_kuliah_controller.dart';
import '../models/tugas.dart';
import '../models/mata_kuliah.dart';
import 'tambah_tugas_page.dart';
import 'tambah_kelas_page.dart';
import 'home_page.dart';
import 'kalender_page.dart';

class DaftarTugasPage extends StatefulWidget {
  const DaftarTugasPage({Key? key}) : super(key: key);

  @override
  State<DaftarTugasPage> createState() => _DaftarTugasPageState();
}

class _DaftarTugasPageState extends State<DaftarTugasPage> with SingleTickerProviderStateMixin {
  final TugasController _tugasController = TugasController();
  final MataKuliahController _mataKuliahController = MataKuliahController();
  
  TabController? _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _selectedTab = _tabController!.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexString) {
    if (hexString.isEmpty) return const Color(0xFF7AB8FF);
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Map<String, List<Tugas>> _groupTugasByDate(List<Tugas> tugasList) {
    final Map<String, List<Tugas>> grouped = {};
    final now = DateTime.now();
    
    for (var tugas in tugasList) {
      final date = tugas.tanggal;
      String label;
      
      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        label = 'Hari ini - ${DateFormat('d MMMM yyyy', 'id_ID').format(date)}';
      } else if (date.year == now.year && date.month == now.month && date.day == now.day + 1) {
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
      case 0: // Tenggat
        allTugas.sort((a, b) => a.tanggal.compareTo(b.tanggal));
        return allTugas;
      case 1: // Kelas
        allTugas.sort((a, b) => a.mataKuliahNama.compareTo(b.mataKuliahNama));
        return allTugas;
      case 2: // Prioritas
        return allTugas.where((t) => t.isPrioritas).toList();
      default:
        return allTugas;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E2936),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFF1E2936),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2936),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Tugas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildTugasList(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF7AB8FF),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TambahKelasPage()),
            ).then((_) => setState(() {}));
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A3947),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: 3,
        selectedItemColor: const Color(0xFF7AB8FF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const KalenderPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    if (_tabController == null) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A3947),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF7AB8FF),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[400],
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

  Widget _buildTugasList() {
    final tugasList = _getFilteredTugas();
    
    if (tugasList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada tugas',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_selectedTab == 0) {
      // Group by date for Tenggat tab
      final grouped = _groupTugasByDate(tugasList);
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...tugasGroup.map((tugas) => _buildTugasCard(tugas)),
              const SizedBox(height: 16),
            ],
          );
        },
      );
    } else {
      // Simple list for other tabs
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tugasList.length,
        itemBuilder: (context, index) {
          return _buildTugasCard(tugasList[index]);
        },
      );
    }
  }

  Widget _buildTugasCard(Tugas tugas) {
    final mataKuliah = _mataKuliahController.getMataKuliahById(tugas.mataKuliahId);
    Color borderColor = const Color(0xFF7AB8FF);
    
    if (mataKuliah != null && mataKuliah.warna.isNotEmpty) {
      borderColor = _hexToColor(mataKuliah.warna);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2936),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    tugas.mataKuliahNama,
                    style: TextStyle(
                      color: borderColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(Icons.edit, color: borderColor, size: 20),
              ],
            ),
          ),
          
          // Main Task Title (judul tugas)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // Toggle all checklist items
                      final allChecked = tugas.checklistStatus.every((status) => status);
                      for (int i = 0; i < tugas.checklistStatus.length; i++) {
                        _tugasController.updateChecklistStatus(
                          tugas.id,
                          i,
                          !allChecked,
                        );
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
                            : Colors.grey[600]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: tugas.checklistStatus.every((s) => s)
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
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
                              ? Colors.grey[600]
                              : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: tugas.checklistStatus.every((s) => s)
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Note from checklist',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
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
}