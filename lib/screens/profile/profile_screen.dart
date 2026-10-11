import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../reminder/reminder_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final authProvider = Provider.of<AuthProvider>(context);

    // ================= LOGIKA AMAN SINKRONISASI INISIAL NAMA =================
    // Fungsi ini memotong nama asli dari AuthProvider menjadi max 2 huruf depan inisial.
    // Contoh: "Ahmad Fauzi" -> "AF", "Fikri" -> "F", "Budi Santoso Putra" -> "BS"
    String getInitialName(String fullName) {
      final trimmed = fullName.trim();
      if (trimmed.isEmpty) return 'U'; // Default jika kosong

      final words = trimmed.split(
          RegExp(r'\s+')); // Pisahkan berdasarkan spasi berapapun jumlahnya
      if (words.length > 1) {
        // Ambil huruf pertama dari kata pertama dan kata kedua
        return (words[0][0] + words[1][0]).toUpperCase();
      }
      // Jika hanya satu kata, ambil satu huruf pertama saja
      return words[0][0].toUpperCase();
    }

    final String initialName = getInitialName(authProvider.userName);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // ================= INFO MAHASISWA CARD (SINKRON REAL DATA) =================
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.transparent
                      : Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
              border: Border.all(
                color:
                    isDark ? Colors.white.withOpacity(0.05) : AppColors.border,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Lingkaran Avatar dengan Inisial Dinamis Hasil Sinkronisasi
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: Text(
                    initialName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Menampilkan Nama Asli yang diinput saat registrasi/login
                      Text(
                        authProvider.userName.isNotEmpty
                            ? authProvider.userName
                            : 'Mahasiswa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Menampilkan Email Asli dari AuthProvider
                      Text(
                        authProvider.userEmail.isNotEmpty
                            ? authProvider.userEmail
                            : 'email@mahasiswa.ac.id',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ================= MENU GROUP: PENGATURAN APLIKASI =================
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'Pengaturan Aplikasi',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white54 : AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isDark ? Colors.white.withOpacity(0.05) : AppColors.border,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildMenuTile(
                  context,
                  icon: isDark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  title: isDark ? 'Mode Terang' : 'Mode Gelap',
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                      height: 1,
                      color: isDark ? Colors.white10 : AppColors.border),
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.notifications_none_rounded,
                  title: 'Pengaturan Pengingat',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReminderScreen()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                      height: 1,
                      color: isDark ? Colors.white10 : AppColors.border),
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.verified_user_outlined,
                  title: 'Kebijakan Privasi',
                  onTap: () {
                    // Logika Kebijakan Privasi
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                      height: 1,
                      color: isDark ? Colors.white10 : AppColors.border),
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: 'Bantuan & Dukungan',
                  onTap: () {
                    // Bisa diisi navigasi ke halaman bantuan
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                      height: 1,
                      color: isDark ? Colors.white10 : AppColors.border),
                ),
                _buildMenuTile(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: 'Tentang Aplikasi',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Campus Planner',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2026 Campus Planner Inc.',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ================= MENU GROUP: TOMBOL KELUAR =================
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isDark ? Colors.white.withOpacity(0.05) : AppColors.border,
                width: 1,
              ),
            ),
            child: _buildMenuTile(
              context,
              icon: Icons.logout_rounded,
              title: 'Keluar Akun',
              color: AppColors.danger,
              onTap: () => _showLogoutDialog(context, authProvider),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color != null
              ? color.withOpacity(0.1)
              : (isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.02)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 22,
          color: color ?? (isDark ? Colors.white : Colors.black87),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? (isDark ? Colors.white : Colors.black87),
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: color != null ? color.withOpacity(0.5) : AppColors.textSecondary,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Keluar Akun',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
              'Apakah Anda yakin ingin keluar dari aplikasi Jadwal Kuliah?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: TextStyle(
                    color: isDark ? Colors.white60 : AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context); // Tutup Dialog
                authProvider
                    .logout(); // Bersihkan data di AuthProvider secara utuh
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Keluar',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
