import 'package:flutter/material.dart';

class AppColors {
  // Google Material 3 - Blue Theme
  static const Color primary = Color(0xFF0B57D0); // Google Blue
  static const Color onPrimary = Colors.white;
  static const Color primaryContainer = Color(0xFFD3E3FF);
  static const Color onPrimaryContainer = Color(0xFF001B3E);

  static const Color secondary = Color(0xFF535F70); // Neutral accent
  static const Color onSecondary = Colors.white;
  static const Color secondaryContainer = Color(0xFFD7E3F8);
  static const Color onSecondaryContainer = Color(0xFF101C2B);

  static const Color surface = Color(0xFFF7F9FC); // Latar belakang kartu/dialog
  static const Color onSurface = Color(0xFF1A1C1E); // Teks utama
  static const Color surfaceVariant = Color(0xFFE0E2EC); // Latar belakang chip/shimmer
  static const Color onSurfaceVariant = Color(0xFF42474E); // Teks sekunder

  static const Color background = Color(0xFFF7F9FC); // Latar belakang utama Scaffold
  static const Color onBackground = Color(0xFF1A1C1E); // Teks utama di background

  static const Color error = Color(0xFFB3261E);
  static const Color onError = Colors.white;
  
  // --- Mapping Warna Lama (untuk kompatibilitas) ---
  
  // Original names (mapped to new M3 roles)
  static const Color textPrimary = onSurface;
  static const Color textSecondary = onSurfaceVariant;
  static const Color textHint = onSurfaceVariant;
  static const Color divider = surfaceVariant;
  
  // Shadow tetap sama, sudah cukup modern
  static const Color cardShadow = Color(0x1A000000); 
}