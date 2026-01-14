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

class JadwalScreen extends StatelessWidget {
  const JadwalScreen({Key? key}) : super(key: key);
  
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
                children: [
                  _buildDateTab('2', 'Selasa', true),
                  _buildDateTab('3', 'Rabu', false),
                  _buildDateTab('4', 'Kamis', false),
                  _buildDateTab('5', 'Jumat', false),
                  _buildDateTab('6', 'Sabtu', false),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Schedule Grid
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildTimeRow('09\nAM', [
                        ScheduleItem('Org\nMgt', 'Room 101', const Color(0xFFFFD88D), 1),
                        ScheduleItem('Financial\nMgt', 'Room 101', const Color(0xFF6B7FFF), 1),
                        null,
                        null,
                        ScheduleItem('Micro', 'Room 101', const Color(0xFFB457FF), 1),
                      ]),
                      
                      _buildTimeRow('10\nAM', [
                        ScheduleItem('Macro', 'Room 101', const Color(0xFF4ECDC4), 1),
                        null,
                        ScheduleItem('Macro', 'Room 101', const Color(0xFF6B7FFF), 1),
                        ScheduleItem('Org\nMgt', 'Room 101', const Color(0xFFFFD88D), 1),
                        ScheduleItem('Org\nMgt', 'Room 101', const Color(0xFFFFB86C), 1),
                      ]),
                      
                      _buildTimeRow('11\nAM', [
                        ScheduleItem('Micro', 'Room 101', const Color(0xFFB457FF), 1),
                        ScheduleItem('Org\nMgt', 'Room 101', const Color(0xFFFFB86C), 1),
                        ScheduleItem('Micro', 'Room 101', const Color(0xFFB457FF), 2),
                        ScheduleItem('Micro', 'Room 101', const Color(0xFFB457FF), 1),
                        ScheduleItem('Macro', 'Room 101', const Color(0xFF4ECDC4), 4),
                      ]),
                      
                      _buildTimeRow('12\nPM', [
                        ScheduleItem('Financial\nMgt', 'Room 101', const Color(0xFF6B7FFF), 3),
                        null,
                        null,
                        null,
                        null,
                      ]),
                      
                      _buildTimeRow('01\nPM', [
                        null,
                        null,
                        null,
                        null,
                        null,
                      ]),
                      
                      _buildTimeRow('02\nPM', [
                        null,
                        null,
                        null,
                        null,
                        null,
                      ]),
                    ],
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
                _buildNavItem(Icons.calendar_today, 'Today', true),
                _buildNavItem(Icons.view_week, 'Schedule', false),
                _buildAddButton(),
                _buildNavItem(Icons.grid_view, 'Assignme', false),
                _buildNavItem(Icons.settings, 'Settings', false),
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
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
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
    );
  }

  Widget _buildAddButton() {
    return Container(
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