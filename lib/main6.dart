import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Baru',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        primaryColor: const Color(0xFF0A0E27),
      ),
      home: const TugasBaruScreen(),
    );
  }
}

class TugasBaruScreen extends StatefulWidget {
  const TugasBaruScreen({Key? key}) : super(key: key);

  @override
  State<TugasBaruScreen> createState() => _TugasBaruScreenState();
}

class _TugasBaruScreenState extends State<TugasBaruScreen> {
  final TextEditingController _tugasController = TextEditingController(text: 'Tubes PPB');
  final TextEditingController _keteranganController = TextEditingController(text: 'Eg. Read from page 100 to 150');
  String selectedMataKuliah = 'PBB 666 - Pemograman Perangkat Bergerak';
  bool isPrioritas = false;
  bool isSetiapHari = true;
  bool isTenggatEnabled = true;

  @override
  void dispose() {
    _tugasController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Tugas Baru',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Tugas Input
                const Text(
                  'Tugas',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _tugasController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1A1F3A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2A2F4F)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2A2F4F)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF6B7FFF)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Mata Kuliah Dropdown
                const Text(
                  'Mata Kuliah',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F3A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2A2F4F)),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedMataKuliah,
                    dropdownColor: const Color(0xFF1A1F3A),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    items: [
                      'PBB 666 - Pemograman Perangkat Bergerak',
                      'Mata Kuliah Lainnya',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMataKuliah = newValue!;
                      });
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Keterangan
                const Text(
                  'Keterangan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _keteranganController,
                  maxLines: 5,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1A1F3A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2A2F4F)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2A2F4F)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF6B7FFF)),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Jadikan Prioritas Checkbox
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: isPrioritas,
                        onChanged: (bool? value) {
                          setState(() {
                            isPrioritas = value!;
                          });
                        },
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return const Color(0xFF6B7FFF);
                            }
                            return Colors.transparent;
                          },
                        ),
                        side: const BorderSide(
                          color: Color(0xFF2A2F4F),
                          width: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Jadikan Prioritas',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Setiap Hari Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Setiap Hari',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Switch(
                      value: isSetiapHari,
                      onChanged: (bool value) {
                        setState(() {
                          isSetiapHari = value;
                        });
                      },
                      activeColor: const Color(0xFF4ECDC4),
                      activeTrackColor: const Color(0xFF4ECDC4).withOpacity(0.5),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  'Selasa, 2 Desember 2025',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7FFF),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Tenggat Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tenggat',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Switch(
                      value: isTenggatEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          isTenggatEnabled = value;
                        });
                      },
                      activeColor: const Color(0xFF4ECDC4),
                      activeTrackColor: const Color(0xFF4ECDC4).withOpacity(0.5),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  '1 hari sebelum kelas',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7FFF),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Batal
                          _tugasController.clear();
                          _keteranganController.clear();
                          setState(() {
                            isPrioritas = false;
                            isSetiapHari = true;
                            isTenggatEnabled = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8A80),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Simpan
                          print('Tugas: ${_tugasController.text}');
                          print('Mata Kuliah: $selectedMataKuliah');
                          print('Keterangan: ${_keteranganController.text}');
                          print('Prioritas: $isPrioritas');
                          print('Setiap Hari: $isSetiapHari');
                          print('Tenggat: $isTenggatEnabled');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B7FFF),
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
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F3A),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(Icons.calendar_today, 'Today', false),
                _buildNavItem(Icons.view_week, 'Schedule', false),
                _buildAddButton(),
                _buildNavItem(Icons.grid_view, 'Assignments', false),
                _buildNavItem(Icons.settings, 'Settings', false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF6B7FFF) : Colors.grey,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? const Color(0xFF6B7FFF) : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF6B7FFF),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B7FFF).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}