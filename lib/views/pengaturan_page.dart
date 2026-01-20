// views/pengaturan_page.dart
// ========================================
// PENGATURAN PAGE - DENGAN DARK MODE TOGGLE
// ========================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/theme_controller.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/modern_bottom_navbar.dart';
import 'tambah_kelas_page.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({Key? key}) : super(key: key);

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  bool isPengingatEnabled = true;
  final NavigationController _navigationController = NavigationController();

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
  void initState() {
    super.initState();
    _navigationController.setIndex(4);
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
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
                
                // Pengaturan Pribadi Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pengaturan Pribadi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle Edit
                      },
                      child: Row(
                        children: [
                          Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 16,
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
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // User Info - Name
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: isDarkMode ? Colors.grey : Colors.grey[700],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'UjangBedog',
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // User Info - Email
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: isDarkMode ? Colors.grey : Colors.grey[700],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'UjangBedog666@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                  ],
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
                
                // Course List
                ...courses.map((course) => _buildCourseItem(course, isDarkMode, cardColor, textColor)).toList(),
                const SizedBox(height: 24),
                
                // Pengingat Toggle
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pengingat',
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
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
                
                // ========================================
                // DARK MODE TOGGLE - FITUR UTAMA
                // ========================================
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
                          children: [
                            const Icon(
                              Icons.lock_outline,
                              color: Color(0xFFFFB86C),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Private policy',
                              style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'More',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode ? Colors.grey : Colors.grey[700],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right,
                              color: isDarkMode ? Colors.grey : Colors.grey[700],
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
      
      // Modern Bottom Navbar
      bottomNavigationBar: ModernBottomNavbar(
        controller: _navigationController,
        currentIndex: 4,
        onAddPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahKelasPage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }

  Widget _buildCourseItem(CourseItem course, bool isDarkMode, Color cardColor, Color textColor) {
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

class CourseItem {
  final String name;
  final Color color;

  CourseItem({
    required this.name,
    required this.color,
  });
}