import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../core/theme/app_colors.dart';
import 'main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.screens,
        ),
      ),
      bottomNavigationBar: _buildCurvedBottomNav(),
    );
  }

  Widget _buildCurvedBottomNav() {
    return Container(
      height: 90,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(
              () => CurvedNavigationBar(
                index: controller.selectedIndex.value,
                height: 70,
                backgroundColor: Colors.transparent,
                color: AppColors.primary,
                buttonBackgroundColor: AppColors.primaryDark,
                animationDuration: const Duration(milliseconds: 300),
                animationCurve: Curves.easeInOut,
                onTap: controller.changeIndex,
                items: [
                  _buildNavIcon(Icons.auto_stories, 0),
                  _buildNavIcon(Icons.quiz, 1),
                  _buildNavIcon(Icons.home, 2, isCenter: true),
                  _buildNavIcon(Icons.analytics, 3),
                  _buildNavIcon(Icons.person, 4),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLabel('ملخصات', 0),
                  _buildLabel('اختبار', 1),
                  const SizedBox(width: 60),
                  _buildLabel('إحصائيات', 3),
                  _buildLabel('حسابي', 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, {bool isCenter = false}) {
    final isSelected = controller.selectedIndex.value == index;

    return Icon(
      icon,
      size: isCenter ? 35 : (isSelected ? 30 : 26),
      color: Colors.white,
    );
  }

  Widget _buildLabel(String text, int index) {
    final isSelected = controller.selectedIndex.value == index;

    return AnimatedOpacity(
      opacity: isSelected ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
