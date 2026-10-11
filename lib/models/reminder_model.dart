class ReminderModel {
  bool jadwalKuliah;
  bool deadlineTugas;
  bool pengingatBelajar;
  bool weekendReminder;

  ReminderModel({
    this.jadwalKuliah = true,
    this.deadlineTugas = true,
    this.pengingatBelajar = true,
    this.weekendReminder = false,
  });

  // Konversi ke JSON untuk SharedPreferences
  Map<String, dynamic> toJson() => {
        'jadwalKuliah': jadwalKuliah,
        'deadlineTugas': deadlineTugas,
        'pengingatBelajar': pengingatBelajar,
        'weekendReminder': weekendReminder,
      };

  // Baca dari JSON
  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
        jadwalKuliah: json['jadwalKuliah'] ?? true,
        deadlineTugas: json['deadlineTugas'] ?? true,
        pengingatBelajar: json['pengingatBelajar'] ?? true,
        weekendReminder: json['weekendReminder'] ?? false,
      );
}
