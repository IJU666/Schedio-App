import 'package:flutter/material.dart';
import 'package:reminder_apps/homePage.dart';
import 'package:reminder_apps/jadwal.dart';
import 'package:reminder_apps/pengaturan.dart';
import 'package:reminder_apps/tambahKelas.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        primaryColor: const Color(0xFF7AB8F5),
      ),
      home: const TugasPage(),
    );
  }
}

class TugasPage extends StatefulWidget {
  const TugasPage({Key? key}) : super(key: key);

  @override
  State<TugasPage> createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  int selectedTab = 0;
  int selectedBottomTab = 0;

  List<TaskGroup> taskGroups = [
    TaskGroup(
      date: 'Hari ini - 2 Desember 2025',
      courses: [
        Course(
          code: 'MGT 101',
          name: 'Organization Management',
          color: const Color(0xFFFF9F59),
          tasks: [
            Task(title: 'Checklist title 1', isCompleted: true),
            Task(title: 'Checklist title 2', isCompleted: true),
            Task(title: 'Checklist title 3', isCompleted: false),
          ],
        ),
        Course(
          code: 'EC 203',
          name: 'Principles Macroeconomics',
          color: const Color(0xFF5FC4E7),
          tasks: [
            Task(title: 'Checklist title 4', isCompleted: false),
          ],
        ),
      ],
    ),
    TaskGroup(
      date: 'Besok - 2 Desember 2025',
      courses: [
        Course(
          code: 'FN 215',
          name: 'Financial Management',
          color: const Color(0xFF7AB8F5),
          tasks: [
            Task(title: 'Checklist title 5', isCompleted: false),
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tugas',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildTabButton('Tenggat', 0),
                      const SizedBox(width: 8),
                      _buildTabButton('Kelas', 1),
                      const SizedBox(width: 8),
                      _buildTabButton('Prioritas', 2),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: taskGroups.length,
                itemBuilder: (context, index) {
                  return _buildTaskGroup(taskGroups[index]);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

int _selectedIndex = 3;
  // ===== BOTTOM BAR =====
  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: const Color(0xFF1A2F42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.calendar_today, 'Today', 0, HomepageScreen()),
          _buildNavItem(Icons.view_list, 'Schedule', 1,JadwalScreen()),
          _buildNavItem(Icons.add_circle, 'Add', 2,TambahKelasScreen()),
          _buildNavItem(Icons.assignment, 'Assignment', 3,TugasPage()),
          _buildNavItem(Icons.settings, 'Settings', 4,PengaturanScreen())
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

  Widget _buildTabButton(String text, int index) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7AB8F5) : const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskGroup(TaskGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 12),
          child: Text(
            group.date,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ...group.courses.map((course) => _buildCourseCard(course)).toList(),
      ],
    );
  }

  Widget _buildCourseCard(Course course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${course.code} - ${course.name}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: course.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.edit,
                  color: course.color,
                  size: 20,
                ),
              ],
            ),
          ),
          ...course.tasks.asMap().entries.map((entry) {
            return _buildTaskItem(entry.value, entry.key, course.tasks.length);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task, int index, int totalTasks) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  task.isCompleted = !task.isCompleted;
                });
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? const Color(0xFFFF9F59)
                      : Colors.transparent,
                  border: Border.all(
                    color: task.isCompleted
                        ? const Color(0xFFFF9F59)
                        : Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: task.isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Note from checklist',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    bool isSelected = selectedBottomTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBottomTab = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF7AB8F5) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? const Color(0xFF7AB8F5) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFF7AB8F5),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

class TaskGroup {
  final String date;
  final List<Course> courses;

  TaskGroup({required this.date, required this.courses});
}

class Course {
  final String code;
  final String name;
  final Color color;
  final List<Task> tasks;

  Course({
    required this.code,
    required this.name,
    required this.color,
    required this.tasks,
  });
}

class Task {
  final String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}