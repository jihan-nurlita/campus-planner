import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tugas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)),
              child: Text('${task.daysLeft} hari lagi',
                  style: const TextStyle(
                      color: AppColors.danger, fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 32),
            ListTile(
              leading: const Icon(Icons.book, color: AppColors.primary),
              title: const Text('Mata Kuliah'),
              subtitle: Text(task.subject),
            ),
            ListTile(
              leading: const Icon(Icons.outlined_flag, color: AppColors.danger),
              title: const Text('Prioritas'),
              subtitle: Text(task.priority),
            ),
            const SizedBox(height: 16),
            const Text('Deskripsi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(task.description,
                style: const TextStyle(
                    color: AppColors.textSecondary, height: 1.5)),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger),
                    onPressed: () {
                      Provider.of<TaskProvider>(context, listen: false)
                          .deleteTask(task.id);
                      Navigator.pop(context);
                    },
                    child: const Text('Hapus',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
