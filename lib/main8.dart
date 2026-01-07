import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tambah Kelas',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        primaryColor: const Color(0xFF5B9FFF),
      ),
      home: const TambahKelasScreen(),
    );
  }
}

class TambahKelasScreen extends StatefulWidget {
  const TambahKelasScreen({Key? key}) : super(key: key);

  @override
  State<TambahKelasScreen> createState() => _TambahKelasScreenState();
}

class _TambahKelasScreenState extends State<TambahKelasScreen> {
  final TextEditingController _mataKuliahController = TextEditingController();
  final TextEditingController _ruanganController = TextEditingController();
  final TextEditingController _waktuMulaiController = TextEditingController();
  final TextEditingController _waktuSelesaiController = TextEditingController();
  
  int _selectedDay = 2;
  String _selectedPeriod = 'Senin';
  Color _selectedColor = const Color(0xFF5B9FFF);
  double _brightnessValue = 1.0;
  int _selectedBottomNavIndex = 0;
  
  final List<Color> _presetColors = [
    const Color(0xFF5B9FFF),
    const Color(0xFF4ECDC4),
    const Color(0xFF5AE55A),
    const Color(0xFFFF8C42),
    const Color(0xFFFF5252),
    const Color(0xFFFF6B9D),
    const Color(0xFFB794F6),
  ];

  final List<Map<String, dynamic>> _daysOfWeek = [
    {'day': 2, 'name': 'Selasa', 'badge': 2},
    {'day': 3, 'name': 'Rabu', 'badge': 1},
    {'day': 4, 'name': 'Kamis', 'badge': null},
    {'day': 5, 'name': 'Jumat', 'badge': 3},
    {'day': 6, 'name': 'Sabtu', 'badge': null},
  ];

