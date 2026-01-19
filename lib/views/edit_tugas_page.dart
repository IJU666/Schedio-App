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
  late bool _setiapHari;
  late DateTime _selectedDate;
  late int _hariSebelumKelas;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.tugas.judul);
    _keteranganController = TextEditingController(text: widget.tugas.keterangan);
    _selectedMataKuliah = _mataKuliahController.getMataKuliahById(widget.tugas.mataKuliahId);
    _isPrioritas = widget.tugas.isPrioritas;
    _setiapHari = widget.tugas.setiapHari;
    _selectedDate = widget.tugas.tanggal;
    _hariSebelumKelas = widget.tugas.hariSebelumKelas;
  }

  @override
  void dispose() {
    _judulController.dispose();
    _keteranganController.dispose();
    super.dispose();
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
          'Edit Tugas',
          style: TextStyle(
            color: Colors.white,
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
                initialValue: _selectedMataKuliah,
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
            Row(
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
                    onPressed: _updateTugas,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7AB8FF),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
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

  void _updateTugas() {
    if (_judulController.text.isEmpty || _selectedMataKuliah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi data tugas'),
          backgroundColor: Color(0xFFFF6B6B),
        ),
      );
      return;
    }

    widget.tugas.judul = _judulController.text;
    widget.tugas.mataKuliahId = _selectedMataKuliah!.id;
    widget.tugas.mataKuliahNama = _selectedMataKuliah!.nama;
    widget.tugas.keterangan = _keteranganController.text;
    widget.tugas.isPrioritas = _isPrioritas;
    widget.tugas.tanggal = _selectedDate;
    widget.tugas.setiapHari = _setiapHari;
    widget.tugas.hariSebelumKelas = _hariSebelumKelas;

    _tugasController.updateTugas(widget.tugas);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tugas berhasil diupdate'),
        backgroundColor: Color(0xFF4ECCA3),
      ),
    );

    Navigator.pop(context);
  }

  void _deleteTugas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A3947),
        title: const Text(
          'Hapus Tugas',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus tugas ini?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _tugasController.deleteTugas(widget.tugas.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tugas berhasil dihapus'),
                  backgroundColor: Color(0xFFFF6B6B),
                ),
              );
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