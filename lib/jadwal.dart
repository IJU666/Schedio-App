import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jadwal',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        primaryColor: const Color(0xFF0A0E27),
      ),
      home: const JadwalScreen(),
    );
  }
}

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({Key? key}) : super(key: key);

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  int _selectedDateIndex = 0;
  int _selectedNavIndex = 0;
  
  final List<Map<String, String>> _dates = [
    {'date': '2', 'day': 'Selasa'},
    {'date': '3', 'day': 'Rabu'},
    {'date': '4', 'day': 'Kamis'},
    {'date': '5', 'day': 'Jumat'},
    {'date': '6', 'day': 'Sabtu'},
  ];

  // Data jadwal untuk setiap hari
  final Map<int, List<List<ScheduleItem?>>> _scheduleData = {
    0: [ // Selasa
      [
        ScheduleItem('Org\nMgt', 'Room 101', const Color(0xFFFFD88D), 1),
        ScheduleItem('Financial\nMgt', 'Room 101', const Color(0xFF6B7FFF), 1),
        null,
        null,
        ScheduleItem('Micro', 'Room 101', const Color(0xFFB457FF), 1),
      ],
      [
        ScheduleItem('Macro', 'Room 101', const Color(0xFF4ECDC4), 1),
        null,
        ScheduleItem('Macro', 'Room 101', const Color(0xFF6B7FFF), 1),
        ScheduleItem('Org\nMgt', 'Room 101', const Color(0xFFFFD88D), 1),
        ScheduleItem('Org\nMgt', 'Room 101', const Color(0xFFFFB86C), 1),
      ],
      [
        ScheduleItem('Micro', 'Room 101', const Color(0xFFB457FF), 1),
        ScheduleItem('Org\nMgt', 'Room 101', const Color(0xFFFFB86C), 1),
        ScheduleItem('Micro', 'Room 101', const Color(0xFFB457FF), 2),
        ScheduleItem('Micro', 'Room 101', const Color(0xFFB457FF), 1),
        ScheduleItem('Macro', 'Room 101', const Color(0xFF4ECDC4), 4),
      ],
      [
        ScheduleItem('Financial\nMgt', 'Room 101', const Color(0xFF6B7FFF), 3),
        null,
        null,
        null,
        null,
      ],
      [null, null, null, null, null],
      [null, null, null, null, null],
    ],
    1: [ // Rabu
      [
        ScheduleItem('Financial\nMgt', 'Room 202', const Color(0xFF6B7FFF), 1),
        ScheduleItem('Macro', 'Room 101', const Color(0xFF4ECDC4), 1),
        null,
        ScheduleItem('Micro', 'Room 101', const Color(0xFFB457FF), 1),
        null,
      ],
      [null, null, null, null, null],
      [null, null, null, null, null],
      [null, null, null, null, null],
      [null, null, null, null, null],
      [null, null, null, null, null],
    ],
    2: [ // Kamis
      [
        null,
        ScheduleItem('Org\nMgt', 'Room 101', const Color(0xFFFFD88D), 2),
        ScheduleItem('Financial\nMgt', 'Room 202', const Color(0xFF6B7FFF), 1),
        null,
        null,
      ],
      [null, null, null, null, null],
      [null, null, null, null, null],
      [null, null, null, null, null],
      [null, null, null, null, null],
      [null, null, null, null, null],
    ],
    3: [ // Jumat
      [null, null, null, null, null],
      [
        ScheduleItem('Macro', 'Room 101', const Color(0xFF4ECDC4), 1),
        null,
        null,
        ScheduleItem('Micro', 'Room 101', const Color(0xFFB457FF), 1),
        null,
      ],
      [null, null, null, null, null],
      [null, null, null, null, null],
      [null, null, null, null, null],
      [null, null, null, null, null],
    ],
    4: [ // Sabtu
      [null, null, null, null, null],
      [null, null, null, null, null],
      [null, null, null, null, null],
      [null, null, null, null, null],
      [null, null, null, null, null],
      [null, null, null, null, null],
    ],
  };

  final List<String> _timeSlots = ['09\nAM', '10\nAM', '11\nAM', '12\nPM', '01\nPM', '02\nPM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Jadwal',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Date Tabs
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_dates.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDateIndex = index;
                      });
                    },
                    child: _buildDateTab(
                      _dates[index]['date']!,
                      _dates[index]['day']!,
                      _selectedDateIndex == index,
                    ),
                  );
                }),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Schedule Grid
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: List.generate(_timeSlots.length, (index) {
                      return _buildTimeRow(
                        _timeSlots[index],
                        _scheduleData[_selectedDateIndex]![index],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F3A),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(Icons.calendar_today, 'Today', 0),
                _buildNavItem(Icons.view_week, 'Schedule', 1),
                _buildAddButton(),
                _buildNavItem(Icons.grid_view, 'Assignme', 2),
                _buildNavItem(Icons.settings, 'Settings', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTab(String date, String day, bool isSelected) {
    return Container(
      width: 60,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2A2F4F) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white70 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String time, List<ScheduleItem?> items) {
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
                height: 1.2,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: List.generate(5, (index) {
                final item = items[index];
                if (item == null) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2),
                    ),
                  );
                }
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showScheduleDetails(item);
                    },
                    child: Container(
                      height: item.height * 80.0,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            item.room,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
        _handleNavigation(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF6B7FFF) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? const Color(0xFF6B7FFF) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        _showAddScheduleDialog();
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF6B7FFF),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B7FFF).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  void _showScheduleDetails(ScheduleItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          item.title.replaceAll('\n', ' '),
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ruangan: ${item.room}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Durasi: ${item.height} jam',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: Color(0xFF6B7FFF))),
          ),
        ],
      ),
    );
  }

  void _showAddScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Tambah Jadwal',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Fitur tambah jadwal akan segera hadir!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFF6B7FFF))),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    String message = '';
    switch (index) {
      case 0:
        message = 'Menampilkan jadwal hari ini';
        break;
      case 1:
        message = 'Menampilkan semua jadwal';
        break;
      case 2:
        message = 'Menampilkan tugas';
        break;
      case 3:
        message = 'Membuka pengaturan';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF2A2F4F),
      ),
    );
  }
}

class ScheduleItem {
  final String title;
  final String room;
  final Color color;
  final int height;

  ScheduleItem(this.title, this.room, this.color, this.height);
}