  @override
  void initState() {
    super.initState();
    _mataKuliahController.text = 'Multimedia';
    _ruanganController.text = 'Ruangan 8.03';
    _waktuMulaiController.text = '00.00';
    _waktuSelesaiController.text = '23.59';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan Calendar
            _buildCalendarHeader(),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tambah Kelas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Mata Kuliah
                      const Text(
                        'Mata Kuliah',
                        style: TextStyle(
                          color: Color(0xFF8B8B9E),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _mataKuliahController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF1A1F3A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Ruangan
                      const Text(
                        'Ruangan',
                        style: TextStyle(
                          color: Color(0xFF8B8B9E),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _ruanganController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF1A1F3A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Waktu
                      const Text(
                        'Waktu',
                        style: TextStyle(
                          color: Color(0xFF8B8B9E),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _waktuMulaiController,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFF1A1F3A),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '—',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _waktuSelesaiController,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFF1A1F3A),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1F3A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedPeriod,
                              dropdownColor: const Color(0xFF1A1F3A),
                              underline: const SizedBox(),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              style: const TextStyle(color: Colors.white),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFF8B8B9E),
                              ),
                              items: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedPeriod = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Color Picker
                      Center(
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            _updateColorFromPosition(details.localPosition);
                          },
                          onTapDown: (details) {
                            _updateColorFromPosition(details.localPosition);
                          },
                          child: CustomPaint(
                            size: const Size(200, 200),
                            painter: ColorWheelPainter(_selectedColor, _brightnessValue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Preset Colors
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _presetColors.map((color) {
                          bool isSelected = _isSameColor(_selectedColor, color);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                                // Reset brightness when selecting preset
                                _brightnessValue = 1.0;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(8),
                                border: isSelected
                                    ? Border.all(color: Colors.white, width: 3)
                                    : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      
                      // Brightness Slider (White to Color)
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 8,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 10,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 20,
                          ),
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                          thumbColor: Colors.white,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    _getBaseColorWithoutBrightness(),
                                  ],
                                ),
                              ),
                            ),
                            Slider(
                              value: _brightnessValue,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (value) {
                                setState(() {
                                  _brightnessValue = value;
                                  _updateColorWithBrightness();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Hue Slider (Color Spectrum)
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 8,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 10,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 20,
                          ),
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                          thumbColor: Colors.white,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF5B9FFF),
                                    Color(0xFF4ECDC4),
                                    Color(0xFF5AE55A),
                                    Color(0xFFFFEB3B),
                                    Color(0xFFFF8C42),
                                    Color(0xFFFF5252),
                                    Color(0xFFFF6B9D),
                                    Color(0xFFB794F6),
                                    Color(0xFF5B9FFF),
                                  ],
                                ),
                              ),
                            ),
                            Slider(
                              value: HSVColor.fromColor(_selectedColor).hue / 360,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (value) {
                                setState(() {
                                  final hsvColor = HSVColor.fromColor(_selectedColor);
                                  _selectedColor = HSVColor.fromAHSV(
                                    1.0,
                                    value * 360,
                                    hsvColor.saturation,
                                    hsvColor.value,
                                  ).toColor();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Simpan Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Show selected color info
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Warna dipilih: ${_selectedColor.value.toRadixString(16).toUpperCase()}',
                                ),
                                backgroundColor: _selectedColor,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Simpan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A0E27),
        selectedItemColor: const Color(0xFF5B9FFF),
        unselectedItemColor: const Color(0xFF8B8B9E),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 32),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Assignme',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            '2 Desember 2025',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _daysOfWeek.map((dayData) {
              bool isSelected = dayData['day'] == _selectedDay;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = dayData['day'];
                  });
                },
                child: Container(
                  width: 60,
                  height: 70,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF5B9FFF) : const Color(0xFF1A1F3A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${dayData['day']}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : const Color(0xFF8B8B9E),
                              ),
                            ),
                            Text(
                              dayData['name'],
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white : const Color(0xFF8B8B9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (dayData['badge'] != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF5252),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Center(
                              child: Text(
                                '${dayData['badge']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _updateColorFromPosition(Offset position) {
    final center = const Offset(100, 100);
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    
    if (distance <= 100) {
      final angle = math.atan2(dy, dx);
      final hue = (angle * 180 / math.pi + 360) % 360;
      final saturation = (distance / 100).clamp(0.0, 1.0);
      
      setState(() {
        _selectedColor = HSVColor.fromAHSV(
          1.0,
          hue,
          saturation,
          _brightnessValue,
        ).toColor();
      });
    }
  }

  bool _isSameColor(Color color1, Color color2) {
    // Compare colors with some tolerance for brightness variations
    final hsv1 = HSVColor.fromColor(color1);
    final hsv2 = HSVColor.fromColor(color2);
    
    return (hsv1.hue - hsv2.hue).abs() < 5 &&
           (hsv1.saturation - hsv2.saturation).abs() < 0.1;
  }

  Color _getBaseColorWithoutBrightness() {
    final hsvColor = HSVColor.fromColor(_selectedColor);
    return HSVColor.fromAHSV(
      1.0,
      hsvColor.hue,
      hsvColor.saturation,
      1.0,
    ).toColor();
  }

  void _updateColorWithBrightness() {
    final hsvColor = HSVColor.fromColor(_selectedColor);
    _selectedColor = HSVColor.fromAHSV(
      1.0,
      hsvColor.hue,
      hsvColor.saturation,
      _brightnessValue,
    ).toColor();
  }

  @override
  void dispose() {
    _mataKuliahController.dispose();
    _ruanganController.dispose();
    _waktuMulaiController.dispose();
    _waktuSelesaiController.dispose();
    super.dispose();
  }
}

class ColorWheelPainter extends CustomPainter {
  final Color selectedColor;
  final double brightness;

  ColorWheelPainter(this.selectedColor, this.brightness);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw color wheel with saturation gradient
    for (int i = 0; i < 360; i++) {
      final hue = i.toDouble();
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(brightness),
            HSVColor.fromAHSV(1.0, hue, 1.0, brightness).toColor(),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        (i * math.pi / 180),
        (math.pi / 180),
        true,
        paint,
      );
    }

    // Calculate position of selected color on wheel
    final hsvColor = HSVColor.fromColor(selectedColor);
    final angle = hsvColor.hue * math.pi / 180;
    final distance = hsvColor.saturation * radius;
    final selectorPos = Offset(
      center.dx + distance * math.cos(angle),
      center.dy + distance * math.sin(angle),
    );

    // Draw selector ring
    canvas.drawCircle(
      selectorPos,
      12,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    
    canvas.drawCircle(
      selectorPos,
      8,
      Paint()
        ..color = selectedColor
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(ColorWheelPainter oldDelegate) {
    return oldDelegate.selectedColor != selectedColor ||
           oldDelegate.brightness != brightness;
  }
}