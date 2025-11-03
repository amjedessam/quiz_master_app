import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/helpers.dart';
import 'home_controller.dart';
import 'widgets/stat_card.dart';
import 'widgets/subject_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: CustomScrollView(
            slivers: [
              // Welcome Header
              SliverToBoxAdapter(child: _buildWelcomeHeader()),

              // Statistics Cards
              SliverToBoxAdapter(child: _buildStatisticsSection()),

              // Subjects Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'المواد الدراسية',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${controller.subjects.length} مادة',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),

              // Subjects Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final subject = controller.subjects[index];
                    return SubjectCard(
                      subject: subject,
                      onTap: () => controller.goToSubjectDetails(subject),
                    );
                  }, childCount: controller.subjects.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      }),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Widget _buildWelcomeHeader() {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
  //     decoration: const BoxDecoration(
  //       gradient: AppColors.primaryGradient,
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(30),
  //         bottomRight: Radius.circular(30),
  //       ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   ' مرحباً عزيزي الطالب👋',
  //                   style: TextStyle(color: Colors.white70, fontSize: 16),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Obx(
  //                   () => Text(
  //                     controller.currentUser.value?.name ?? '',
  //                     style: const TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 24,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Obx(
  //               () => CircleAvatar(
  //                 radius: 25,
  //                 backgroundImage: NetworkImage(
  //                   controller.currentUser.value?.avatar ?? '',
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    ' مرحباً عزيزي الطالب👋',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      controller.currentUser.value?.name ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // الضغط على الصورة ينقل للملف الشخصي
              InkWell(
                onTap: controller.goToProfile,
                borderRadius: BorderRadius.circular(25),
                child: Obx(
                  () => CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      controller.currentUser.value?.avatar ?? '',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => StatCard(
                icon: Icons.quiz,
                title: 'الاختبارات',
                value: controller.totalQuizzes.value.toString(),
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => StatCard(
                icon: Icons.trending_up,
                title: 'المعدل',
                value: '${controller.averageScore.value.toStringAsFixed(1)}%',
                color: Helpers.getScoreColor(controller.averageScore.value),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => StatCard(
                icon: Icons.local_fire_department,
                title: 'أيام متتالية',
                value: controller.streakDays.value.toString(),
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildBottomNav() {
  //   return Obx(
  //     () => BottomNavigationBar(
  //       currentIndex: controller.selectedNavIndex.value,
  //       onTap: controller.changeNavIndex,
  //       type: BottomNavigationBarType.fixed,
  //       selectedItemColor: AppColors.primary,
  //       unselectedItemColor: AppColors.textSecondary,
  //       items: const [
  //         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.analytics),
  //           label: 'الإحصائيات',
  //         ),
  //         BottomNavigationBarItem(icon: Icon(Icons.history), label: 'السجل'),
  //         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف'),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBottomNav() {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.selectedNavIndex.value,
        onTap: controller.changeNavIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'اختبار'),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'ملخصات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'إحصائيات',
          ),
        ],
      ),
    );
  }
}
