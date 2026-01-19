// tambah_tugas_page.dart

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
  bool _setiapHari = false;
  DateTime _selectedDate = DateTime.now();
  bool _tenggatEnabled = true;
  final int _hariSebelumKelas = 1;

  @override
  void dispose() {
    _judulController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF7AB8FF),
              onPrimary: Colors.white,
              surface: Color(0xFF2A3947),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF2A3947),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final allMataKuliah = _mataKuliahController.getAllMataKuliah();
    
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
          'Tugas Baru',
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
            const Text(
              'Tugas',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _judulController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Tubes PPB',
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
            const SizedBox(height: 25),
            const Text(
              'Mata Kuliah',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A3947),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonFormField<MataKuliah>(
                value: _selectedMataKuliah,
                dropdownColor: const Color(0xFF2A3947),
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
                hint: const Text(
                  'PPB 666 - Pemograman Perangkat Bergerak',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                items: allMataKuliah.map((mk) {
                  return DropdownMenuItem<MataKuliah>(
                    value: mk,
                    child: Text(
                      '${mk.kode} - ${mk.nama}',
                      style: const TextStyle(color: Colors.white),
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
            const Text(
              'Keterangan',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _keteranganController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Eg. Read from page 100 to 150',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF2A3947),
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
                  side: const BorderSide(color: Colors.grey),
                ),
                const Text(
                  'Jadikan Prioritas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Setiap Hari',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A3947),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_selectedDate),
                      style: const TextStyle(
                        color: Color(0xFF7AB8FF),
                        fontSize: 14,
                      ),
                    ),
                    Switch(
                      value: _setiapHari,
                      onChanged: (value) {
                        setState(() {
                          _setiapHari = value;
                        });
                      },
                      activeThumbColor: const Color(0xFF4ECCA3),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey[800],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Tenggat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '1 hari sebelum kelas',
                  style: TextStyle(
                    color: Color(0xFF7AB8FF),
                    fontSize: 14,
                  ),
                ),
                Switch(
                  value: _tenggatEnabled,
                  onChanged: (value) {
                    setState(() {
                      _tenggatEnabled = value;
                    });
                  },
                  activeThumbColor: const Color(0xFF4ECCA3),
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[800],
                ),
              ],
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
      tanggal: _selectedDate,
      setiapHari: _setiapHari,
      hariSebelumKelas: _hariSebelumKelas,
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