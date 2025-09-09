import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/white_theme_colors.dart';
import 'core/services/storage_service.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/presentation/pages/simple_chat_page.dart';
import 'features/chat/presentation/pages/voice_chat_page.dart';
import 'shared/widgets/white_theme_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.initialize();
  runApp(const SmartPRApp());
}

class SmartPRApp extends StatelessWidget {
  const SmartPRApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: _buildWhiteTheme(),
      home: const WhiteThemeMainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildWhiteTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: WhiteThemeColors.softBlue,
      scaffoldBackgroundColor: WhiteThemeColors.softWhite,
      fontFamily: 'Roboto',
      
      appBarTheme: const AppBarTheme(
        backgroundColor: WhiteThemeColors.pureWhite,
        elevation: 0,
        foregroundColor: WhiteThemeColors.primaryText,
      ),
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: WhiteThemeColors.softBlue,
        brightness: Brightness.light,
      ),
    );
  }
}

class WhiteThemeMainScreen extends StatefulWidget {
  const WhiteThemeMainScreen({Key? key}) : super(key: key);

  @override
  State<WhiteThemeMainScreen> createState() => _WhiteThemeMainScreenState();
}

class _WhiteThemeMainScreenState extends State<WhiteThemeMainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteThemeColors.softWhite,
      body: _buildCurrentPage(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return BlocProvider(
          create: (context) => ChatBloc(),
          child: const SimpleChatPage(),
        );
      case 1:
        return BlocProvider(
          create: (context) => ChatBloc(),
          child: const VoiceChatPage(),
        );
      case 2:
        return const PlaceholderPage(
          title: 'Content Generator',
          icon: Icons.create,
          color: WhiteThemeColors.successGreen,
        );
      case 3:
        return const PlaceholderPage(
          title: 'Event Planner', 
          icon: Icons.event,
          color: WhiteThemeColors.warningOrange,
        );
      default:
        return BlocProvider(
          create: (context) => ChatBloc(),
          child: const SimpleChatPage(),
        );
    }
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WhiteThemeColors.pureWhite,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: WhiteThemeColors.borderGray),
        boxShadow: [
          BoxShadow(
            color: WhiteThemeColors.lightShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.chat_bubble_outline, 'Text Chat'),
          _buildNavItem(1, Icons.mic, 'Voice Chat'),
          _buildNavItem(2, Icons.create_outlined, 'Content'),
          _buildNavItem(3, Icons.event_outlined, 'Events'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                gradient: WhiteThemeColors.blueGradient,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: WhiteThemeColors.softBlue.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : WhiteThemeColors.secondaryText,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : WhiteThemeColors.secondaryText,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const PlaceholderPage({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: WhiteThemeColors.softWhite,
      child: Center(
        child: WhiteThemeCard(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 100, color: color),
              const SizedBox(height: 30),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: WhiteThemeColors.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Text(
                'ฟีเจอร์นี้อยู่ระหว่างการพัฒนา',
                style: TextStyle(
                  fontSize: 18,
                  color: WhiteThemeColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}