import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/schedule_model.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/theme_provider.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _roomController = TextEditingController();
  final _lecturerController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _descriptionController = TextEditingController();

  // 1. Variabel baru untuk menampung hari pilihan (default: Sen)
  String _selectedDay = 'Sen';

  // Mapping untuk kebutuhan tampilan Dropdown
  final List<Map<String, String>> _dayOptions = [
    {'value': 'Sen', 'label': 'Senin'},
    {'value': 'Sel', 'label': 'Selasa'},
    {'value': 'Rab', 'label': 'Rabu'},
    {'value': 'Kam', 'label': 'Kamis'},
    {'value': 'Jum', 'label': 'Jumat'},
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _roomController.dispose();
    _lecturerController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        // Format manual ke 24 jam dengan pemisah titik (.) agar sesuai dengan tampilan lain
        final hours = picked.hour.toString().padLeft(2, '0');
        final minutes = picked.minute.toString().padLeft(2, '0');
        controller.text = '$hours.$minutes';
      });
    }
  }

  /// Jam

  // Future<void> _selectTime(
  //     BuildContext context, TextEditingController controller) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked != null && mounted) {
  //     setState(() {
  //       controller.text = picked.format(context);
  //     });
  //   }
  // }

  void _saveSchedule() {
    if (_formKey.currentState!.validate()) {
      final scheduleProvider =
          Provider.of<ScheduleProvider>(context, listen: false);

      final newSchedule = ScheduleModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subject: _subjectController.text.trim(),
        room: _roomController.text.trim(),
        lecturer: _lecturerController.text.trim(),
        timeStart: _startTimeController.text.trim(),
        timeEnd: _endTimeController.text.trim(),
        day: _selectedDay, // 2. SEKARANG SUDAH DINAMIS SESUAI PILIHAN
        description: _descriptionController.text.trim(),
        isOngoing: false,
      );

      scheduleProvider.addSchedule(newSchedule);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Jadwal berhasil ditambahkan!'),
            backgroundColor: AppColors.primary),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('Tambah Jadwal',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true, // Gunakan boolean true di sini
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // 3. MENAMBAHKAN WIDGET DROPDOWN SEBELUM MATA KULIAH
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hari Kuliah',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedDay,
                  dropdownColor:
                      isDark ? AppColors.darkSurface : AppColors.surface,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        isDark ? AppColors.darkSurface : AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: isDark
                          ? BorderSide.none
                          : const BorderSide(color: AppColors.border),
                    ),
                  ),
                  items: _dayOptions.map((day) {
                    return DropdownMenuItem<String>(
                      value: day['value'],
                      child: Text(day['label']!,
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDay = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
                'Mata Kuliah', _subjectController, isDark, 'Nama mata kuliah'),
            const SizedBox(height: 16),
            _buildTextField('Ruangan', _roomController, isDark,
                'Contoh: Lab ICT / Gedung D.302'),
            const SizedBox(height: 16),
            _buildTextField(
                'Dosen Pengampu', _lecturerController, isDark, 'Nama dosen'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTimeField(
                      'Jam Mulai', _startTimeController, isDark),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeField(
                      'Jam Selesai', _endTimeController, isDark),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField('Deskripsi Kuliah', _descriptionController, isDark,
                'Catatan tambahan kelas',
                maxLines: 3),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _saveSchedule,
              child: const Text('Simpan Jadwal',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool isDark, String hint,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          validator: (value) => value == null || value.isEmpty
              ? '$label tidak boleh kosong'
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: isDark ? AppColors.darkSurface : AppColors.surface,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: isDark
                    ? BorderSide.none
                    : const BorderSide(color: AppColors.border)),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(
      String label, TextEditingController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          onTap: () => _selectTime(context, controller),
          validator: (value) =>
              value == null || value.isEmpty ? 'Wajib diisi' : null,
          decoration: InputDecoration(
            hintText: '00:00',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            suffixIcon:
                const Icon(Icons.access_time, color: AppColors.textSecondary),
            filled: true,
            fillColor: isDark ? AppColors.darkSurface : AppColors.surface,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: isDark
                    ? BorderSide.none
                    : const BorderSide(color: AppColors.border)),
          ),
        ),
      ],
    );
  }
}
