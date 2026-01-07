import 'package:flutter/material.dart';

void main() {
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
      home: const PengaturanScreen(),
    );
  }
}

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({Key? key}) : super(key: key);

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
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
                _buildNavItem(Icons.calendar_today, 'Today', false),
                _buildNavItem(Icons.view_week, 'Schedule', false),
                _buildAddButton(),
                _buildNavItem(Icons.grid_view, 'Assignme', false),
                _buildNavItem(Icons.settings, 'Settings', true),
              ],
            ),
          ),
        ),
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

class CourseItem {
  final String name;
  final Color color;

  CourseItem({
    required this.name,
    required this.color,
  });
}