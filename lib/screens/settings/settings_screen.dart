import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Akun',
              style: TextStyle(
                  color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          const ListTile(
            title: Text('Edit Profil'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            title: Text('Ganti Password'),
            trailing: Icon(Icons.chevron_right),
          ),
          const SizedBox(height: 16),
          const Text('Aplikasi',
              style: TextStyle(
                  color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('Tema Gelap / Dark Mode'),
            value: themeProvider.isDarkMode,
            activeColor: AppColors.primary,
            onChanged: (bool value) {
              themeProvider.toggleTheme();
            },
          ),
          const ListTile(
            title: Text('Bahasa'),
            trailing: Text('Bahasa Indonesia',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          const SizedBox(height: 16),
          const Text('Tentang',
              style: TextStyle(
                  color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          const ListTile(
            title: Text('Tentang Aplikasi'),
            trailing: Text('v1.0.0',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
