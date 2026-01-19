import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/jadwal_controller.dart';
import '../controllers/mata_kuliah_controller.dart';
import '../controllers/tugas_controller.dart';
import '../models/jadwal.dart';
import '../models/mata_kuliah.dart';

class KalenderPage extends StatefulWidget {
  const KalenderPage({Key? key}) : super(key: key);

  @override
  State<KalenderPage> createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  final JadwalController _jadwalController = JadwalController();
  final MataKuliahController _mataKuliahController = MataKuliahController();
  final TugasController _tugasController = TugasController();
  
  DateTime _focusedWeek = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Auto scroll to current time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = TimeOfDay.now();
      final scrollPosition = (now.hour - 6) * 75.0; // 75 = hour height
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
    super.dispose();
  }

  List<DateTime> _getWeekDays() {
    final weekDay = _focusedWeek.weekday;
    final monday = _focusedWeek.subtract(Duration(days: weekDay - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  String _getDayName(int weekday) {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
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
    
    return Scaffold(
      backgroundColor: const Color(0xFF1E2936),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2936),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Jadwal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildWeekHeader(weekDays),
          Expanded(
            child: _buildWeekView(weekDays),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekHeader(List<DateTime> weekDays) {
    final now = DateTime.now();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Navigation arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _focusedWeek = _focusedWeek.subtract(const Duration(days: 7));
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _focusedWeek = DateTime.now();
                    _selectedDate = DateTime.now();
                  });
                },
                child: Text(
                  '${DateFormat('MMMM yyyy', 'id_ID').format(weekDays.first)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _focusedWeek = _focusedWeek.add(const Duration(days: 7));
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Day headers
          Row(
            children: [
              // Time column placeholder
              const SizedBox(width: 40),
              // Days
              ...weekDays.map((date) {
                final isToday = date.day == now.day && 
                               date.month == now.month && 
                               date.year == now.year;
                final isSelected = date.day == _selectedDate.day &&
                                  date.month == _selectedDate.month &&
                                  date.year == _selectedDate.year;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? const Color(0xFF7AB8FF)
                            : (isToday ? const Color(0xFF2A3947) : Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(color: const Color(0xFF7AB8FF), width: 2)
                            : null,
                      ),
                      child: Column(
                        children: [
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: isSelected || isToday ? Colors.white : Colors.grey[400],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getShortDayName(date.weekday),
                            style: TextStyle(
                              color: isSelected 
                                  ? Colors.white
                                  : (isToday ? Colors.grey[400] : Colors.grey[600]),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildWeekView(List<DateTime> weekDays) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Stack(
        children: [
          // Grid lines and time labels
          _buildTimeGrid(),
          // Events
          _buildEvents(weekDays),
        ],
      ),
    );
  }

  Widget _buildTimeGrid() {
    final hours = List.generate(24, (index) => index);
    
    return Column(
      children: hours.map((hour) {
        return Container(
          height: 75,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey[800]!, width: 0.5),
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
                      color: Colors.grey[600],
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
                                ? BorderSide(color: Colors.grey[800]!, width: 0.5)
                                : BorderSide.none,
                            right: BorderSide(color: Colors.grey[800]!, width: 0.5),
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
            final jadwalForDay = allJadwal.where((j) => j.hari == dayName).toList();
            
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
    final mataKuliah = _mataKuliahController.getMataKuliahById(jadwal.mataKuliahId);
    final startParts = jadwal.jamMulai.split(':');
    final endParts = jadwal.jamSelesai.split(':');
    
    final startHour = int.parse(startParts[0]);
    final startMinute = int.parse(startParts[1]);
    final endHour = int.parse(endParts[0]);
    final endMinute = int.parse(endParts[1]);
    
    final top = (startHour * 75.0) + (startMinute / 60 * 75.0);
    final duration = ((endHour * 60 + endMinute) - (startHour * 60 + startMinute)) / 60;
    final height = duration * 75.0;
    
    // Get color from mata kuliah
    Color color = const Color(0xFF7AB8FF); // Default
    if (mataKuliah != null && mataKuliah.warna.isNotEmpty) {
      color = _hexToColor(mataKuliah.warna);
    }
    
    return Positioned(
      top: top,
      left: 2,
      right: 2,
      height: height - 2,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mataKuliah?.nama ?? 'Mata Kuliah',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              jadwal.ruangan,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}