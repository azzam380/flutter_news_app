import 'package:flutter/material.dart';

class AppColors {
  // Warna Dasar
  static const Color primaryBlue = Color(0xFF1E88E5); // Biru yang cerah
  static const Color secondaryBlue = Color(0xFF42A5F5); // Biru yang lebih terang

  // Gradient untuk background / elemen utama
  static const Gradient blueGradient = LinearGradient(
    colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)], // Biru Muda ke Putih Biru
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)], // Biru Cerah ke Biru Terang
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // M3 Roles Mapping with new aesthetic
  static const Color primary = primaryBlue;
  static const Color onPrimary = Colors.white;
  static const Color primaryContainer = Color(0xFF90CAF9); // Light Blue
  static const Color onPrimaryContainer = Color(0xFF0D47A1);

  static const Color secondary = Color(0xFF64B5F6);
  static const Color onSecondary = Colors.white;
  static const Color secondaryContainer = Color(0xFFE3F2FD);
  static const Color onSecondaryContainer = Color(0xFF1976D2);

  // Surface and Background - Fokus pada Putih Cerah
  static const Color surface = Colors.white; // Latar belakang kartu/dialog
  static const Color onSurface = Color(0xFF1A1C1E); // Teks utama (Hitam gelap)
  static const Color surfaceVariant = Color(0xFFF0F4F8); // Latar belakang chip/shimmer (Abu Muda)
  static const Color onSurfaceVariant = Color(0xFF5A5A5A); // Teks sekunder (Abu)

  static const Color background = Color(0xFFF7F9FC); // Latar belakang utama Scaffold
  static const Color onBackground = onSurface; // Teks utama di background

  static const Color error = Color(0xFFB71C1C);
  static const Color onError = Colors.white;

  // Utilities
  static const Color textPrimary = onSurface;
  static const Color textSecondary = onSurfaceVariant;
  static const Color textHint = onSurfaceVariant;
  static const Color divider = surfaceVariant;
  static const Color cardShadow = Color(0x20000000); // Shadow sedikit lebih kuat
}