// views/kalender_page.dart
// ========================================
// KALENDER PAGE - DENGAN MODERN NAVBAR & THEME
// ========================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/jadwal_controller.dart';
import '../controllers/mata_kuliah_controller.dart';
import '../controllers/tugas_controller.dart';
import '../controllers/navigation_controller.dart';
import '../models/jadwal.dart';
import '../widgets/modern_bottom_navbar.dart';
import 'tambah_kelas_page.dart';
import 'dart:math';

class KalenderPage extends StatefulWidget {
  const KalenderPage({Key? key}) : super(key: key);

  @override
  State<KalenderPage> createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  final JadwalController _jadwalController = JadwalController();
  final MataKuliahController _mataKuliahController = MataKuliahController();
  final TugasController _tugasController = TugasController();
  final NavigationController _navigationController = NavigationController();
  DateTime _focusedWeek = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _navigationController.setIndex(1); // Schedule page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = TimeOfDay.now();
      final scrollPosition = (now.hour - 6) * 75.0;
      if (scrollPosition > 0) {
        _scrollController.animateTo(
          scrollPosition,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _navigationController.dispose();
    super.dispose();
  }

  List<DateTime> _getWeekDays() {
    final weekDay = _focusedWeek.weekday;
    final monday = _focusedWeek.subtract(Duration(days: weekDay - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  String _getDayName(int weekday) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    return days[weekday - 1];
  }

  String _getShortDayName(int weekday) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[weekday - 1];
  }

  Color _hexToColor(String hexString) {
    if (hexString.isEmpty) return const Color(0xFF7AB8FF);
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _getWeekDays();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Jadwal',
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildWeekHeader(weekDays, isDarkMode, textColor),
          Expanded(
            child: _buildWeekView(weekDays, isDarkMode),
          ),
        ],
      ),
      bottomNavigationBar: ModernBottomNavbar(
        controller: _navigationController,
        currentIndex: 1,
        onAddPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahKelasPage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }

Widget _buildWeekHeader(
      List<DateTime> weekDays, bool isDarkMode, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left_rounded,
                    color: textColor, size: 28),
                onPressed: () {
                  setState(() {
                    _focusedWeek =
                        _focusedWeek.subtract(const Duration(days: 7));
                  });
                },
              ),
              Text(
                '${DateFormat('MMMM yyyy', 'id_ID').format(weekDays.first)}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right_rounded,
                    color: textColor, size: 28),
                onPressed: () {
                  setState(() {
                    _focusedWeek = _focusedWeek.add(const Duration(days: 7));
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 10),
              ...weekDays.map((date) {
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getShortDayName(date.weekday),
                          style: TextStyle(
                            color: textColor.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekView(List<DateTime> weekDays, bool isDarkMode) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 120),
      child: Stack(
        children: [
          _buildTimeGrid(isDarkMode),
          _buildEvents(weekDays),
        ],
      ),
    );
  }

  Widget _buildTimeGrid(bool isDarkMode) {
    final hours = List.generate(24, (index) => index);
    return Column(
      children: hours.map((hour) {
        return Container(
          height: 75,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, right: 8),
                  child: Text(
                    '${hour.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[600] : Colors.grey[500],
                      fontSize: 10,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: List.generate(7, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          border: Border(
                            left: index == 0
                                ? BorderSide(
                                    color: isDarkMode
                                        ? Colors.grey[800]!
                                        : Colors.grey[300]!,
                                    width: 0.5,
                                  )
                                : BorderSide.none,
                            right: BorderSide(
                              color: isDarkMode
                                  ? Colors.grey[800]!
                                  : Colors.grey[300]!,
                              width: 0.5,
                            ),
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
      }).toList(),
    );
  }

  Widget _buildEvents(List<DateTime> weekDays) {
    final allJadwal = _jadwalController.getAllJadwal();
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.only(left: 40),
        child: Row(
          children: weekDays.map((date) {
            final dayName = _getDayName(date.weekday);
            final jadwalForDay =
                allJadwal.where((j) => j.hari == dayName).toList();
            return Expanded(
              child: Stack(
                children: jadwalForDay.map((jadwal) {
                  return _buildEventCard(jadwal);
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEventCard(Jadwal jadwal) {
    final mataKuliah =
        _mataKuliahController.getMataKuliahById(jadwal.mataKuliahId);
    final startParts = jadwal.jamMulai.split(':');
    final endParts = jadwal.jamSelesai.split(':');
    final startHour = int.parse(startParts[0]);
    final startMinute = int.parse(startParts[1]);
    final endHour = int.parse(endParts[0]);
    final endMinute = int.parse(endParts[1]);

    final top = (startHour * 75.0) + (startMinute / 60 * 75.0);
    final duration =
        ((endHour * 60 + endMinute) - (startHour * 60 + startMinute)) / 60;
    final height = duration * 75.0;
    final minHeight = 40.0;
    final finalHeight = max(height, minHeight);

    Color color = const Color(0xFF7AB8FF);
    if (mataKuliah != null && mataKuliah.warna.isNotEmpty) {
      color = _hexToColor(mataKuliah.warna);
    }

    // Dynamic font sizes berdasarkan tinggi
    final titleFontSize = finalHeight < 60 ? 10.0 : 13.0;
    final detailFontSize = finalHeight < 60 ? 9.0 : 11.0;
    final iconSize = finalHeight < 60 ? 10.0 : 12.0;
    final padding = finalHeight < 60 ? 4.0 : 8.0;

    return Positioned(
      top: top,
      left: 0,
      right: 0,
      height: finalHeight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.85),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              // Handle tap
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mataKuliah?.nama ?? 'Mata Kuliah',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: finalHeight < 60 ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (finalHeight >= 50)
                        SizedBox(height: finalHeight < 60 ? 2 : 4),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              color: Colors.white70, size: iconSize),
                          SizedBox(width: finalHeight < 60 ? 2 : 4),
                          Flexible(
                            child: Text(
                              '${jadwal.jamMulai.substring(0, 5)} - ${jadwal.jamSelesai.substring(0, 5)}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: detailFontSize,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (jadwal.ruangan.isNotEmpty && finalHeight >= 70) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.white70, size: iconSize),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                jadwal.ruangan,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: detailFontSize,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
