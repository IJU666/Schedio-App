// views/tambah_tugas_page.dart
// ========================================
// TAMBAH TUGAS PAGE - DENGAN DATETIME PICKER
// ========================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/tugas_controller.dart';
import '../controllers/mata_kuliah_controller.dart';
import '../models/tugas.dart';
import '../models/mata_kuliah.dart';

class TambahTugasPage extends StatefulWidget {
  const TambahTugasPage({super.key});

  @override
  State<TambahTugasPage> createState() => _TambahTugasPageState();
}

class _TambahTugasPageState extends State<TambahTugasPage> {
  final TugasController _tugasController = TugasController();
  final MataKuliahController _mataKuliahController = MataKuliahController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  MataKuliah? _selectedMataKuliah;
  bool _isPrioritas = false;
  DateTime _selectedDateTime = DateTime.now();

  @override
  void dispose() {
    _judulController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Pilih tanggal
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: const Color(0xFF7AB8FF),
              onPrimary: Colors.white,
              surface: isDarkMode ? const Color(0xFF2A3947) : Colors.white,
              onSurface: isDarkMode ? Colors.white : const Color(0xFF1E2936),
            ),
            dialogBackgroundColor: isDarkMode ? const Color(0xFF2A3947) : Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Pilih waktu dengan format 24 jam dan mode input
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        initialEntryMode: TimePickerEntryMode.input,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                primary: const Color(0xFF7AB8FF),
                onPrimary: Colors.white,
                surface: isDarkMode ? const Color(0xFF2A3947) : Colors.white,
                onSurface: isDarkMode ? Colors.white : const Color(0xFF1E2936),
              ),
              dialogBackgroundColor: isDarkMode ? const Color(0xFF2A3947) : Colors.white,
              timePickerTheme: TimePickerThemeData(
                hourMinuteTextStyle: TextStyle(
                  fontSize: 40,
                  color: isDarkMode ? Colors.white : const Color(0xFF1E2936),
                ),
                dayPeriodTextStyle: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF1E2936),
                ),
              ),
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true,
              ),
              child: child!,
            ),
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allMataKuliah = _mataKuliahController.getAllMataKuliah();
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
          'Tugas Baru',
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
            Text(
              'Tugas',
              style: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _judulController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Tubes PPB',
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
            const SizedBox(height: 25),
            Text(
              'Mata Kuliah',
              style: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonFormField<MataKuliah>(
                value: _selectedMataKuliah,
                dropdownColor: cardColor,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                hint: Text(
                  'Mata Kuliah',
                  style: TextStyle(color: textColor),
                ),
                icon: Icon(Icons.arrow_drop_down, color: textColor),
                items: allMataKuliah.map((mk) {
                  return DropdownMenuItem<MataKuliah>(
                    value: mk,
                    child: Text(
                      '${mk.kode} - ${mk.nama}',
                      style: TextStyle(color: textColor),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMataKuliah = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'Keterangan',
              style: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _keteranganController,
              maxLines: 4,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Eg. Read from page 100 to 150',
                hintStyle: TextStyle(color: isDarkMode ? Colors.grey[600] : Colors.grey[500]),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(20),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Checkbox(
                  value: _isPrioritas,
                  onChanged: (value) {
                    setState(() {
                      _isPrioritas = value ?? false;
                    });
                  },
                  activeColor: const Color(0xFF7AB8FF),
                  side: BorderSide(color: isDarkMode ? Colors.grey : Colors.grey[600]!),
                ),
                Text(
                  'Jadikan Prioritas',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              'Deadline',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _selectDateTime(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_selectedDateTime),
                            style: const TextStyle(
                              color: Color(0xFF7AB8FF),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat('HH:mm').format(_selectedDateTime),
                            style: TextStyle(
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: const Color(0xFF7AB8FF),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B6B),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveTugas,
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
          ],
        ),
      ),
    );
  }

  void _saveTugas() {
    if (_judulController.text.isEmpty || _selectedMataKuliah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi data tugas'),
          backgroundColor: Color(0xFFFF6B6B),
        ),
      );
      return;
    }

    final tugas = Tugas(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      judul: _judulController.text,
      mataKuliahId: _selectedMataKuliah!.id,
      mataKuliahNama: _selectedMataKuliah!.nama,
      keterangan: _keteranganController.text,
      isPrioritas: _isPrioritas,
      tanggal: _selectedDateTime,
      setiapHari: false,
      hariSebelumKelas: 0,
      checklist: ['Checklist title 1', 'Checklist title 2', 'Checklist title 3'],
      checklistStatus: [true, true, false],
    );

    _tugasController.addTugas(tugas);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tugas berhasil ditambahkan'),
        backgroundColor: Color(0xFF4ECCA3),
      ),
    );
    Navigator.pop(context);
  }
}