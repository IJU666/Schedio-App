// views/tambah_kelas_page.dart
// ========================================
// TAMBAH KELAS PAGE - DENGAN THEME SUPPORT
// ========================================

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../controllers/mata_kuliah_controller.dart';
import '../controllers/jadwal_controller.dart';
import '../models/mata_kuliah.dart';
import '../models/jadwal.dart';

class TambahKelasPage extends StatefulWidget {
  const TambahKelasPage({Key? key}) : super(key: key);

  @override
  State<TambahKelasPage> createState() => _TambahKelasPageState();
}

class _TambahKelasPageState extends State<TambahKelasPage> {
  final MataKuliahController _mataKuliahController = MataKuliahController();
  final JadwalController _jadwalController = JadwalController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _ruanganController = TextEditingController();
  final TextEditingController _dosenController = TextEditingController();
  TimeOfDay _jamMulai = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _jamSelesai = const TimeOfDay(hour: 0, minute: 0);
  String _selectedHari = 'Senin';
  Color _selectedColor = const Color(0xFF7AB8FF);

  final List<String> _hariList = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

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

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedHour = isStartTime ? _jamMulai.hour : _jamSelesai.hour;
        int selectedMinute = isStartTime ? _jamMulai.minute : _jamSelesai.minute;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDarkMode ? const Color(0xFF2A3947) : Colors.white,
              title: Text(
                isStartTime ? 'Pilih Jam Mulai' : 'Pilih Jam Selesai',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF1E2936),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 200,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 50,
                          perspective: 0.005,
                          diameterRatio: 1.2,
                          physics: const FixedExtentScrollPhysics(),
                          controller: FixedExtentScrollController(initialItem: selectedHour),
                          onSelectedItemChanged: (index) {
                            setDialogState(() {
                              selectedHour = index;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 24,
                            builder: (context, index) {
                              return Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: selectedHour == index
                                        ? const Color(0xFF7AB8FF)
                                        : (isDarkMode ? Colors.grey : Colors.grey[600]),
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
                      Text(
                        ' : ',
                        style: TextStyle(
                          fontSize: 32,
                          color: isDarkMode ? Colors.white : const Color(0xFF1E2936),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        height: 200,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 50,
                          perspective: 0.005,
                          diameterRatio: 1.2,
                          physics: const FixedExtentScrollPhysics(),
                          controller: FixedExtentScrollController(initialItem: selectedMinute),
                          onSelectedItemChanged: (index) {
                            setDialogState(() {
                              selectedMinute = index;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 60,
                            builder: (context, index) {
                              return Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: selectedMinute == index
                                        ? const Color(0xFF7AB8FF)
                                        : (isDarkMode ? Colors.grey : Colors.grey[600]),
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
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (isStartTime) {
                        _jamMulai = TimeOfDay(hour: selectedHour, minute: selectedMinute);
                      } else {
                        _jamSelesai = TimeOfDay(hour: selectedHour, minute: selectedMinute);
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('OK', style: TextStyle(color: Color(0xFF7AB8FF))),
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
          'Tambah Kelas',
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
            _buildTextField('Mata Kuliah', _namaController, 'Multimedia', isDarkMode, cardColor, textColor),
            const SizedBox(height: 20),
            _buildTextField('Ruangan', _ruanganController, 'Ruangan 8.03', isDarkMode, cardColor, textColor),
            const SizedBox(height: 20),
            _buildTextField('Dosen', _dosenController, 'Dr. Joe', isDarkMode, cardColor, textColor),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF7AB8FF), width: 1),
                      ),
                      child: Text(
                        '${_jamMulai.hour.toString().padLeft(2, '0')}.${_jamMulai.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF7AB8FF), width: 1),
                      ),
                      child: Text(
                        '${_jamSelesai.hour.toString().padLeft(2, '0')}.${_jamSelesai.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedHari,
                    dropdownColor: cardColor,
                    underline: const SizedBox(),
                    icon: Icon(Icons.arrow_drop_down, color: textColor),
                    style: TextStyle(color: textColor),
                    items: _hariList.map((String hari) {
                      return DropdownMenuItem<String>(
                        value: hari,
                        child: Text(hari),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedHari = newValue!;
                      });
                    },
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
                onPressed: _saveMataKuliah,
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
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.grey : Colors.grey[700],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: isDarkMode ? Colors.grey[600] : Colors.grey[500]),
            filled: true,
            fillColor: cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
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

  void _saveMataKuliah() {
    if (_namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi nama mata kuliah'),
          backgroundColor: Color(0xFFFF6B6B),
        ),
      );
      return;
    }

    final mataKuliahId = DateTime.now().millisecondsSinceEpoch.toString();
    final mataKuliah = MataKuliah(
      id: mataKuliahId,
      kode: '',
      nama: _namaController.text,
      ruangan: _ruanganController.text,
      sks: 0,
      dosen: _dosenController.text,
      warna: _colorToHex(_selectedColor),
    );

    final jadwal = Jadwal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mataKuliahId: mataKuliahId,
      hari: _selectedHari,
      jamMulai: '${_jamMulai.hour.toString().padLeft(2, '0')}:${_jamMulai.minute.toString().padLeft(2, '0')}',
      jamSelesai: '${_jamSelesai.hour.toString().padLeft(2, '0')}:${_jamSelesai.minute.toString().padLeft(2, '0')}',
      ruangan: _ruanganController.text,
    );

    _mataKuliahController.addMataKuliah(mataKuliah);
    _jadwalController.addJadwal(jadwal);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kelas berhasil ditambahkan'),
        backgroundColor: Color(0xFF4ECCA3),
      ),
    );
    Navigator.pop(context);
  }
}