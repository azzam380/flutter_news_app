import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:news_app/bindings/app_bindings.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'News App',

      // --- Light Theme (Sesuai dengan desain Putih-Biru) ---
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          surface: AppColors.surface,
          background: AppColors.background,
          onSurface: AppColors.onSurface,
          onBackground: AppColors.onBackground,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface, // AppBar Putih
          foregroundColor: AppColors.onSurface, // Ikon/Teks Primary
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.onSurface),
          bodyMedium: TextStyle(color: AppColors.onSurface),
          titleMedium: TextStyle(color: AppColors.onSurfaceVariant),
        ),
      ),
      
      // darkTheme: Dihilangkan untuk menstabilkan aplikasi
      // themeMode: Dihilangkan

      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
    );
  }
}