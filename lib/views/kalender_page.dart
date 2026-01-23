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

const double timeColumnWidth = 40.0;
const double dayColumnMargin = 1.0;

class _KalenderPageState extends State<KalenderPage> {
  final JadwalController _jadwalController = JadwalController();
  final MataKuliahController _mataKuliahController = MataKuliahController();
  final TugasController _tugasController = TugasController();
  final NavigationController _navigationController = NavigationController();
  DateTime _focusedWeek = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  void _showDetailJadwal(Jadwal jadwal) {
    final mataKuliah =
        _mataKuliahController.getMataKuliahById(jadwal.mataKuliahId);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF1E293B),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                mataKuliah?.nama ?? 'Mata Kuliah',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              _detailRow("Hari", jadwal.hari),
              _detailRow("Jam", "${jadwal.jamMulai} - ${jadwal.jamSelesai}"),
              _detailRow("Ruang", jadwal.ruangan),
              _detailRow("Dosen", mataKuliah?.dosen ?? 'N/A'),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

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
              SizedBox(width: timeColumnWidth/2),
              Expanded(
                
                  child: Row(
                    children: List.generate(7, (index) {
                      final date = weekDays[index];
                      return Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
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
                    }),
                  ),
                ),
              
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
                width: timeColumnWidth,
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
        padding: const EdgeInsets.only(left: timeColumnWidth),
        child: Row(
          children: weekDays.map((date) {
            final dayName = _getDayName(date.weekday);
            final jadwalForDay =
                allJadwal.where((j) => j.hari == dayName).toList();
            final conflictGroups = <List<Jadwal>>[];

            for (final jadwal in jadwalForDay) {
              bool added = false;
              for (final group in conflictGroups) {
                if (group.any((j) => _isOverlap(j, jadwal))) {
                  group.add(jadwal);
                  added = true;
                  break;
                }
              }
              if (!added) {
                conflictGroups.add([jadwal]);
              }
            }

            return Expanded(
              child: Stack(
                children: conflictGroups.expand((group) {
                  final total = group.length;
                  return group.asMap().entries.map((entry) {
                    final index = entry.key;
                    final jadwal = entry.value;
                    return _buildEventCard(
                      jadwal,
                      conflictIndex: index,
                      conflictTotal: total,
                    );
                  });
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  bool _isOverlap(Jadwal a, Jadwal b) {
    int startA = _toMinutes(a.jamMulai);
    int endA = _toMinutes(a.jamSelesai);
    int startB = _toMinutes(b.jamMulai);
    int endB = _toMinutes(b.jamSelesai);

    return startA < endB && startB < endA;
  }

  int _toMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  Widget _buildEventCard(Jadwal jadwal,
      {required int conflictIndex, required int conflictTotal}) {
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

    // Hitung lebar yang tersedia per kolom hari
    final screenWidth = MediaQuery.of(context).size.width;
    final timeColumnWidth = 40.0; // Lebar kolom waktu
    final horizontalPadding = 0.0; // Padding horizontal dari Positioned.fill
    final availableWidth =
        (screenWidth - timeColumnWidth - horizontalPadding) / 7;

    // Margin horizontal untuk setiap event
    final horizontalMargin = 2.0;
    final totalHorizontalMargin = horizontalMargin * 2;

    // Hitung lebar event berdasarkan jumlah konflik
    // TIDAK menggunakan minWidth agar semua event terlihat
    final eventWidth = (availableWidth - totalHorizontalMargin) / conflictTotal;

    // Offset kiri untuk event yang konflik
    final leftOffset = conflictIndex * eventWidth;

    // Dynamic font sizes berdasarkan tinggi dan lebar
    final isVeryNarrow = eventWidth < 40;
    final isExtremelyNarrow = eventWidth < 30;

    final titleFontSize = isExtremelyNarrow
        ? 8.0
        : (isVeryNarrow ? 9.0 : (finalHeight < 60 ? 10.0 : 12.0));

    final detailFontSize = isExtremelyNarrow
        ? 7.0
        : (isVeryNarrow ? 8.0 : (finalHeight < 60 ? 9.0 : 10.0));

    final iconSize = isExtremelyNarrow
        ? 8.0
        : (isVeryNarrow ? 9.0 : (finalHeight < 60 ? 10.0 : 11.0));

    final padding = isExtremelyNarrow ? 3.0 : (finalHeight < 60 ? 4.0 : 6.0);

    return Positioned(
      top: top,
      left: leftOffset,
      width: eventWidth,
      height: finalHeight,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          _showDetailJadwal(jadwal);
        },
        child: Container(
          margin:
              EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.85),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final canShowTime =
                      constraints.maxHeight >= 40 && constraints.maxWidth >= 35;
                  final canShowRoom =
                      constraints.maxHeight >= 65 && constraints.maxWidth >= 40;
                  final showIconsOnly = constraints.maxWidth < 30;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // NAMA MATKUL (WAJIB)
                      Flexible(
                        child: Text(
                          mataKuliah?.nama ?? 'MK',
                          maxLines: canShowTime ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ),

                      if (canShowTime) ...[
                        SizedBox(height: padding / 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!showIconsOnly) ...[
                              Icon(Icons.access_time,
                                  size: iconSize, color: Colors.white70),
                              const SizedBox(width: 2),
                            ],
                            Flexible(
                              child: Text(
                                showIconsOnly
                                    ? jadwal.jamMulai.substring(0, 2)
                                    : jadwal.jamMulai.substring(0, 5),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: detailFontSize,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      if (canShowRoom && jadwal.ruangan.isNotEmpty) ...[
                        SizedBox(height: padding / 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!showIconsOnly) ...[
                              Icon(Icons.location_on,
                                  size: iconSize, color: Colors.white70),
                              const SizedBox(width: 2),
                            ],
                            Flexible(
                              child: Text(
                                jadwal.ruangan,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: detailFontSize,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
