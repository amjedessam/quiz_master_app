import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5548E8);
  static const Color primaryLight = Color(0xFF8F88FF);

  static const Color accent = Color(0xFF00D9FF);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFFF5252);
  static const Color info = Color(0xFF2196F3);

  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color scaffoldBg = Color(0xFFF5F7FA);

  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF9FA5C0);
  static const Color textHint = Color(0xFFBFC5D9);
  static const Color textWhite = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFE8EBF2);
  static const Color divider = Color(0xFFE8EBF2);

  static const Color easyColor = Color(0xFF4CAF50);
  static const Color mediumColor = Color(0xFFFF9800);
  static const Color hardColor = Color(0xFFFF5252);

  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
