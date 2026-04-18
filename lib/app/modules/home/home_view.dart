import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/helpers.dart';
import '../../routes/app_routes.dart';
import '../notifications/notifications_controller.dart';
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
              SliverToBoxAdapter(child: _buildWelcomeHeader()),
              SliverToBoxAdapter(child: _buildStatisticsSection()),
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
      // ✅ زر عائم لفتح واجهات الأداة
      floatingActionButton: FloatingActionButton(
        onPressed: controller.toggleAIMenu,
        tooltip: 'أدوات الاختبار الذكية',
        backgroundColor: AppColors.primary,
        child: Obx(
          () => Icon(
            controller.showAIMenu.value ? Icons.close : Icons.auto_awesome,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // ✅ قائمة سفلية بخيارات الأداة
      bottomSheet: Obx(
        () => controller.showAIMenu.value
            ? _buildAIToolsMenu(context)
            : const SizedBox.shrink(),
      ),
    );
  }

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

              // ✅ استبدال الصورة الشخصية بأيقونة الإشعارات
              _buildNotificationButton(),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ دالة جديدة: زر الإشعارات مع Badge
  Widget _buildNotificationButton() {
    // محاولة الحصول على NotificationsController
    NotificationsController? notificationsController;
    try {
      notificationsController = Get.find<NotificationsController>();
    } catch (e) {
      // إذا لم يكن موجود، سننشئه
      notificationsController = Get.put(NotificationsController());
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () => Get.toNamed(AppRoutes.NOTIFICATIONS),
          ),
        ),

        // Badge للإشعارات غير المقروءة
        Obx(() {
          final unreadCount = notificationsController?.unreadCount.value ?? 0;
          if (unreadCount > 0) {
            return Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  unreadCount > 9 ? '9+' : '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              // ── الاختبارات ──
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

              // ── المعدل ──
              Expanded(
                child: Obx(
                  () => StatCard(
                    icon: Icons.trending_up,
                    title: 'المعدل',
                    value:
                        '${controller.averageScore.value.toStringAsFixed(1)}%',
                    color: Helpers.getScoreColor(controller.averageScore.value),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // ── أيام متتالية (مع حالة الـ streak) ──
              Expanded(
                child: Obx(() {
                  final status = controller.streakStatus.value;
                  final daysLeft = controller.streakDaysLeft.value;
                  final isWarning = status == 'warning';
                  final isFrozen = status == 'frozen';

                  String? warningText;
                  if (isWarning && daysLeft != null) {
                    warningText =
                        'باقي $daysLeft ${daysLeft == 1 ? 'يوم' : 'أيام'}';
                  } else if (isFrozen) {
                    warningText = 'انتهى الـ streak';
                  }

                  return StatCard(
                    icon: Icons.local_fire_department,
                    title: 'أيام متتالية',
                    value: controller.streakDays.value.toString(),
                    color: AppColors.warning,
                    isWarning: isWarning,
                    isFrozen: isFrozen,
                    warningText: warningText,
                  );
                }),
              ),
            ],
          ),
        ),

        // ── بانر التحذير ──
        Obx(() {
          if (!controller.showStreakWarning) return const SizedBox.shrink();
          final daysLeft = controller.streakDaysLeft.value ?? 0;
          return Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Text('⚠️', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'streak الخاص بك في خطر! حل كويز اليوم قبل أن تفقد '
                    '${controller.streakDays.value} أيام متتالية. '
                    'باقي $daysLeft ${daysLeft == 1 ? 'يوم' : 'أيام'} فقط.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ✅ بناء قائمة أدوات الذكاء الاصطناعي
  Widget _buildAIToolsMenu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Title
                const Text(
                  'أدوات الاختبار الذكية ✨',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // اختبار المنهج
                _buildAIMenuOption(
                  icon: Icons.school,
                  title: 'اختبار المنهج الدراسي',
                  subtitle: 'اختر من المنهج الدراسي',
                  onTap: controller.startCurriculumQuiz,
                ),
                const SizedBox(height: 12),

                // اختبار الموضوع
                _buildAIMenuOption(
                  icon: Icons.lightbulb,
                  title: 'اختبار مبني على الموضوع',
                  subtitle: 'أدخل موضوع وتوليد أسئلة',
                  onTap: controller.showTopicQuizDialog,
                ),
                const SizedBox(height: 12),

                // اختبار مخصص
                _buildAIMenuOption(
                  icon: Icons.add_circle,
                  title: 'إنشاء اختبار مخصص',
                  subtitle: 'اختر نوع الأسئلة والعدد',
                  onTap: controller.showCustomQuizDialog,
                ),
                const SizedBox(height: 12),

                // معلومات المنهج
                _buildAIMenuOption(
                  icon: Icons.info_outline,
                  title: 'معلومات المنهج',
                  subtitle: 'احصائيات وتفاصيل',
                  onTap: controller.showCurriculumInfo,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ بناء خيار من قائمة الأدوات
  Widget _buildAIMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
