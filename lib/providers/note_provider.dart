import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/note_model.dart';

class NoteProvider with ChangeNotifier {
  List<NoteModel> _notes = [];

  NoteProvider() {
    loadNotes(); // Muat data tersimpan saat pertama kali aktif
  }

  // Fungsi Menyimpan Data Catatan secara Lokal
  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      _notes.map((n) => n.toJson()).toList(),
    );
    await prefs.setString('saved_notes', encodedData);
  }

  // Fungsi Memuat Data Catatan dari SharedPreferences
  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('saved_notes');

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      _notes = decodedData.map((item) => NoteModel.fromJson(item)).toList();
    } else {
      // Data default jika penyimpanan masih kosong
      _notes = [
        NoteModel(
          id: '1',
          title: 'Pemrograman Mobile',
          content:
              'Flutter adalah framework UI Toolkit untuk membuat aplikasi native lintas platform dari satu basis kode.',
          category: 'Materi',
          date: DateTime.now(),
        ),
        NoteModel(
          id: '2',
          title: 'Basis Data',
          content:
              'SQL (Structured Query Language) adalah bahasa untuk mengelola data pada RDBMS.',
          category: 'Materi',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
      _saveNotes();
    }
    notifyListeners();
  }

  List<NoteModel> get notes => [..._notes];

  // 1. Fungsi Tambah Catatan
  void addNote(NoteModel note) {
    _notes.insert(0, note);
    _saveNotes(); // Simpan otomatis
    notifyListeners();
  }

  // 2. Fungsi Hapus Catatan
  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    _saveNotes(); // Simpan otomatis
    notifyListeners();
  }

  // 3. Fungsi Edit / Update Catatan
  void updateNote(NoteModel updatedNote) {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index >= 0) {
      _notes[index] = updatedNote;
      _saveNotes(); // Simpan otomatis
      notifyListeners();
    }
  }
}
