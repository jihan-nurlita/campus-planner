import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/theme_provider.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool _jadwalKuliah = true;
  bool _deadlineTugas = true;
  bool _pengingatBelajar = true;
  bool _weekendReminder = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengingat',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true, // Gunakan boolean true di sini
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Aktif',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary),
            ),
          ),
          _buildSwitchTile(
            title: 'Jadwal Kuliah',
            subtitle: '15 menit sebelum kelas dimulai',
            value: _jadwalKuliah,
            onChanged: (val) => setState(() => _jadwalKuliah = val),
          ),
          _buildSwitchTile(
            title: 'Deadline Tugas',
            subtitle: '1 hari sebelum sebelum deadline kumpul',
            value: _deadlineTugas,
            onChanged: (val) => setState(() => _deadlineTugas = val),
          ),
          _buildSwitchTile(
            title: 'Pengingat Belajar',
            subtitle: 'Setiap hari, pukul 19.00 WIB',
            value: _pengingatBelajar,
            onChanged: (val) => setState(() => _pengingatBelajar = val),
          ),
          _buildSwitchTile(
            title: 'Weekend Reminder',
            subtitle: 'Setiap Sabtu, pukul 09.00 WIB',
            value: _weekendReminder,
            onChanged: (val) => setState(() => _weekendReminder = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle,
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        value: value,
        activeColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}
