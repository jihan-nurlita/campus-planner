import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/task_provider.dart';
import '../../providers/theme_provider.dart';

// Asumsikan ini adalah struktur model Task Anda, sesuaikan jika ada perbedaan field
// import '../../models/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  final dynamic
      task; // Ganti 'dynamic' dengan kelas model Anda, contoh: 'Task task'

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // Mengisi data awal sesuai dengan data tugas yang akan diedit
    _titleController = TextEditingController(text: widget.task.title);
    _selectedDate = widget.task.deadline;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Fungsi untuk memunculkan kalender / Date Picker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        final isDark =
            Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
        return Theme(
          data: isDark ? ThemeData.dark() : ThemeData.light(),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Fungsi untuk menyimpan perubahan data ke Provider
  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      // Memanggil fungsi updateTask dari Provider Anda
      taskProvider.updateTask(
        id: widget.task.id,
        title: _titleController.text.trim(),
        deadline: _selectedDate,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perubahan tugas berhasil disimpan!')),
      );
      Navigator.pop(context);
    }
  }

  // Fungsi opsi hapus dari tombol sampah di pojok kanan atas
  void _deleteTask() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content:
            const Text('Apakah Anda yakin ingin menghapus tugas kuliah ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(widget.task.id);
              Navigator.pop(ctx); // Tutup dialog
              Navigator.pop(context); // Kembali ke halaman utama tugas
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tugas berhasil dihapus')),
              );
            },
            child:
                const Text('Hapus', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Tugas',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            onPressed: _deleteTask,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detail Tugas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Input Judul Tugas
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Tugas / Mata Kuliah',
                  hintText: 'Contoh: Projek Akhir Praktikum Pemrograman',
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.assignment_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tugas tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Pemilih Tanggal Batas Waktu (Deadline)
              Text(
                'Batas Waktu (Deadline)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _pickDate(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.transparent : AppColors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_drop_down,
                          color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Tombol Simpan Perubahan
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
