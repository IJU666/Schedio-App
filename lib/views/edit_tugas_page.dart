// views/edit_tugas_page.dart
// ========================================
// EDIT TUGAS PAGE - DENGAN UPDATE/CANCEL NOTIFIKASI
// ========================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/tugas_controller.dart';
import '../controllers/mata_kuliah_controller.dart';
import '../models/tugas.dart';
import '../models/mata_kuliah.dart';

class EditTugasPage extends StatefulWidget {
  final Tugas tugas;
  const EditTugasPage({super.key, required this.tugas});

  @override
  State<EditTugasPage> createState() => _EditTugasPageState();
}

class _EditTugasPageState extends State<EditTugasPage> {
  final TugasController _tugasController = TugasController();
  final MataKuliahController _mataKuliahController = MataKuliahController();

  late TextEditingController _judulController;
  late TextEditingController _keteranganController;
  late MataKuliah? _selectedMataKuliah;
  late bool _isPrioritas;
  late DateTime _selectedDateTime;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.tugas.judul);
    _keteranganController = TextEditingController(text: widget.tugas.keterangan);
    _selectedMataKuliah = _mataKuliahController.getMataKuliahById(widget.tugas.mataKuliahId);
    _isPrioritas = widget.tugas.isPrioritas;
    _selectedDateTime = widget.tugas.tanggal;
  }

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
          'Edit Tugas',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFFF6B6B)),
            onPressed: _deleteTugas,
          ),
        ],
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
            const SizedBox(height: 20),
            // Info notifikasi otomatis
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF7AB8FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF7AB8FF).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: const Color(0xFF7AB8FF),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Notifikasi akan diperbarui otomatis:\n• 1 hari sebelum\n• 5 jam sebelum\n• 1 jam sebelum\n• 30 menit sebelum deadline',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isUpdating ? null : () => Navigator.pop(context),
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
                    onPressed: _isUpdating ? null : _updateTugas,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7AB8FF),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isUpdating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Update',
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

  void _updateTugas() async {
    if (_judulController.text.isEmpty || _selectedMataKuliah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi data tugas'),
          backgroundColor: Color(0xFFFF6B6B),
        ),
      );
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      widget.tugas.judul = _judulController.text;
      widget.tugas.mataKuliahId = _selectedMataKuliah!.id;
      widget.tugas.mataKuliahNama = _selectedMataKuliah!.nama;
      widget.tugas.keterangan = _keteranganController.text;
      widget.tugas.isPrioritas = _isPrioritas;
      widget.tugas.tanggal = _selectedDateTime;

      // Update tugas dan reschedule notifikasi otomatis
      await _tugasController.updateTugas(widget.tugas);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Tugas berhasil diupdate dengan notifikasi!'),
            backgroundColor: Color(0xFF4ECCA3),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Color(0xFFFF6B6B),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  void _deleteTugas() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF2A3947) : Colors.white,
        title: Text(
          'Hapus Tugas',
          style: TextStyle(
            color: isDarkMode ? Colors.white : const Color(0xFF1E2936),
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus tugas ini? Notifikasi juga akan dihapus.',
          style: TextStyle(
            color: isDarkMode ? Colors.white : const Color(0xFF1E2936),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              // Hapus tugas dan cancel notifikasi otomatis
              await _tugasController.deleteTugas(widget.tugas.id);
              
              if (mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close edit page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🗑️ Tugas dan notifikasi berhasil dihapus'),
                    backgroundColor: Color(0xFFFF6B6B),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );
  }
}