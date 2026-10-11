import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/theme_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _focusedDate = DateTime.now();
    _selectedDate = DateTime.now();
  }

  void _changeMonth(int increment) {
    setState(() {
      _focusedDate =
          DateTime(_focusedDate.year, _focusedDate.month + increment, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    final selectedDateClasses =
        scheduleProvider.getSchedulesByDate(_selectedDate);

    final List<String> daysName = [
      'Sen',
      'Sel',
      'Rab',
      'Kam',
      'Jum',
      'Sab',
      'Min'
    ];

    final int year = _focusedDate.year;
    final int month = _focusedDate.month;

    final int totalDaysInMonth = DateTime(year, month + 1, 0).day;
    final int firstDayOfWeek = DateTime(year, month, 1).weekday;
    final int prefixEmptySpaces = firstDayOfWeek - 1;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Kalender Akademik',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : AppColors.border.withOpacity(0.5),
              ),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  )
              ],
            ),
            child: Column(
              children: [
                // Navigasi Bulan & Tahun
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy', 'id_ID').format(_focusedDate),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.chevron_left,
                                color: AppColors.primary, size: 22),
                            onPressed: () => _changeMonth(-1),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.chevron_right,
                                color: AppColors.primary, size: 22),
                            onPressed: () => _changeMonth(1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Nama-Nama Hari
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: daysName.map((day) {
                      final isSunday = day == 'Min';
                      return SizedBox(
                        width: 36,
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSunday
                                ? Colors.redAccent
                                : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),

                // Grid Susunan Tanggal dengan Dot Penanda
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                    ),
                    itemCount: totalDaysInMonth + prefixEmptySpaces,
                    itemBuilder: (context, index) {
                      if (index < prefixEmptySpaces) {
                        return const SizedBox();
                      }

                      final dayNum = index - prefixEmptySpaces + 1;
                      final currentCellDate = DateTime(year, month, dayNum);

                      final isSelected =
                          currentCellDate.year == _selectedDate.year &&
                              currentCellDate.month == _selectedDate.month &&
                              currentCellDate.day == _selectedDate.day;

                      final isSunday = currentCellDate.weekday == 7;

                      // Cek apakah tanggal ini memiliki jadwal/agenda riil
                      final hasSchedule = scheduleProvider
                          .getSchedulesByDate(currentCellDate)
                          .isNotEmpty;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = currentCellDate;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$dayNum',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : (isSunday
                                          ? Colors.redAccent
                                          : (isDark
                                              ? Colors.white
                                              : Colors.black)),
                                ),
                              ),
                              const SizedBox(height: 2),
                              // Dot kecil penanda jadwal
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: hasSchedule
                                      ? (isSelected
                                          ? Colors.white
                                          : AppColors.primary)
                                      : Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Header Keterangan Agenda Bawah
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'Agenda • ${DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // List Hasil Penyaringan Jadwal Riil
          Expanded(
            child: selectedDateClasses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy_rounded,
                            size: 44,
                            color: AppColors.textSecondary.withOpacity(0.3)),
                        const SizedBox(height: 8),
                        Text(
                          'Tidak ada kelas atau agenda kuliah',
                          style: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.7),
                              fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    itemCount: selectedDateClasses.length,
                    itemBuilder: (context, index) {
                      final item = selectedDateClasses[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.03)
                                : AppColors.border.withOpacity(0.4),
                          ),
                          boxShadow: [
                            if (!isDark)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.015),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 38,
                              decoration: BoxDecoration(
                                color: item.isOngoing
                                    ? Colors.green
                                    : AppColors.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
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
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${item.room} • ${item.lecturer.split(',')[0]}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${item.timeStart}\n${item.timeEnd}',
                              style: TextStyle(
                                color: item.isOngoing
                                    ? Colors.green
                                    : AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
