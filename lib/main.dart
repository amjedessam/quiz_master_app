// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// import 'app/core/theme/app_theme.dart';
// import 'app/routes/app_pages.dart';
// import 'app/routes/app_routes.dart';
// import 'app/data/services/storage_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await GetStorage.init();

//   // ⬅️ هذا هو السطر الذي يحل المشكلة: تسجيل الخدمة بشكل غير متزامن
//   await Get.putAsync(() => StorageService().init());

//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//     ),
//   );

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Quiz Master',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       locale: const Locale('ar', 'SA'),
//       fallbackLocale: const Locale('en', 'US'),
//       initialRoute: AppRoutes.SPLASH,
//       getPages: AppPages.pages,
//       defaultTransition: Transition.cupertino,
//       transitionDuration: const Duration(milliseconds: 300),
//     );
//   }
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

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
