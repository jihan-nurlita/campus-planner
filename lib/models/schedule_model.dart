class ScheduleModel {
  final String id;
  final String subject;
  final String room;
  final String timeStart;
  final String timeEnd;
  final String day;
  final String lecturer;
  final String description;
  final bool isOngoing;

  ScheduleModel({
    required this.id,
    required this.subject,
    required this.room,
    required this.timeStart,
    required this.timeEnd,
    required this.day,
    required this.lecturer,
    required this.description,
    this.isOngoing = false,
  });

  // 1. Konversi ke JSON (Map) untuk disimpan
  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'room': room,
        'timeStart': timeStart,
        'timeEnd': timeEnd,
        'day': day,
        'lecturer': lecturer,
        'description': description,
        'isOngoing': isOngoing,
      };

  // 2. Membaca kembali dari JSON (Map)
  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        id: json['id'],
        subject: json['subject'],
        room: json['room'],
        timeStart: json['timeStart'],
        timeEnd: json['timeEnd'],
        day: json['day'],
        lecturer: json['lecturer'],
        description: json['description'],
        isOngoing: json['isOngoing'] ?? false,
      );
}
