import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/schedule_model.dart';

class ScheduleDetailScreen extends StatelessWidget {
  final ScheduleModel schedule;
  const ScheduleDetailScreen({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Jadwal'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(schedule.subject,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${schedule.timeStart} - ${schedule.timeEnd}',
                      style: const TextStyle(color: Colors.white70)),
                  Text(schedule.room,
                      style: const TextStyle(color: Colors.white70)),
                  const Divider(color: Colors.white30, height: 24),
                  const Text('Dosen Pengampu',
                      style: TextStyle(color: Colors.white60, fontSize: 12)),
                  Text(schedule.lecturer,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Deskripsi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(schedule.description,
                style: const TextStyle(
                    color: AppColors.textSecondary, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
