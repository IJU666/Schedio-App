import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/schedule_manager.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../controllers/mata_kuliah_controller.dart';
import '../controllers/jadwal_controller.dart';
import '../models/mata_kuliah.dart';
import '../models/jadwal.dart';

class EditKelasPage extends StatefulWidget {
  final String jadwalId;
  const EditKelasPage({Key? key, required this.jadwalId}) : super(key: key);

  @override
  State<EditKelasPage> createState() => _EditKelasPageState();
}

class _EditKelasPageState extends State<EditKelasPage> {
  final MataKuliahController _mataKuliahController = MataKuliahController();
  final JadwalController _jadwalController = JadwalController();
  late TextEditingController _namaController;
  late TextEditingController _ruanganController;
  late TextEditingController _dosenController;
  
  late TimeOfDay _jamMulai;
  late TimeOfDay _jamSelesai;
  late String _selectedHari;
  late Color _selectedColor;

  
  static const int maxNamaLength = 25;
  static const int maxRuanganLength = 20;
  static const int maxDosenLength = 30;

  final List<String> _hariList = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  Jadwal? _jadwal;
  MataKuliah? _mataKuliah;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  bool _isEndTimeAfterStart(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return endMinutes > startMinutes;
  }

  bool _isTimeEmpty(TimeOfDay time) {
    return time.hour == 0 && time.minute == 0;
  }

  void _loadData() {
    _jadwal = _jadwalController.getJadwalById(widget.jadwalId);
    if (_jadwal != null) {
      _mataKuliah = _mataKuliahController.getMataKuliahById(_jadwal!.mataKuliahId);
      _namaController = TextEditingController(text: _mataKuliah?.nama ?? '');
      _ruanganController = TextEditingController(text: _jadwal!.ruangan);
      _dosenController = TextEditingController(text: _mataKuliah?.dosen ?? '');

      final startParts = _jadwal!.jamMulai.split(':');
      _jamMulai = TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      );

      final endParts = _jadwal!.jamSelesai.split(':');
      _jamSelesai = TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      );

