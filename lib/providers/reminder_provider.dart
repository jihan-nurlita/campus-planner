import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/reminder_model.dart';

class ReminderProvider with ChangeNotifier {
  ReminderModel _reminder = ReminderModel();

  ReminderModel get reminder => _reminder;

  ReminderProvider() {
    loadPreferences();
  }

  // Simpan status ke SharedPreferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'saved_reminder_settings', jsonEncode(_reminder.toJson()));
  }

  // Muat status saat aplikasi dibuka
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('saved_reminder_settings');

    if (data != null) {
      _reminder = ReminderModel.fromJson(jsonDecode(data));
      notifyListeners();
    }
  }

  // Update status Jadwal Kuliah
  void toggleJadwalKuliah(bool value) {
    _reminder.jadwalKuliah = value;
    _savePreferences();
    notifyListeners();
  }

  // Update status Deadline Tugas
  void toggleDeadlineTugas(bool value) {
    _reminder.deadlineTugas = value;
    _savePreferences();
    notifyListeners();
  }

  // Update status Pengingat Belajar
  void togglePengingatBelajar(bool value) {
    _reminder.pengingatBelajar = value;
    _savePreferences();
    notifyListeners();
  }

  // Update status Weekend Reminder
  void toggleWeekendReminder(bool value) {
    _reminder.weekendReminder = value;
    _savePreferences();
    notifyListeners();
  }
}
