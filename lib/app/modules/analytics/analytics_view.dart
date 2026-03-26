import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/helpers.dart';
import 'analytics_controller.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return _AnalyticsViewBody(controller: controller);
  }
}

/// Widget داخلي StatefulWidget لإعادة التحميل عند العودة للصفحة
class _AnalyticsViewBody extends StatefulWidget {
  final AnalyticsController controller;
  const _AnalyticsViewBody({required this.controller});

  @override
  State<_AnalyticsViewBody> createState() => _AnalyticsViewBodyState();
}

class _AnalyticsViewBodyState extends State<_AnalyticsViewBody>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // إعادة تحميل عند العودة للتطبيق من الخلفية
    if (state == AppLifecycleState.resumed) {
      widget.controller.fetchAnalytics();
    }
  }

  // ✅ الحل الأبسط: نستخدم didUpdateWidget للتحديث
  // ولكن الأهم هو onInit في الـ controller
  // سنضيف refresh في كل مرة يُبنى فيها الـ widget
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      return;
    }
    // ✅ عند العودة للصفحة (push ثم pop) — أعد التحميل
    widget.controller.fetchAnalytics();
  }

  AnalyticsController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FF),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2.5,
            ),
          );
        }
        return Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildAnalyticsTab()),
          ],
        );
      }),
    );
  }

  // ─────────────────────────────────────────
  // Header — purple gradient, no TabBar
  // ─────────────────────────────────────────
  Widget _buildHeader() {
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: const Center(
            child: Text(
              'الإحصائيات والتحليلات',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Analytics Tab
  // ─────────────────────────────────────────
  Widget _buildAnalyticsTab() {
    return RefreshIndicator(
      onRefresh: controller.fetchAnalytics,
      color: AppColors.primary,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallStatsCard(),
            const SizedBox(height: 28),
            _buildSectionTitle('أدائك عبر الوقت', Icons.show_chart_rounded),
            const SizedBox(height: 14),
            _buildPerformanceChart(),
            const SizedBox(height: 28),
            _buildSectionTitle('الأداء حسب المادة', Icons.school_rounded),
            const SizedBox(height: 14),
            _buildSubjectPerformance(),
            const SizedBox(height: 28),
            _buildSectionTitle('مستويات الإتقان', Icons.military_tech_rounded),
            const SizedBox(height: 14),
            _buildMasteryLevels(),
            const SizedBox(height: 28),
            _buildSectionTitle('المواضيع التي تحتاج تركيز', Icons.flag_rounded),
            const SizedBox(height: 14),
            _buildWeakTopics(),
            const SizedBox(height: 28),
            _buildSectionTitle('توصيات للمراجعة', Icons.lightbulb_rounded),
            const SizedBox(height: 14),
            _buildRecommendations(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Overall Stats Card
  // ─────────────────────────────────────────
  Widget _buildOverallStatsCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C74FF), Color(0xFF6C63FF)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
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
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const Text(
                  'الأداء الإجمالي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildStatItem(
                      icon: Icons.local_fire_department_rounded,
                      label: 'أيام متتالية',
                      value: controller.streakDays.value.toString(),
                    ),
                    _buildStatDivider(),
                    _buildStatItem(
                      icon: Icons.trending_up_rounded,
                      label: 'المعدل',
                      value:
                          '${controller.averageScore.value.toStringAsFixed(1)}%',
                    ),
                    _buildStatDivider(),
                    _buildStatItem(
                      icon: Icons.quiz_rounded,
                      label: 'الاختبارات',
                      value: controller.totalQuizzes.value.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 60,
      color: Colors.white.withOpacity(0.2),
    );
  }

  // ─────────────────────────────────────────
  // Section Title
  // ─────────────────────────────────────────
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 17, color: AppColors.primary),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // Performance Chart — fixed X-axis bug
  // ─────────────────────────────────────────
  Widget _buildPerformanceChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 20, 16, 12),
      child: SizedBox(
        height: 200,
        child: controller.performanceHistory.isEmpty
            ? const Center(
                child: Text(
                  'لا توجد بيانات كافية',
                  style: TextStyle(color: Color(0xFF9999BB), fontSize: 14),
                ),
              )
            : LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 25,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: const Color(0xFFF0F0FF), strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 38,
                        interval: 25,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}%',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9999BB),
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 ||
                              idx >= controller.performanceHistory.length) {
                            return const SizedBox.shrink();
                          }
                          // ✅ Fix: show formatted date not raw substring
                          final dayRaw =
                              controller.performanceHistory[idx]['day']
                                  ?.toString() ??
                              '';
                          // Try to parse yyyy-MM-dd → show MM/dd
                          String label = dayRaw;
                          if (dayRaw.contains('-') && dayRaw.length >= 10) {
                            final parts = dayRaw.split('-');
                            if (parts.length >= 3) {
                              label = '${parts[2]}/${parts[1]}';
                            }
                          } else if (dayRaw.length > 5) {
                            label = dayRaw.substring(dayRaw.length - 5);
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xFF9999BB),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.performanceHistory.asMap().entries.map((
                        e,
                      ) {
                        final y =
                            ((e.value['score'] as num?)?.toDouble()) ?? 0.0;
                        return FlSpot(e.key.toDouble(), y);
                      }).toList(),
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) =>
                            FlDotCirclePainter(
                              radius: 5,
                              color: Colors.white,
                              strokeWidth: 2.5,
                              strokeColor: AppColors.primary,
                            ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.18),
                            AppColors.primary.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Subject Performance
  // ─────────────────────────────────────────
  Widget _buildSubjectPerformance() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: controller.subjectPerformance.map((subject) {
          final name = subject['name']?.toString() ?? '';
          final score = ((subject['score'] as num?)?.toDouble()) ?? 0.0;
          final quizzes =
              (subject['quizzes'] as int?) ??
              (subject['quizzes'] as num?)?.toInt() ??
              0;
          Color color;
          try {
            final colorRaw = subject['color']?.toString() ?? '0xFF6C63FF';
            if (colorRaw.startsWith('#')) {
              final hex = colorRaw.replaceFirst('#', '');
              color = Color(int.parse(hex, radix: 16) | 0xFF000000);
            } else {
              color = Color(int.parse(colorRaw));
            }
          } catch (_) {
            color = const Color(0xFF6C63FF);
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${score.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Helpers.getScoreColor(score),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$quizzes اختبار',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9999BB),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFF0F0FF),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── خريطة ترجمة مهارات بلوم ─────────────────────────────────────────────
  static const Map<String, Map<String, dynamic>> _skillMeta = {
    'remember': {
      'label': 'تذكر',
      'icon': Icons.psychology_rounded,
      'color': Color(0xFF3B82F6),
    },
    'understand': {
      'label': 'فهم',
      'icon': Icons.lightbulb_rounded,
      'color': Color(0xFF22C55E),
    },
    'apply': {
      'label': 'تطبيق',
      'icon': Icons.build_rounded,
      'color': Color(0xFFF59E0B),
    },
    'analyze': {
      'label': 'تحليل',
      'icon': Icons.analytics_rounded,
      'color': Color(0xFF8B5CF6),
    },
  };

  // ─────────────────────────────────────────
  // Mastery Levels — بطاقات مهارات بلوم
  // ─────────────────────────────────────────
  Widget _buildMasteryLevels() {
    // ✅ فلترة unknown وأي مهارة غير معروفة
    final validLevels = controller.masteryLevels
        .where((m) => _skillMeta.containsKey(m['skill']?.toString()))
        .toList();

    if (validLevels.isEmpty) {
      return _buildEmptyCard(
        'لا توجد بيانات إتقان بعد\nأكمل بعض تمارين التدريب لترى تحليل مهاراتك',
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: validLevels.map((mastery) {
        final skillKey = mastery['skill']?.toString() ?? '';
        final meta = _skillMeta[skillKey]!;
        final arabicLabel = meta['label'] as String;
        final icon = meta['icon'] as IconData;
        final skillColor = meta['color'] as Color;
        final percentage = ((mastery['percentage'] as num?)?.toDouble()) ?? 0.0;
        final totalAnswers = (mastery['total_answers'] as num?)?.toInt() ?? 0;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: skillColor.withOpacity(0.15), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: skillColor.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── أيقونة المهارة ──────────────────────────────────
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: skillColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: skillColor, size: 24),
              ),
              const SizedBox(height: 10),

              // ── الدائرة مع النسبة ───────────────────────────────
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: percentage / 100,
                      strokeWidth: 6,
                      backgroundColor: skillColor.withOpacity(0.12),
                      valueColor: AlwaysStoppedAnimation(skillColor),
                      strokeCap: StrokeCap.round,
                    ),
                    Text(
                      '${percentage.round()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: skillColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ── اسم المهارة بالعربية ────────────────────────────
              Text(
                arabicLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 4),

              // ── عدد الأسئلة ─────────────────────────────────────
              Text(
                '$totalAnswers سؤال',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9999BB),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────
  // Weak Topics
  // ─────────────────────────────────────────
  Widget _buildWeakTopics() {
    if (controller.weakTopics.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                size: 34,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'رائع! لا توجد مواضيع ضعيفة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.success,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'استمر في هذا المستوى الممتاز',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: controller.weakTopics.map((topic) {
        final name = topic['name']?.toString() ?? '';
        final rate = ((topic['rate'] as num?)?.toDouble()) ?? 0.0;
        final subject = topic['subject']?.toString() ?? '';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.error,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$subject • معدل النجاح: ${rate.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9999BB),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${rate.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: rate / 100,
                  minHeight: 7,
                  backgroundColor: AppColors.error.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation(AppColors.error),
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => controller.explainWeakTopic(topic),
                child: Container(
                  width: double.infinity,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C74FF), Color(0xFF6C63FF)],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'راجع الآن',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────
  // Recommendations
  // ─────────────────────────────────────────
  Widget _buildRecommendations() {
    if (controller.recommendations.isEmpty) {
      return _buildEmptyCard('لا توجد توصيات حالياً');
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: controller.recommendations.asMap().entries.map((entry) {
          final index = entry.key;
          final rec = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    rec,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Color(0xFF4A4A6A),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Empty Card helper
  // ─────────────────────────────────────────
  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 14, color: Color(0xFF9999BB)),
        ),
      ),
    );
  }
}
