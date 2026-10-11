import 'package:campus_planner/screens/notification/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/note_provider.dart';
import '../../providers/theme_provider.dart';
import '../note/note_detail_screen.dart';
import '../note/add_note_screen.dart'; // Sesuaikan path jika ada halaman tambah catatan
import '../schedule/schedule_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final authProvider = Provider.of<AuthProvider>(context);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final noteProvider = Provider.of<NoteProvider>(context);

    final todayClasses = scheduleProvider.todaySchedules;
    final allNotes = noteProvider.notes;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Campus Planner',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const NotificationScreen()), // Ganti dengan nama layar kamu
              );
            },
          ),
          // IconButton(
          //   icon: Icon(
          //       isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
          //   onPressed: () => Provider.of<ThemeProvider>(context, listen: false)
          //       .toggleTheme(),
          // ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: [
          // Banner Selamat Datang dengan Gradient Modern
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xff1d4ed8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${authProvider.userName}Mahasiswa',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Siap untuk menyelesaikan target kuliahmu hari ini?',
                  style:
                      TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Header Kelas Hari Ini
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kelas Hari Ini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScheduleScreen()),
                ),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // List Kelas Hari Ini
          todayClasses.isEmpty
              ? Card(
                  elevation: 0,
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                        color: isDark ? Colors.transparent : AppColors.border),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                    child: Center(
                      child: Text(
                        'Tidak ada jadwal kuliah hari ini.',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todayClasses.length,
                  itemBuilder: (context, index) {
                    final item = todayClasses[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 0,
                      color: isDark ? AppColors.darkSurface : AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : AppColors.border),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.menu_book_rounded,
                                  color: AppColors.primary, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.subject,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.room,
                                    style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${item.timeStart} - ${item.timeEnd}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

          const SizedBox(height: 24),

          // Header Catatan Kuliah
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Catatan Kuliah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded,
                    color: AppColors.primary),
                onPressed: () {
                  // Aksi navigasi ke halaman tambah catatan baru
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => const AddNoteScreen()));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddNoteScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Grid Catatan Materi
          allNotes.isEmpty
              ? Card(
                  elevation: 0,
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                        color: isDark ? Colors.transparent : AppColors.border),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 35, horizontal: 16),
                    child: Center(
                      child: Text(
                        'Belum ada catatan kuliah dibuat.',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.15,
                  ),
                  itemCount: allNotes.length,
                  itemBuilder: (context, index) {
                    final note = allNotes[index];
                    return Card(
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      color: isDark ? AppColors.darkSurface : AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : AppColors.border),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => NoteDetailScreen(note: note)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  note.category.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                note.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: Text(
                                  note.content,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