      _selectedHari = _jadwal!.hari;
      _selectedColor = _hexToColor(_mataKuliah?.warna ?? '#7AB8FF');
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _ruanganController.dispose();
    _dosenController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color _hexToColor(String hexString) {
    if (hexString.isEmpty) return const Color(0xFF7AB8FF);
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedHour = isStartTime ? _jamMulai.hour : _jamSelesai.hour;
        int selectedMinute = isStartTime ? _jamMulai.minute : _jamSelesai.minute;
        
        final hourController = TextEditingController(text: selectedHour.toString().padLeft(2, '0'));
        final minuteController = TextEditingController(text: selectedMinute.toString().padLeft(2, '0'));
        
        final hourScrollController = FixedExtentScrollController(initialItem: selectedHour);
        final minuteScrollController = FixedExtentScrollController(initialItem: selectedMinute);

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDarkMode ? const Color(0xFF2A3947) : Colors.white,
              title: Text(
                isStartTime ? 'Pilih Jam Mulai' : 'Pilih Jam Selesai',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF1E2936),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Column(
                        children: [
                          Container(
                            width: 70,
                            height: 45,
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF1E2936) : Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF7AB8FF),
                                width: 2,
                              ),
                            ),
                            child: TextField(
                              controller: hourController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7AB8FF),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              onTap: () {
                                hourController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: hourController.text.length,
                                );
                              },
                              onChanged: (value) {
                                if (value.isEmpty) return;
                                
                                int? hour = int.tryParse(value);
                                if (hour != null && hour >= 0 && hour < 24) {
                                  setDialogState(() {
                                    selectedHour = hour;
                                    if (value.length == 2) {
                                      hourController.text = hour.toString().padLeft(2, '0');
                                      hourController.selection = TextSelection.fromPosition(
                                        TextPosition(offset: hourController.text.length),
                                      );
                                    }
                                    hourScrollController.jumpToItem(hour);
                                  });
                                } else if (hour != null && hour >= 24) {
                                  setDialogState(() {
                                    hourController.text = '23';
                                    selectedHour = 23;
                                    hourScrollController.jumpToItem(23);
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 80,
                            height: 150,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 70,
                              perspective: 0.005,
                              diameterRatio: 1.5,
                              physics: const FixedExtentScrollPhysics(),
                              controller: hourScrollController,
                              onSelectedItemChanged: (index) {
                                setDialogState(() {
                                  selectedHour = index;
                                  hourController.text = index.toString().padLeft(2, '0');
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 24,
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: selectedHour == index
                                            ? const Color(0xFF7AB8FF)
                                            : (isDarkMode ? Colors.grey[600] : Colors.grey[500]),
                                        fontWeight: selectedHour == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          ':',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : const Color(0xFF1E2936),
                          ),
                        ),
                      ),
                      
                      
                      Column(
                        children: [
                          Container(
                            width: 70,
                            height: 45,
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF1E2936) : Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF7AB8FF),
                                width: 2,
                              ),
                            ),
                            child: TextField(
                              controller: minuteController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7AB8FF),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              onTap: () {
                                minuteController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: minuteController.text.length,
                                );
                              },
                              onChanged: (value) {
                                if (value.isEmpty) return;
                                
                                int? minute = int.tryParse(value);
                                if (minute != null && minute >= 0 && minute < 60) {
                                  setDialogState(() {
                                    selectedMinute = minute;
                                    if (value.length == 2) {
                                      minuteController.text = minute.toString().padLeft(2, '0');
                                      minuteController.selection = TextSelection.fromPosition(
                                        TextPosition(offset: minuteController.text.length),
                                      );
                                    }
                                    minuteScrollController.jumpToItem(minute);
                                  });
                                } else if (minute != null && minute >= 60) {
                                  setDialogState(() {
                                    minuteController.text = '59';
                                    selectedMinute = 59;
                                    minuteScrollController.jumpToItem(59);
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 80,
                            height: 150,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 70,
                              perspective: 0.005,
                              diameterRatio: 1.5,
                              physics: const FixedExtentScrollPhysics(),
                              controller: minuteScrollController,
                              onSelectedItemChanged: (index) {
                                setDialogState(() {
                                  selectedMinute = index;
                                  minuteController.text = index.toString().padLeft(2, '0');
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 60,
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: selectedMinute == index
                                            ? const Color(0xFF7AB8FF)
                                            : (isDarkMode ? Colors.grey[600] : Colors.grey[500]),
                                        fontWeight: selectedMinute == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final pickedTime = TimeOfDay(
                      hour: selectedHour,
                      minute: selectedMinute,
                    );

                    if (!isStartTime && !_isEndTimeAfterStart(_jamMulai, pickedTime)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Jam selesai tidak valid'),
                          backgroundColor: Color(0xFFFF6B6B),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      if (isStartTime) {
                        _jamMulai = pickedTime;
                        if (!_isEndTimeAfterStart(_jamMulai, _jamSelesai)) {
                          _jamSelesai = pickedTime;
                        }
                      } else {
                        _jamSelesai = pickedTime;
                      }
                    });

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7AB8FF),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showColorPicker() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = _selectedColor;
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF2A3947) : Colors.white,
          title: Text(
            'Pilih Warna',
            style: TextStyle(
              color: isDarkMode ? Colors.white : const Color(0xFF1E2936),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                  pickerColor: _selectedColor,
                  onColorChanged: (color) {
                    tempColor = color;
                  },
                  colorPickerWidth: 300,
                  pickerAreaHeightPercent: 0.7,
                  enableAlpha: false,
                  displayThumbColor: true,
                  paletteType: PaletteType.hueWheel,
                  labelTypes: const [],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E2936) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _colorToHex(tempColor),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : const Color(0xFF1E2936),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedColor = tempColor;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7AB8FF),
              ),
              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
final screenWidth = MediaQuery.of(context).size.width;
final screenHeight = MediaQuery.of(context).size.height;
final textScale = MediaQuery.of(context).textScaleFactor;
final isSmallScreen = screenHeight < 700;
final timeFieldHeight = isSmallScreen ? 44.0 : 52.0;
final fontSize = isSmallScreen ? 15.0 : 16.0;



    if (_jadwal == null) {
      return Scaffold(
        backgroundColor: bgColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Kelas',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              'Mata Kuliah', 
              _namaController, 
              'Multimedia', 
              isDarkMode, 
              cardColor, 
              textColor,
              maxLength: maxNamaLength,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              'Ruangan', 
              _ruanganController, 
              'Ruangan 8.03', 
              isDarkMode, 
              cardColor, 
              textColor,
              maxLength: maxRuanganLength,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              'Dosen', 
              _dosenController, 
              'Dr. Joe', 
              isDarkMode, 
              cardColor, 
              textColor,
              maxLength: maxDosenLength,
            ),
            const SizedBox(height: 20),
            Text(
              'Waktu',
              style: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime(context, true),
                    child: Container(
  height: timeFieldHeight,
  alignment: Alignment.center,
  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
  decoration: BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: const Color(0xFF7AB8FF), width: 1),
  ),
  child: Text(
    '${_jamMulai.hour.toString().padLeft(2, '0')}.${_jamMulai.minute.toString().padLeft(2, '0')}',
    style: TextStyle(
      color: textColor,
      fontSize: fontSize,
    ),
    textAlign: TextAlign.center,
  ),
),


                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    '—',
                    style: TextStyle(color: textColor, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime(context, false),
                    child: Container(
  height: timeFieldHeight,
  alignment: Alignment.center,
  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
  decoration: BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: const Color(0xFF7AB8FF), width: 1),
  ),
  child: Text(
    '${_jamSelesai.hour.toString().padLeft(2, '0')}.${_jamSelesai.minute.toString().padLeft(2, '0')}',
    style: TextStyle(
      color: textColor,
      fontSize: fontSize,
    ),
    textAlign: TextAlign.center,
  ),
),


                  ),
                ),
                const SizedBox(width: 10),
    Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedHari,
          dropdownColor: cardColor,
          icon: Icon(Icons.arrow_drop_down, color: textColor),
          style: TextStyle(color: textColor),
          items: _hariList.map((hari) {
            return DropdownMenuItem(
              value: hari,
              child: Text(hari),
            );
          }).toList(),
          onChanged: (val) {
            setState(() => _selectedHari = val!);
          },
        ),
      ),
    ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              'Warna',
              style: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _showColorPicker,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: textColor, width: 2),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      _colorToHex(_selectedColor),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.grey : Colors.grey[600], size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateKelas,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7AB8FF),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String placeholder,
    bool isDarkMode,
    Color cardColor,
    Color textColor, {
    required int maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.grey[700],
                fontSize: 14,
              ),
            ),
            Text(
              '${controller.text.length}/$maxLength',
              style: TextStyle(
                color: controller.text.length >= maxLength 
                    ? const Color(0xFFFF6B6B) 
                    : (isDarkMode ? Colors.grey[600] : Colors.grey[500]),
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          style: TextStyle(color: textColor),
          maxLength: maxLength,
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength),
          ],
          onChanged: (value) {
            setState(() {}); 
          },
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: isDarkMode ? Colors.grey[600] : Colors.grey[500]),
            filled: true,
            fillColor: cardColor,
            counterText: '', 
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: controller.text.length >= maxLength 
                    ? const Color(0xFFFF6B6B).withOpacity(0.5)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: controller.text.length >= maxLength 
                    ? const Color(0xFFFF6B6B)
                    : const Color(0xFF7AB8FF),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
          ),
        ),
      ],
    );
  }

