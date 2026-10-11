import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/schedule_model.dart';

class ScheduleProvider with ChangeNotifier {
  List<ScheduleModel> _schedules = [];

  ScheduleProvider() {
    loadSchedules(); // Panggil saat provider pertama kali aktif
  }

  // Fungsi Menyimpan Data ke SharedPreferences
  Future<void> _saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      _schedules.map((s) => s.toJson()).toList(),
    );
    await prefs.setString('saved_schedules', encodedData);
  }

  // Fungsi Memuat Data dari SharedPreferences
  Future<void> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('saved_schedules');

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      _schedules =
          decodedData.map((item) => ScheduleModel.fromJson(item)).toList();
    } else {
      // Data default jika memori masih kosong
      _schedules = [
        ScheduleModel(
          id: '1',
          subject: 'Pemrograman Mobile',
          room: 'Ruang B303',
          timeStart: '08.00',
          timeEnd: '09.40',
          day: 'Sen',
          lecturer: 'Budi Santoso, S.Kom., M.T.',
          description:
              'Mata kuliah ini membahas tentang konsep dasar hingga pengembangan aplikasi mobile menggunakan Flutter.',
        ),
        ScheduleModel(
          id: '2',
          subject: 'Basis Data',
          room: 'Ruang C305',
          timeStart: '13.00',
          timeEnd: '14.40',
          day: 'Sen',
          lecturer: 'Lestari Pujiastuti, M.Cs',
          description: 'Fokus pada SQL, normalisasi data, dan manajemen DBMS.',
        ),
      ];
      _saveSchedules();
    }
    notifyListeners();
  }

  List<ScheduleModel> get schedules => [..._schedules];

  List<ScheduleModel> get todaySchedules {
    final List<String> weekdayToDayName = [
      'Min',
      'Sen',
      'Sel',
      'Rab',
      'Kam',
      'Jum',
      'Sab',
      'Min'
    ];
    final String currentDayName = weekdayToDayName[DateTime.now().weekday];
    return _schedules.where((s) => s.day == currentDayName).toList();
  }

  List<ScheduleModel> getSchedulesByDate(DateTime selectedDate) {
    final Map<int, String> weekdayToDayName = {
      1: 'Sen',
      2: 'Sel',
      3: 'Rab',
      4: 'Kam',
      5: 'Jum',
      6: 'Sab',
      7: 'Min',
    };

    final String targetDay = weekdayToDayName[selectedDate.weekday] ?? '';
    return _schedules.where((s) => s.day == targetDay).toList();
  }

  void addSchedule(ScheduleModel schedule) {
    _schedules.add(schedule);
    _saveSchedules(); // Simpan otomatis
    notifyListeners();
  }

  void updateSchedule(ScheduleModel updatedSchedule) {
    final index = _schedules.indexWhere((s) => s.id == updatedSchedule.id);
    if (index != -1) {
      _schedules[index] = updatedSchedule;
      _saveSchedules(); // Simpan otomatis
      notifyListeners();
    }
  }

  void deleteSchedule(String id) {
    _schedules.removeWhere((s) => s.id == id);
    _saveSchedules(); // Simpan otomatis
    notifyListeners();
  }
}
