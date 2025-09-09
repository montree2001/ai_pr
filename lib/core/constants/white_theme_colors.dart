import 'package:flutter/material.dart';

class WhiteThemeColors {
  // Primary white theme colors
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color softWhite = Color(0xFFFAFAFA);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFFE8E8E8);
  static const Color borderGray = Color(0xFFE0E0E0);
  
  // Accent colors - soft and elegant
  static const Color softBlue = Color(0xFF4A90E2);
  static const Color lightBlue = Color(0xFF7BB3F0);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1976D2);
  
  // Text colors
  static const Color primaryText = Color(0xFF2C3E50);
  static const Color secondaryText = Color(0xFF6C7B7F);
  static const Color lightText = Color(0xFF95A5A6);
  static const Color hintText = Color(0xFFBDC3C7);
  
  // Status colors
  static const Color successGreen = Color(0xFF27AE60);
  static const Color warningOrange = Color(0xFFF39C12);
  static const Color errorRed = Color(0xFFE74C3C);
  
  // Shadow colors
  static const Color lightShadow = Color(0x10000000);
  static const Color mediumShadow = Color(0x20000000);
  static const Color darkShadow = Color(0x30000000);
  
  // Gradients
  static const LinearGradient whiteGradient = LinearGradient(
    colors: [pureWhite, softWhite],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    colors: [lightBlue, softBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient subtleGradient = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8F9FA),
      Color(0xFFF1F3F5),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFDFDFD),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Button gradients
  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [accentBlue, darkBlue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient secondaryButtonGradient = LinearGradient(
    colors: [lightGray, mediumGray],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Message bubble colors
  static const Color userBubble = accentBlue;
  static const Color botBubble = lightGray;
  static const Color userText = pureWhite;
  static const Color botText = primaryText;
}