void _updateKelas() async {
  if (_namaController.text.trim().isEmpty ||
      _ruanganController.text.trim().isEmpty ||
      _dosenController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mohon lengkapi semua field'),
        backgroundColor: Color(0xFFFF6B6B),
      ),
    );
    return;
  }

  if (_isTimeEmpty(_jamMulai) || _isTimeEmpty(_jamSelesai)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Jam mulai dan jam selesai wajib diisi'),
        backgroundColor: Color(0xFFFF6B6B),
      ),
    );
    return;
  }

  if (!_isEndTimeAfterStart(_jamMulai, _jamSelesai)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Jam selesai harus lebih besar dari jam mulai'),
        backgroundColor: Color(0xFFFF6B6B),
      ),
    );
    return;
  }

  if (_mataKuliah != null) {
    _mataKuliah!
      ..nama = _namaController.text
      ..dosen = _dosenController.text
      ..warna = _colorToHex(_selectedColor);

    _mataKuliahController.updateMataKuliah(_mataKuliah!);
  }

  _jadwal!
    ..hari = _selectedHari
    ..jamMulai =
        '${_jamMulai.hour.toString().padLeft(2, '0')}:${_jamMulai.minute.toString().padLeft(2, '0')}'
    ..jamSelesai =
        '${_jamSelesai.hour.toString().padLeft(2, '0')}:${_jamSelesai.minute.toString().padLeft(2, '0')}'
    ..ruangan = _ruanganController.text;

  _jadwalController.updateJadwal(_jadwal!);

  await ScheduleManager().updateSchedule(_jadwal!.id);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Kelas berhasil diupdate'),
      backgroundColor: Color(0xFF4ECCA3),
    ),
  );

  Navigator.pop(context, true);
}
  }