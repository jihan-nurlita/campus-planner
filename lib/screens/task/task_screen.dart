import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/task_provider.dart';
import '../../providers/theme_provider.dart';
import 'add_task_screen.dart'; // Pastikan path ini benar atau sesuaikan
import 'edit_task_screen.dart'; // Pastikan path ini benar atau sesuaikan

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('Tugas Kuliah',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      ),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 64,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada tugas terkumpul.',
                    style:
                        TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                // Menggunakan Dismissible agar item tugas bisa dihapus dengan cara digeser (swipe ke kiri)
                return Dismissible(
                  key: Key(task.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    child:
                        const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    taskProvider.deleteTask(task
                        .id); // Pastikan fungsi deleteTask ada di Provider Anda
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tugas "${task.title}" dihapus')),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.transparent : AppColors.border,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      // Klik area kartu untuk mengedit data tugas
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTaskScreen(task: task),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: task.isCompleted,
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            taskProvider.toggleTaskStatus(task.id);
                          },
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: task.isCompleted
                                  ? (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary)
                                  : (isDark ? Colors.white : Colors.black),
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined,
                                    size: 14, color: AppColors.danger),
                                const SizedBox(width: 6),
                                Text(
                                  'Deadline: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
                                  style: const TextStyle(
                                    color: AppColors.danger,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      // TOMBOL TAMBAH JADWAL TUGAS BARU
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTaskScreen()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
