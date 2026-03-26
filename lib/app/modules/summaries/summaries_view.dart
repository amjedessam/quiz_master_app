import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quiz_master_app/app/core/theme/app_colors.dart';
import 'summaries_controller.dart';

class SummariesView extends GetView<SummariesController> {
  final bool showAppBar;
  const SummariesView({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FF),
      body: Column(
        children: [
          if (showAppBar) _buildHeader(pageController),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) => controller.changeTab(index),
              children: [_buildCreateNewTab(), _buildHistoryTab()],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // Header with gradient + custom TabBar
  // ─────────────────────────────────────────
  Widget _buildHeader(PageController pageController) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7C74FF), Color(0xFF6C63FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Title row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'الملخصات والشروحات',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Custom TabBar pill — animates PageView on tap
            Obx(
              () => Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _TabPill(
                      label: 'إنشاء جديد',
                      isSelected: controller.selectedTab.value == 0,
                      onTap: () {
                        controller.changeTab(0);
                        pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                        );
                      },
                    ),
                    _TabPill(
                      label: 'السجل',
                      isSelected: controller.selectedTab.value == 1,
                      onTap: () {
                        controller.changeTab(1);
                        pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Create New Tab
  // ─────────────────────────────────────────
  Widget _buildCreateNewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        children: [
          // Summary card — gradient purple
          _ActionCard(
            icon: Icons.auto_stories_rounded,
            gradientColors: const [Color(0xFF7C74FF), Color(0xFF6C63FF)],
            title: 'إنشاء ملخص',
            subtitle: 'احصل على ملخص شامل\nلأي فصل أو موضوع',
            buttonLabel: 'ابدأ الآن',
            features: const [
              'ملخص ذكي بالذكاء الاصطناعي',
              'يغطي كل نقاط الفصل',
              'سهل الحفظ والمراجعة',
            ],
            onTap: controller.createSummary,
          ),

          const SizedBox(height: 16),

          // Explanation card — gradient violet
          _ActionCard(
            icon: Icons.psychology_rounded,
            gradientColors: const [Color(0xFF9C6FFF), Color(0xFF7C5FEE)],
            title: 'طلب شرح',
            subtitle: 'اطلب شرح مفصل لأي\nموضوع لم تفهمه',
            buttonLabel: 'اطلب شرح',
            features: const ['شرح مبسّط وواضح', 'أمثلة تطبيقية', 'إجابة فورية'],
            onTap: controller.requestExplanation,
          ),

          const SizedBox(height: 20),

          // Tip banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.warning.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.lightbulb_rounded,
                    color: AppColors.warning,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'نصيحة: يمكنك الوصول على شرح تلخيصي بعد الاختبارات الضعيفة',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4A4A6A),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // History Tab
  // ─────────────────────────────────────────
  Widget _buildHistoryTab() {
    return Obx(() {
      if (controller.summariesHistory.isEmpty) {
        return _buildEmptyState();
      }
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        itemCount: controller.summariesHistory.length,
        itemBuilder: (context, index) {
          return _buildHistoryCard(controller.summariesHistory[index]);
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEFF),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              size: 46,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'لا توجد ملخصات أو شروحات بعد',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ابدأ بإنشاء ملخص أو طلب شرح',
            style: TextStyle(fontSize: 14, color: Color(0xFF9999BB)),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    final type = item['type'] as String;
    final title = item['title'] as String;
    final subject = item['subject'] as String;
    final date = item['date'] as DateTime;

    final isSummary = type == 'summary';
    final color = isSummary ? AppColors.primary : AppColors.info;
    final icon = isSummary ? Icons.auto_stories_rounded : Icons.school_rounded;
    final typeLabel = isSummary ? 'ملخص' : 'شرح';

    return GestureDetector(
      onTap: () => controller.viewSummaryDetail(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),

            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          typeLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        subject,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9999BB),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 11,
                        color: Color(0xFF9999BB),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd/MM/yyyy').format(date),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9999BB),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Tab Pill Widget
// ─────────────────────────────────────────
class _TabPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _TabPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Action Card Widget — Horizontal gradient design
// ─────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final List<Color> gradientColors;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final List<String> features;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.gradientColors,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.features,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles background
            Positioned(
              top: -20,
              left: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              right: -10,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side — icon + button
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon box
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(icon, color: Colors.white, size: 32),
                      ),

                      const SizedBox(height: 16),

                      // Button
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              buttonLabel,
                              style: TextStyle(
                                color: gradientColors.first,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_back_rounded,
                              color: gradientColors.first,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 18),

                  // Right side — title + features
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Feature bullets
                        ...features.map(
                          (f) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    f,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
