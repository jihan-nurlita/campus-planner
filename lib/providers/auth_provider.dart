import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _userName = '';
  String _userEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get userEmail => _userEmail;

  AuthProvider() {
    _loadAuthData(); // Muat status login saat aplikasi pertama kali dibuka
  }

  // 1. Memuat data sesi login dari SharedPreferences
  Future<void> _loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    _userName = prefs.getString('user_name') ?? '';
    _userEmail = prefs.getString('user_email') ?? '';
    notifyListeners();
  }

  // 2. Menyimpan data sesi login ke SharedPreferences
  Future<void> _saveAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', _isLoggedIn);
    await prefs.setString('user_name', _userName);
    await prefs.setString('user_email', _userEmail);
  }

  // Login dengan Email
  Future<bool> loginWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoggedIn = true;
    _userEmail = email;

    // Ekstrak nama dari email secara otomatis
    String extractedName =
        email.split('@')[0].replaceAll('.', ' ').replaceAll('_', ' ');
    _userName = extractedName.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');

    await _saveAuthData(); // Simpan permanen

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Register dengan Nama & Email
  Future<bool> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;

    await _saveAuthData(); // Simpan permanen

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Logout (Hapus data tersimpan)
  Future<void> logout() async {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await prefs.remove('user_name');
    await prefs.remove('user_email');

    notifyListeners();
  }
}
