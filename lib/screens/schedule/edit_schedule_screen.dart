import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/schedule_model.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/theme_provider.dart';

class EditScheduleScreen extends StatefulWidget {
  final ScheduleModel schedule;
  const EditScheduleScreen({super.key, required this.schedule});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _subjectController;
  late TextEditingController _roomController;
  late TextEditingController _lecturerController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _descriptionController; // Controller tambahan

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: widget.schedule.subject);
    _roomController = TextEditingController(text: widget.schedule.room);
    _lecturerController = TextEditingController(text: widget.schedule.lecturer);
    _startTimeController =
        TextEditingController(text: widget.schedule.timeStart);
    _endTimeController = TextEditingController(text: widget.schedule.timeEnd);
    _descriptionController =
        TextEditingController(text: widget.schedule.description);
  }

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
        controller.text = picked.format(context);
      });
    }
  }

  void _updateSchedule() {
    if (_formKey.currentState!.validate()) {
      final scheduleProvider =
          Provider.of<ScheduleProvider>(context, listen: false);

      final updatedSchedule = ScheduleModel(
        id: widget.schedule.id,
        subject: _subjectController.text.trim(),
        room: _roomController.text.trim(),
        lecturer: _lecturerController.text.trim(),
        timeStart: _startTimeController.text.trim(),
        timeEnd: _endTimeController.text.trim(),
        day: widget.schedule.day,
        description: _descriptionController.text.trim(), // SINKRON DENGAN MODEL
        isOngoing: widget.schedule.isOngoing,
      );

      scheduleProvider.updateSchedule(updatedSchedule);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Jadwal berhasil diperbarui!'),
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
        title: const Text('Edit Jadwal',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true, // Gunakan boolean true di sini
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            onPressed: () {
              Provider.of<ScheduleProvider>(context, listen: false)
                  .deleteSchedule(widget.schedule.id);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            _buildTextField('Mata Kuliah', _subjectController, isDark),
            const SizedBox(height: 16),
            _buildTextField('Ruangan', _roomController, isDark),
            const SizedBox(height: 16),
            _buildTextField('Dosen Pengampu', _lecturerController, isDark),
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
                maxLines: 3),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _updateSchedule,
              child: const Text('Perbarui Jadwal',
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
      String label, TextEditingController controller, bool isDark,
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
          validator: (value) => value == null || value.isEmpty
              ? '$label tidak boleh kosong'
              : null,
          decoration: InputDecoration(
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
          onTap: () => _selectTime(context, controller),
          validator: (value) =>
              value == null || value.isEmpty ? 'Wajib diisi' : null,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.access_time),
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
