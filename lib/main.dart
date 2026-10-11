import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- 1. WAJIB IMPORT INI
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/task_provider.dart';
import 'providers/note_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  // 2. Pastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Inisialisasi data format tanggal bahasa Indonesia sebelum runApp
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: const CampusPlanner(),
    ),
  );
}
