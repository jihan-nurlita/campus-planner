import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference(); // Muat status tema saat pertama kali dijalankan
  }

  // 1. Fungsi Memuat Status Tema dari SharedPreferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    // Ambil nilai yang tersimpan, default ke false (terang) jika belum ada
    _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    notifyListeners();
  }

  // 2. Fungsi Mengubah dan Menyimpan Status Tema
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _isDarkMode); // Simpan pilihan
    notifyListeners();
  }
}
