// home_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/jadwal_controller.dart';
import '../controllers/tugas_controller.dart';
import '../controllers/mata_kuliah_controller.dart';
import '../models/jadwal.dart';
import '../models/tugas.dart';
import '../models/mata_kuliah.dart';
import 'tambah_tugas_page.dart';
import 'tambah_kelas_page.dart';
import 'edit_kelas_page.dart';
import 'daftar_tugas_page.dart';
import 'kalender_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final JadwalController _jadwalController = JadwalController();
  final TugasController _tugasController = TugasController();
  final MataKuliahController _mataKuliahController = MataKuliahController();
  
  DateTime selectedDate = DateTime.now();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2936),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildDateSelector(),
            Expanded(
              child: _buildScheduleList(),
            ),
          ],
        ),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            DateFormat('d MMMM yyyy', 'id_ID').format(selectedDate),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final today = DateTime.now();
    final dates = List.generate(7, (index) {
      return today.add(Duration(days: index - 1));
    });

    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - (15 * (dates.length - 1))) / dates.length;
          
          return ListView.builder(
            scrollDirection: Axis.horizontal,
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
                child: Container(
                  width: itemWidth,
                  margin: EdgeInsets.only(right: index < dates.length - 1 ? 15 : 0),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF7AB8FF) : const Color(0xFF2A3947),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('EEE', 'id_ID').format(date),
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white : Colors.grey[500],
                              ),
                            ),
                            if (hasNotification) ...[
                              const SizedBox(width: 4),
                              Container(
                                width: 18,
                                height: 18,
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
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildScheduleList() {
    final hariIni = DateFormat('EEEE', 'id_ID').format(selectedDate);
    final jadwalHariIni = _jadwalController.getJadwalByHari(hariIni);
    final tugasHariIni = _tugasController.getTugasByDate(selectedDate);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Section Mata Kuliah
        if (jadwalHariIni.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              'Mata Kuliah',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...jadwalHariIni.map((jadwal) => _buildJadwalCard(jadwal)),
        ],
        
        // Section Tugas
        if (tugasHariIni.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.only(
              top: jadwalHariIni.isNotEmpty ? 20 : 0,
              bottom: 15,
            ),
            child: const Text(
              'Tugas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...tugasHariIni.map((tugas) => _buildTugasCard(tugas)),
        ],
        
        // Empty state
        if (jadwalHariIni.isEmpty && tugasHariIni.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                'Tidak ada jadwal atau tugas hari ini',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildJadwalCard(Jadwal jadwal) {
    final mataKuliah = _mataKuliahController.getMataKuliahById(jadwal.mataKuliahId);
    bool isExpanded = false;
    
    return StatefulBuilder(
      builder: (context, setCardState) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF2A3947),
            borderRadius: BorderRadius.circular(15),
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
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jadwal.jamMulai,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            jadwal.jamSelesai,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mataKuliah?.nama ?? 'Mata Kuliah',
                              style: const TextStyle(
                                color: Color(0xFF7AB8FF),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              jadwal.ruangan,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                            if (mataKuliah?.dosen != null && mataKuliah!.dosen.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  mataKuliah.dosen,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Color(0xFFFFB84D)),
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
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      _buildDropdownButton(
                        icon: Icons.edit,
                        label: 'Edit Kelas',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditKelasPage(
                                jadwalId: jadwal.id,
                              ),
                            ),
                          ).then((_) => setState(() {}));
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildDropdownButton(
                        icon: Icons.assignment_add,
                        label: 'Tambah Tugas',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TambahTugasPage(),
                            ),
                          ).then((_) => setState(() {}));
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildDropdownButton(
                        icon: Icons.delete,
                        label: 'Hapus Kelas',
                        color: const Color(0xFFFF6B6B),
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

  Widget _buildTugasCard(Tugas tugas) {
    bool isExpanded = false;
    
    return StatefulBuilder(
      builder: (context, setCardState) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF2A3947),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  _showTugasDialog(tugas);
                },
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tugas.mataKuliahNama,
                              style: const TextStyle(
                                color: Color(0xFF7AB8FF),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings, color: Color(0xFFFFB84D)),
                            onPressed: () {
                              setCardState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        tugas.judul,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Tugas ',
                            style: TextStyle(color: Colors.white),
                          ),
                          if (tugas.isPrioritas)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B6B),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
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
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      _buildDropdownButton(
                        icon: Icons.edit,
                        label: 'Edit Tugas',
                        onTap: () {
                          // Navigate to edit tugas page
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildDropdownButton(
                        icon: Icons.checklist,
                        label: 'Lihat Checklist',
                        onTap: () {
                          _showTugasDialog(tugas);
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildDropdownButton(
                        icon: Icons.delete,
                        label: 'Hapus Tugas',
                        color: const Color(0xFFFF6B6B),
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
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2936),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? const Color(0xFF7AB8FF), size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color ?? Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(String jadwalId, String? mataKuliahId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A3947),
        title: const Text(
          'Hapus Kelas',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus kelas ini?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A3947),
        title: const Text(
          'Hapus Tugas',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus tugas ini?',
          style: TextStyle(color: Colors.white),
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

  void _showTugasDialog(Tugas tugas) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: const Color(0xFF2A3947),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '08:00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tugas.mataKuliahNama,
                        style: const TextStyle(
                          color: Color(0xFF7AB8FF),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Color(0xFFFFB84D)),
                      onPressed: () {},
                    ),
                  ],
                ),
                Text(
                  'Room 302',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Tugas ',
                      style: TextStyle(color: Colors.white),
                    ),
                    if (tugas.isPrioritas)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B6B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                ...List.generate(tugas.checklist.length, (index) {
                  final isChecked = tugas.checklistStatus[index];
                  final mataKuliah = _mataKuliahController.getMataKuliahById(tugas.mataKuliahId);
                  final iconColor = mataKuliah?.warna != null 
                      ? Color(int.parse(mataKuliah!.warna.replaceAll('#', '0xff')))
                      : const Color(0xFFFFB84D);
                  
                  return InkWell(
                    onTap: () {
                      setDialogState(() {
                        tugas.checklistStatus[index] = !isChecked;
                      });
                      setState(() {
                        _tugasController.updateChecklistStatus(
                          tugas.id,
                          index,
                          !isChecked,
                        );
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                      child: Row(
                        children: [
                          Icon(
                            isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                            color: iconColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              tugas.checklist[index],
                              style: TextStyle(
                                color: isChecked ? Colors.grey[600] : Colors.white,
                                decoration: isChecked ? TextDecoration.lineThrough : null,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TambahTugasPage()),
                          ).then((_) {
                            Navigator.pop(context);
                            setState(() {});
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7AB8FF),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          '+ Assignment',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF7AB8FF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KalenderPage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DaftarTugasPage()),
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
}