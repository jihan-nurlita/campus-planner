import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/note_model.dart';
import '../../providers/note_provider.dart';
import '../../providers/theme_provider.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel note;
  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _selectedCategory;
  final List<String> _categories = ['Tugas', 'Materi', 'Ujian', 'Praktikum'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    _selectedCategory = _categories.contains(widget.note.category)
        ? widget.note.category
        : 'Tugas';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updateNote() {
    if (_formKey.currentState!.validate()) {
      final updatedNote = NoteModel(
        id: widget.note.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: _selectedCategory,
        date: DateTime.now(), // Perbarui tanggal edit ke waktu sekarang
      );

      Provider.of<NoteProvider>(context, listen: false).updateNote(updatedNote);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil diperbarui!'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(
          context, updatedNote); // Kirim data baru kembali ke halaman detail
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          'Edit Catatan',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded,
                color: AppColors.primary, size: 28),
            onPressed: _updateNote,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Text(
              'Kategori Catatan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white60 : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : AppColors.border,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  dropdownColor:
                      isDark ? AppColors.darkSurface : AppColors.surface,
                  icon: const Icon(Icons.arrow_drop_down_rounded,
                      color: AppColors.primary, size: 30),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category,
                          style: TextStyle(color: textColor, fontSize: 15)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              validator: (value) => value == null || value.isEmpty
                  ? 'Judul tidak boleh kosong'
                  : null,
              decoration: InputDecoration(
                hintText: 'Judul Catatan',
                hintStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary),
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.surface,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              maxLines: 12,
              style: TextStyle(fontSize: 15, color: textColor, height: 1.4),
              validator: (value) => value == null || value.isEmpty
                  ? 'Isi catatan tidak boleh kosong'
                  : null,
              decoration: InputDecoration(
                hintText: 'Ketik materi atau catatan kuliahmu di sini...',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.surface,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
