class KelasModel {
  final String id;
  final String namaMataKuliah;
  final String hari; 
  final String jamMulai; 
  final String jamSelesai; 

  KelasModel({
    required this.id,
    required this.namaMataKuliah,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
  });

  DateTime getNextClassDateTime() {
    final now = DateTime.now();
    final targetDay = _getNextDayOfWeek(hari);
    final timeParts = jamMulai.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    DateTime classDateTime = DateTime(
      targetDay.year,
      targetDay.month,
      targetDay.day,
      hour,
      minute,
    );

  
    if (classDateTime.isBefore(now)) {
      classDateTime = classDateTime.add(const Duration(days: 7));
    }

    return classDateTime;
  }

  DateTime _getNextDayOfWeek(String dayName) {
    final now = DateTime.now();
    final targetWeekday = _getDayNumber(dayName);
    final currentWeekday = now.weekday;

    int daysToAdd = targetWeekday - currentWeekday;
    if (daysToAdd < 0) {
      daysToAdd += 7;
    }

    return now.add(Duration(days: daysToAdd));
  }

  int _getDayNumber(String dayName) {
    const days = {
      'Senin': 1,
      'Selasa': 2,
      'Rabu': 3,
      'Kamis': 4,
      'Jumat': 5,
      'Sabtu': 6,
      'Minggu': 7,
    };
    return days[dayName] ?? 1;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaMataKuliah': namaMataKuliah,
      'hari': hari,
      'jamMulai': jamMulai,
      'jamSelesai': jamSelesai,
    };
  }


  factory KelasModel.fromMap(Map<String, dynamic> map) {
    return KelasModel(
      id: map['id'],
      namaMataKuliah: map['namaMataKuliah'],
      hari: map['hari'],
      jamMulai: map['jamMulai'],
      jamSelesai: map['jamSelesai'],
    );
  }
}