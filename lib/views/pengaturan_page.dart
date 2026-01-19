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
import 'home_page.dart';
import 'kalender_page.dart';void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengaturan',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        primaryColor: const Color(0xFF0A0E27),
      ),
      home: const PengaturanPage(),
    );
  }
}

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({Key? key}) : super(key: key);

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  bool isPengingatEnabled = true;
  bool isDarkModeEnabled = true;

  final List<CourseItem> courses = [
    CourseItem(
      name: 'EC 202 - Principles Microeconomics',
      color: const Color(0xFF6B7FFF),
    ),
    CourseItem(
      name: 'EC 203 - Principles Macroeconomics',
      color: const Color(0xFF4ECDC4),
    ),
    CourseItem(
      name: 'FN 215 - Financial Management',
      color: const Color(0xFF6B7FFF),
    ),
    CourseItem(
      name: 'MGT 101 - Organization Management',
      color: const Color(0xFFFFB86C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Pengaturan',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Pengaturan Pribadi Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pengaturan Pribadi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle Edit
                      },
                      child: Row(
                        children: const [
                          Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // User Info - Name
                Row(
                  children: const [
                    Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'UjangBedog',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // User Info - Email
                Row(
                  children: const [
                    Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'UjangBedog666@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Pengaturan Kelas Section
                const Text(
                  'Pengaturan Kelas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Course List
                ...courses.map((course) => _buildCourseItem(course)).toList(),
                
                const SizedBox(height: 24),
                
                // Pengingat Toggle
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pengingat',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Switch(
                        value: isPengingatEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            isPengingatEnabled = value;
                          });
                        },
                        activeColor: const Color(0xFF4ECDC4),
                        activeTrackColor: const Color(0xFF4ECDC4).withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Dark Mode Toggle
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Dark mode',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Switch(
                        value: isDarkModeEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            isDarkModeEnabled = value;
                          });
                        },
                        activeColor: const Color(0xFF4ECDC4),
                        activeTrackColor: const Color(0xFF4ECDC4).withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Private Policy
                GestureDetector(
                  onTap: () {
                    // Handle Private Policy
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.lock_outline,
                              color: Color(0xFFFFB86C),
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Private policy',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: const [
                            Text(
                              'More',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  int _selectedIndex = 4;
  // ===== BOTTOM BAR =====
  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: const Color(0xFF1A2F42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.calendar_today, 'Today', 0, HomePage()),
          _buildNavItem(Icons.view_list, 'Schedule', 1,KalenderPage()),
          _buildNavItem(Icons.add_circle, 'Add', 2,TambahKelasPage()),
          _buildNavItem(Icons.assignment, 'Assignment', 3,DaftarTugasPage()),
          _buildNavItem(Icons.settings, 'Settings', 4,PengaturanPage())
        ]
      ),  
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, Widget page) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF5B9FED) : Colors.grey[500],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF5B9FED) : Colors.grey[500],
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseItem(CourseItem course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Handle course tap
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Color indicator
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: course.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              // Course name
              Expanded(
                child: Text(
                  course.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              // Edit button
              Row(
                children: const [
                  Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white,
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

  // Widget _buildNavItem(IconData icon, String label, bool isSelected) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Icon(
  //         icon,
  //         color: isSelected ? const Color(0xFF6B7FFF) : Colors.grey,
  //         size: 24,
  //       ),
  //       const SizedBox(height: 4),
  //       Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 10,
  //           color: isSelected ? const Color(0xFF6B7FFF) : Colors.grey,
  //         ),
  //       ),
  //     ],
  //   );
  // }

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

class CourseItem {
  final String name;
  final Color color;

  CourseItem({
    required this.name,
    required this.color,
  });
}