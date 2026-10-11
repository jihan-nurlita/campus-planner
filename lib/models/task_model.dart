class TaskModel {
  final String id;
  final String title;
  final String subject;
  final DateTime deadline;
  final String description;
  final String priority; // Rendah, Sedang, Tinggi
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.deadline,
    required this.description,
    required this.priority,
    this.isCompleted = false,
  });

  int get daysLeft {
    final now = DateTime.now();
    final difference =
        deadline.difference(DateTime(now.year, now.month, now.day)).inDays;
    return difference;
  }

  // 1. Konversi objek TaskModel ke bentuk JSON (Map)
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subject': subject,
        'deadline': deadline.toIso8601String(),
        'description': description,
        'priority': priority,
        'isCompleted': isCompleted,
      };

  // 2. Membuat objek TaskModel kembali dari data JSON (Map)
  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        title: json['title'],
        subject: json['subject'],
        deadline: DateTime.parse(json['deadline']),
        description: json['description'],
        priority: json['priority'],
        isCompleted: json['isCompleted'] ?? false,
      );
}
