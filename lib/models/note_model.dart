class NoteModel {
  final String id;
  final String title;
  final String content;
  final String category; // Semua, Matakuliah, Pribadi
  final DateTime date;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
  });

  // Konversi objek NoteModel ke Map (JSON)
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'category': category,
        'date': date.toIso8601String(),
      };

  // Membuat objek NoteModel kembali dari Map (JSON)
  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        category: json['category'],
        date: DateTime.parse(json['date']),
      );
}
