import 'package:flutter/material.dart';
import 'package:reminder_apps/jadwal.dart';
import 'package:reminder_apps/pengaturan.dart';
import 'package:reminder_apps/tambahKelas.dart';
import 'package:reminder_apps/tugas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0A1929),
        fontFamily: 'SF Pro',
      ),
      home: const ScheduleScreen(),
    );
  }
}

class ScheduleItem {
  final String startTime;
  final String endTime;
  final String title;
  final String room;
  final Color color;
  List<TaskItem>? tasks;

  ScheduleItem({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.room,
    required this.color,
    this.tasks,
  });
}

class TaskItem {
  String title;
  bool isCompleted;

  TaskItem({required this.title, this.isCompleted = false});
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<ScheduleItem> schedules = [
    ScheduleItem(
      startTime: '08:00',
      endTime: '09:00',
      title: 'MGT 101 - Organization Management',
      room: 'Room 302',
      color: Colors.orange,
      tasks: [
        TaskItem(title: 'Checklist title 1', isCompleted: true),
        TaskItem(title: 'Checklist title 2'),
      ],
    ),
    ScheduleItem(
      startTime: '09:13',
      endTime: '10:00',
      title: 'EC 203 - Principles Macroeconomics',
      room: 'Room 101',
      color: Colors.teal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '2 Desember 2025',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // ===== TANGGAL =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDateItem('2', 'Selasa', true, notif: '2'),
                  _buildDateItem('3', 'Rabu', false, notif: '1'),
                  _buildDateItem('4', 'Kamis', false),
                  _buildDateItem('5', 'Jumat', false, notif: '3'),
                  _buildDateItem('6', 'Sabtu', false),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildScheduleCard(schedules[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ===== DATE ITEM =====
  Widget _buildDateItem(String date, String day, bool selected,
      {String? notif}) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF5B9FED) : const Color(0xFF1A2F42),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            date,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            day,
            style: TextStyle(
                color: selected ? Colors.white : Colors.grey[400],
                fontSize: 12),
          ),
          if (notif != null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  notif,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
        ],
      ),
    );
  }

  // ===== CARD =====
  Widget _buildScheduleCard(ScheduleItem schedule) {
    return GestureDetector(
      onTap: () => _showTaskDialog(schedule),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2F42),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(schedule.startTime,
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            Text(
              schedule.title,
              style: TextStyle(
                  color: schedule.color,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(schedule.room,
                style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }

  // ===== DETAIL + ASSIGNMENT =====
  void _showTaskDialog(ScheduleItem schedule) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2F42),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white),
                      const SizedBox(width: 8),
                      Text(schedule.startTime,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    schedule.title,
                    style: TextStyle(
                        color: schedule.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(schedule.room,
                      style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(height: 8),
                  Text('Selesai: ${schedule.endTime}',
                      style: TextStyle(color: Colors.grey[400])),

                  const SizedBox(height: 20),
                  const Text(
                    'Tugas',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),

                  if (schedule.tasks != null)
                    ...schedule.tasks!.map((task) => Row(
                          children: [
                            Checkbox(
                              value: task.isCompleted,
                              activeColor: Colors.orange,
                              onChanged: (val) {
                                setDialogState(() {
                                  task.isCompleted = val!;
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        )),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF5B9FED),
                        ),
                        onPressed: () {
                          _showAddTaskDialog(schedule, setDialogState);
                        },
                        child: const Text(
                          '+ Assignment',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ===== ADD ASSIGNMENT =====
  void _showAddTaskDialog(
    ScheduleItem schedule,
    void Function(void Function()) setDialogState,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A2F42),
          title: const Text('Tambah Assignment',
              style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Judul tugas',
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;

                setDialogState(() {
                  schedule.tasks ??= [];
                  schedule.tasks!
                      .add(TaskItem(title: controller.text.trim()));
                });

                Navigator.pop(context);
              },
              child:
                  const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
  int _selectedIndex = 0;
  // ===== BOTTOM BAR =====
  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: const Color(0xFF1A2F42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.calendar_today, 'Today', 0, ScheduleScreen()),
          _buildNavItem(Icons.bar_chart, 'Chart', 1,JadwalScreen()),
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
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
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
}
