import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quiz_master_app/app/data/repositories/assigned_exam_repository.dart';
import 'dart:io';

// For desktop sqlite support
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/core/config/supabase_config.dart';
import 'app/core/services/student_push_notifications_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/services/storage_service.dart';
import 'app/data/services/supabase_service.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.lazyPut<AssignedExamRepository>(
    () => AssignedExamRepository(),
    fenix: true,
  ); // Load environment variables
  await dotenv.load(fileName: '.env');


  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
    debug: SupabaseConfig.enableLogging,
  );

  // Initialize sqflite ffi on desktop platforms so `sqflite` works on Windows/macOS/Linux
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await GetStorage.init();

  Get.put<SupabaseService>(SupabaseService(), permanent: true);
  Get.put<StorageService>(StorageService(), permanent: true);
  Get.put<StudentPushNotificationsService>(
    StudentPushNotificationsService(),
    permanent: true,
  );
  await Get.find<StudentPushNotificationsService>().init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quiz Master',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
