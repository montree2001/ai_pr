import 'package:flutter/material.dart';

class FuturisticColors {
  // Primary holographic colors
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color neonPink = Color(0xFFFF1493);
  static const Color neonGreen = Color(0xFF00FF41);
  static const Color neonPurple = Color(0xFF9D00FF);
  static const Color neonBlue = Color(0xFF0080FF);
  
  // Dark theme colors
  static const Color darkSpace = Color(0xFF0A0A0F);
  static const Color darkPanel = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF16213E);
  static const Color darkGlass = Color(0xFF0F3460);
  
  // Accent colors
  static const Color electricBlue = Color(0xFF00BFFF);
  static const Color hologramSilver = Color(0xFFC0C0C0);
  static const Color energyYellow = Color(0xFFFFD700);
  static const Color neonYellow = Color(0xFFFFFF00);
  static const Color plasmaPurple = Color(0xFF7B68EE);
  
  // Gradients
  static const LinearGradient neonGradient = LinearGradient(
    colors: [neonCyan, neonPink, neonPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient holographicGradient = LinearGradient(
    colors: [
      Color(0xFF00F5FF),
      Color(0xFF9D00FF),
      Color(0xFF00FF41),
      Color(0xFFFF1493),
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient spaceGradient = LinearGradient(
    colors: [
      Color(0xFF0A0A0F),
      Color(0xFF1A1A2E),
      Color(0xFF16213E),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient glowGradient = LinearGradient(
    colors: [
      Color(0x4000F5FF),
      Color(0x6000F5FF),
      Color(0x4000F5FF),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // Animated gradient colors
  static const List<Color> animatedColors = [
    neonCyan,
    neonPink,
    neonGreen,
    neonPurple,
    neonBlue,
    electricBlue,
  ];
}