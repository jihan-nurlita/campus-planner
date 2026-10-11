import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/note_model.dart';
import '../../providers/note_provider.dart';
import '../../providers/theme_provider.dart';
import 'edit_note_screen.dart'; // Import halaman edit

class NoteDetailScreen extends StatefulWidget {
  final NoteModel note;
  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  // Variabel lokal untuk menyimpan data catatan agar bisa diperbarui secara dinamis di layar ini
  late NoteModel _currentNote;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.note;
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final isDark =
            Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
        final textColor = isDark ? Colors.white : Colors.black;

        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Hapus Catatan',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus catatan "${_currentNote.title}"?',
            style: TextStyle(
                color: isDark ? Colors.white70 : AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<NoteProvider>(context, listen: false)
                    .deleteNote(_currentNote.id);
                Navigator.pop(dialogContext);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Catatan berhasil dihapus'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              child: const Text('Hapus',
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final titleColor = isDark ? Colors.white : Colors.black;
    final contentColor = isDark ? Colors.white70 : Colors.black;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          'Detail Catatan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: titleColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        iconTheme: IconThemeData(color: titleColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              // Navigasi ke EditNoteScreen dan tunggu hasil kembalian datanya
              final updatedData = await Navigator.push<NoteModel>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditNoteScreen(note: _currentNote),
                ),
              );

              // Jika user menyimpan modifikasi data, update tampilan detail
              if (updatedData != null) {
                setState(() {
                  _currentNote = updatedData;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: Colors.redAccent),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _currentNote.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Text(
                  DateFormat('dd MMMM yyyy', 'id_ID').format(_currentNote.date),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _currentNote.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            Divider(
              height: 32,
              color: isDark ? Colors.white.withOpacity(0.1) : AppColors.border,
            ),
            Text(
              _currentNote.content,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: contentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
