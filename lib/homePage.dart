import 'package:flutter/material.dart';

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
  final String? status;
  final String? badge;
  final Color color;
  final bool hasTask;
  List<TaskItem>? tasks;

  ScheduleItem({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.room,
    this.status,
    this.badge,
    required this.color,
    this.hasTask = false,
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
      hasTask: true,
      tasks: [
        TaskItem(title: 'Checklist title 1', isCompleted: true),
        TaskItem(title: 'Checklist title 2', isCompleted: true),
        TaskItem(title: 'Checklist title 3', isCompleted: false),
      ],
    ),
    ScheduleItem(
      startTime: '09:10 AM',
      endTime: '10:00 AM',
      title: 'EC 203 - Principles Macroeconomics',
      room: 'Room 101',
      status: 'Missing assignment',
      badge: 'in 45min',
      color: Colors.teal,
    ),
    ScheduleItem(
      startTime: '10:10 AM',
      endTime: '11:00 AM',
      title: 'EC 202 - Principles Microeconomics',
      room: 'Room 101',
      color: Colors.purple,
    ),
    ScheduleItem(
      startTime: '11:10 AM',
      endTime: '12:00 AM',
      title: 'FN 210 - Financial Management',
      room: 'Room 101',
      color: Colors.blue,
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '2 Desember 2025',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
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

  Widget _buildScheduleCard(ScheduleItem schedule) {
    return GestureDetector(
      onTap: () {
        _showTaskDialog(schedule);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A2F42),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.startTime,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                schedule.title,
                style: TextStyle(
                  color: schedule.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                schedule.room,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskDialog(ScheduleItem schedule) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(16),
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
                  Text(
                    schedule.title,
                    style: TextStyle(
                      color: schedule.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tugas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (schedule.tasks != null)
                    ...schedule.tasks!.map((task) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setDialogState(() {
                                  task.isCompleted = !task.isCompleted;
                                });
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: task.isCompleted
                                      ? Colors.orange
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: task.isCompleted
                                        ? Colors.orange
                                        : Colors.grey[600]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: task.isCompleted
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
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
                        ),
                      );
                    }).toList(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
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
          title: const Text(
            'Tambah Assignment',
            style: TextStyle(color: Colors.white),
          ),
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
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;
                setDialogState(() {
                  schedule.tasks ??= [];
                  schedule.tasks!.add(
                    TaskItem(title: controller.text.trim()),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      color: const Color(0xFF1A2F42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.calendar_today, color: Colors.grey),
          Icon(Icons.bar_chart, color: Colors.grey),
          Icon(Icons.add_circle, color: Color(0xFF5B9FED), size: 40),
          Icon(Icons.assignment, color: Colors.grey),
          Icon(Icons.settings, color: Colors.grey),
        ],
      ),
    );
  }
}
