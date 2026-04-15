import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/services/local_storage_service.dart';
import 'app/core/services/firebase_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ─── Init GetStorage (replaces SharedPreferences) ─────────────────────────
  await GetStorage.init();

  // ─── System UI ────────────────────────────────────────────────────────────
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ─── Firebase (uncomment when firebase is configured) ─────────────────────
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ─── Permanent services ───────────────────────────────────────────────────
  Get.put(FirebaseService(), permanent: true);

  // ─── Apply saved theme ────────────────────────────────────────────────────
  AppTheme.themeMode = LocalStorage.isDarkMode()
      ? ThemeMode.dark
      : ThemeMode.light;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: AppTheme.themeMode,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.rightToLeft,
    );
  }
}
