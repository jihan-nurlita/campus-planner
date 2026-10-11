import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/theme_provider.dart';
import 'add_schedule_screen.dart';
import 'edit_schedule_screen.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // listen: true memastikan halaman langsung merespons perubahan tema atau data jadwal
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final scheduleProvider = Provider.of<ScheduleProvider>(context);

    // Pemetaan string hari pendek yang sinkron dengan data di ScheduleProvider
    final List<String> daysMapping = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum'];
    final List<String> fullDaysName = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat'
    ];

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Jadwal Kuliah',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true, // Gunakan boolean true di sini
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelColor:
                isDark ? Colors.white38 : AppColors.textSecondary,
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            tabs: fullDaysName.map((day) => Tab(text: day)).toList(),
          ),
        ),
        body: TabBarView(
          children: List.generate(5, (index) {
            final currentDayString = daysMapping[index];

            // Menyaring data jadwal secara riil dari provider berdasarkan tab hari aktif
            final schedules = scheduleProvider.schedules
                .where((s) =>
                    s.day.trim().toLowerCase() ==
                    currentDayString.toLowerCase())
                .toList();

            // Tampilan jika jadwal kosong pada hari tersebut
            if (schedules.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 64,
                      color: isDark ? Colors.white24 : Colors.black12,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tidak ada jadwal kuliah hari ${fullDaysName[index]}.',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              // Menambahkan padding bottom ekstra (80) agar item terakhir tidak tertutup FAB
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 20, bottom: 80),
              itemCount: schedules.length,
              itemBuilder: (context, i) {
                final schedule = schedules[i];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  elevation: 0,
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditScheduleScreen(schedule: schedule),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Kontainer Ikon Mata Kuliah
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Detail Informasi Jadwal Riil
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  schedule.subject,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.room_outlined,
                                      size: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      schedule.room,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      ' | ',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.person_outline_rounded,
                                      size: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        schedule.lecturer,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Waktu Perkuliahan Riil
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                schedule.timeStart,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: schedule.isOngoing
                                      ? Colors.green
                                      : AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                schedule.timeEnd,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 2,
          backgroundColor: AppColors.primary,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddScheduleScreen()),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
