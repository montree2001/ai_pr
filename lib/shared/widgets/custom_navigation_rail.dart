import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class CustomNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomNavigationRail({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      backgroundColor: AppColors.backgroundLight,
      selectedIconTheme: const IconThemeData(
        color: AppColors.primaryBlue,
        size: 28,
      ),
      unselectedIconTheme: IconThemeData(
        color: AppColors.textGrey,
        size: 24,
      ),
      selectedLabelTextStyle: const TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: AppColors.textGrey,
        fontSize: 12,
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(Icons.chat_bubble),
          label: Text(AppStrings.aiChat),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.create_outlined),
          selectedIcon: Icon(Icons.create),
          label: Text(AppStrings.contentGen),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.event_outlined),
          selectedIcon: Icon(Icons.event),
          label: Text(AppStrings.eventPlan),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: Text(AppStrings.analytics),
        ),
      ],
    );
  }
}