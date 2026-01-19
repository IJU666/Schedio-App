// edit_kelas_page
import 'package:flutter/material.dart';
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedHour = isStartTime ? _jamMulai.hour : _jamSelesai.hour;
        int selectedMinute = isStartTime ? _jamMulai.minute : _jamSelesai.minute;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2A3947),
              title: Text(
                isStartTime ? 'Pilih Jam Mulai' : 'Pilih Jam Selesai',
                style: const TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
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
                                        : Colors.grey,
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
                      const Text(
                        ' : ',
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                      Container(
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
                                        : Colors.grey,
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = _selectedColor;
        return AlertDialog(
          backgroundColor: const Color(0xFF2A3947),
          title: const Text(
            'Pilih Warna',
            style: TextStyle(color: Colors.white),
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
                    color: const Color(0xFF1E2936),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _colorToHex(tempColor),
                    style: const TextStyle(
                      color: Colors.white,
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
    if (_jadwal == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E2936),
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          'Edit Kelas',
          style: TextStyle(
            color: Colors.white,
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
            _buildTextField('Mata Kuliah', _namaController, 'Multimedia'),
            const SizedBox(height: 20),
            _buildTextField('Ruangan', _ruanganController, 'Ruangan 8.03'),
            const SizedBox(height: 20),
            _buildTextField('Dosen', _dosenController, 'Dr. Joe'),
            const SizedBox(height: 20),
            const Text(
              'Waktu',
              style: TextStyle(
                color: Colors.grey,
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
                        color: const Color(0xFF2A3947),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF7AB8FF), width: 1),
                      ),
                      child: Text(
                        '${_jamMulai.hour.toString().padLeft(2, '0')}.${_jamMulai.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    '—',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime(context, false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A3947),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF7AB8FF), width: 1),
                      ),
                      child: Text(
                        '${_jamSelesai.hour.toString().padLeft(2, '0')}.${_jamSelesai.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: Colors.white,
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
                    color: const Color(0xFF2A3947),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedHari,
                    dropdownColor: const Color(0xFF2A3947),
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    style: const TextStyle(color: Colors.white),
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
            const Text(
              'Warna',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _showColorPicker,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A3947),
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
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      _colorToHex(_selectedColor),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
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

  Widget _buildTextField(String label, TextEditingController controller, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: const Color(0xFF2A3947),
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

  void _updateKelas() {
    if (_namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi nama mata kuliah'),
          backgroundColor: Color(0xFFFF6B6B),
        ),
      );
      return;
    }

    // Update MataKuliah
    if (_mataKuliah != null) {
      _mataKuliah!.nama = _namaController.text;
      _mataKuliah!.dosen = _dosenController.text;
      _mataKuliah!.warna = _colorToHex(_selectedColor);
      _mataKuliahController.updateMataKuliah(_mataKuliah!);
    }

    // Update Jadwal
    _jadwal!.hari = _selectedHari;
    _jadwal!.jamMulai = '${_jamMulai.hour.toString().padLeft(2, '0')}:${_jamMulai.minute.toString().padLeft(2, '0')}';
    _jadwal!.jamSelesai = '${_jamSelesai.hour.toString().padLeft(2, '0')}:${_jamSelesai.minute.toString().padLeft(2, '0')}';
    _jadwal!.ruangan = _ruanganController.text;
    _jadwalController.updateJadwal(_jadwal!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kelas berhasil diupdate'),
        backgroundColor: Color(0xFF4ECCA3),
      ),
    );

    Navigator.pop(context, true);
  }
}