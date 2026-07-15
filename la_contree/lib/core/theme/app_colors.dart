import 'package:flutter/material.dart';

class AppColors {
  // PRIMARY - Bleu Océan
  static const Color primary = Color(0xFF0B5A8C);
  static const Color primaryLight = Color(0xFF2A7AB0);
  static const Color primaryDark = Color(0xFF08406A);

  // SECONDARY - Terre Cuite / Latérite
  static const Color secondary = Color(0xFFD95438);
  static const Color secondaryLight = Color(0xFFE67A62);
  static const Color secondaryDark = Color(0xFFB8432A);

  // ACCENT - Or Sablonneux
  static const Color accent = Color(0xFFF2C14E);
  static const Color accentLight = Color(0xFFFCD98E);
  static const Color accentDark = Color(0xFFDBA832);

  // BACKGROUND - Blanc Cassé / Sable clair (clair) / Bleu-noir (sombre)
  static const Color background = Color(0xFFFDFBF7);
  static const Color backgroundDark = Color(0xFF0A1118);

  // SURFACE - Blanc Pur (clair) / Gris foncé (sombre)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A2530);

  // TEXT - Anthracite (clair) / Blanc cassé (sombre)
  static const Color textPrimary = Color(0xFF1A2530);
  static const Color textPrimaryDark = Color(0xFFF5F0E8);
  
  static const Color textSecondary = Color(0xFF5A6A7A);
  static const Color textSecondaryDark = Color(0xFF9AABBA);
  
  static const Color textLight = Color(0xFF9AABBA);
  static const Color textLightDark = Color(0xFF5A6A7A);

  // FEEDBACK
  static const Color success = Color(0xFF27AE60);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);

  // GRADIENTS
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B5A8C), Color(0xFF2A7AB0)],
  );
}