// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../../core/theme/app_colors.dart';
// import '../../core/utils/helpers.dart';
// import 'analytics_controller.dart';

// class AnalyticsView extends GetView<AnalyticsController> {
//   const AnalyticsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('الإحصائيات والتحليلات'),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return RefreshIndicator(
//           onRefresh: controller.fetchAnalytics,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Overall Statistics Card
//                 _buildOverallStatsCard(),

//                 const SizedBox(height: 24),

//                 // Performance Chart
//                 _buildSectionTitle('أدائك عبر الوقت'),
//                 const SizedBox(height: 12),
//                 _buildPerformanceChart(),

//                 const SizedBox(height: 24),

//                 // Performance by Subject
//                 _buildSectionTitle('الأداء حسب المادة'),
//                 const SizedBox(height: 12),
//                 _buildSubjectPerformance(),

//                 const SizedBox(height: 24),

//                 // Mastery Levels
//                 _buildSectionTitle('مستويات الإتقان'),
//                 const SizedBox(height: 12),
//                 _buildMasteryLevels(),

//                 const SizedBox(height: 24),

//                 // Weak Topics
//                 _buildSectionTitle('المواضيع التي تحتاج تركيز'),
//                 const SizedBox(height: 12),
//                 _buildWeakTopics(),

//                 const SizedBox(height: 24),

//                 // Study Recommendations
//                 _buildSectionTitle('توصيات للمراجعة'),
//                 const SizedBox(height: 12),
//                 _buildRecommendations(),

//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildOverallStatsCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         decoration: const BoxDecoration(
//           gradient: AppColors.primaryGradient,
//           borderRadius: BorderRadius.all(Radius.circular(16)),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const Text(
//               'الأداء الإجمالي',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildStatItem(
//                   icon: Icons.quiz,
//                   label: 'الاختبارات',
//                   value: controller.totalQuizzes.value.toString(),
//                 ),
//                 _buildStatItem(
//                   icon: Icons.trending_up,
//                   label: 'المعدل',
//                   value: '${controller.averageScore.value.toStringAsFixed(1)}%',
//                 ),
//                 _buildStatItem(
//                   icon: Icons.local_fire_department,
//                   label: 'أيام متتالية',
//                   value: controller.streakDays.value.toString(),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, color: Colors.white, size: 28),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           value,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           label,
//           style: const TextStyle(color: Colors.white70, fontSize: 12),
//         ),
//       ],
//     );
//   }

//   Widget _buildPerformanceChart() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SizedBox(
//           height: 200,
//           child: LineChart(
//             LineChartData(
//               gridData: FlGridData(show: false),
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     reservedSize: 40,
//                     getTitlesWidget: (value, meta) {
//                       return Text(
//                         '${value.toInt()}%',
//                         style: const TextStyle(fontSize: 10),
//                       );
//                     },
//                   ),
//                 ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       if (value.toInt() >=
//                           controller.performanceHistory.length) {
//                         return const SizedBox.shrink();
//                       }
//                       return Text(
//                         controller.performanceHistory[value.toInt()]['day']
//                             .toString()
//                             .substring(0, 2),
//                         style: const TextStyle(fontSize: 10),
//                       );
//                     },
//                   ),
//                 ),
//                 rightTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 topTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//               ),
//               borderData: FlBorderData(show: false),
//               minY: 0,
//               maxY: 100,
//               lineBarsData: [
//                 LineChartBarData(
//                   spots: controller.performanceHistory
//                       .asMap()
//                       .entries
//                       .map(
//                         (e) => FlSpot(
//                           e.key.toDouble(),
//                           (e.value['score'] as double),
//                         ),
//                       )
//                       .toList(),
//                   isCurved: true,
//                   color: AppColors.primary,
//                   barWidth: 3,
//                   dotData: FlDotData(show: true),
//                   belowBarData: BarAreaData(
//                     show: true,
//                     color: AppColors.primary.withOpacity(0.1),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSubjectPerformance() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: controller.subjectPerformance.map((subject) {
//             final name = subject['name'] as String;
//             final score = subject['score'] as double;
//             final quizzes = subject['quizzes'] as int;
//             final color = Color(int.parse(subject['color'] as String));

//             return Padding(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         name,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         '${score.toStringAsFixed(0)}%',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Helpers.getScoreColor(score),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: LinearProgressIndicator(
//                       value: score / 100,
//                       minHeight: 10,
//                       backgroundColor: Colors.grey[200],
//                       valueColor: AlwaysStoppedAnimation(color),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '$quizzes اختبار',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildMasteryLevels() {
//     return Wrap(
//       spacing: 12,
//       runSpacing: 12,
//       children: controller.masteryLevels.map((mastery) {
//         final skill = mastery['skill'] as String;
//         final percentage = mastery['percentage'] as double;

//         return SizedBox(
//           width: (Get.width - 48) / 2,
//           child: Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       SizedBox(
//                         width: 80,
//                         height: 80,
//                         child: CircularProgressIndicator(
//                           value: percentage / 100,
//                           strokeWidth: 8,
//                           backgroundColor: Colors.grey[200],
//                           valueColor: AlwaysStoppedAnimation(
//                             Helpers.getScoreColor(percentage),
//                           ),
//                         ),
//                       ),
//                       Text(
//                         '${percentage.round()}%',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                           color: Helpers.getScoreColor(percentage),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     skill,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildWeakTopics() {
//     if (controller.weakTopics.isEmpty) {
//       return Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             children: [
//               Icon(Icons.emoji_events, size: 64, color: AppColors.success),
//               const SizedBox(height: 16),
//               Text(
//                 'رائع! لا توجد مواضيع ضعيفة',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.success,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Column(
//       children: controller.weakTopics.map((topic) {
//         final name = topic['name'] as String;
//         final rate = topic['rate'] as double;
//         final subject = topic['subject'] as String;

//         return Card(
//           elevation: 2,
//           margin: const EdgeInsets.only(bottom: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: ListTile(
//             leading: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: AppColors.error.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.warning_amber_rounded,
//                 color: AppColors.error,
//               ),
//             ),
//             title: Text(
//               name,
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('$subject • معدل النجاح: ${rate.toStringAsFixed(0)}%'),
//                 const SizedBox(height: 6),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(4),
//                   child: LinearProgressIndicator(
//                     value: rate / 100,
//                     minHeight: 4,
//                     backgroundColor: Colors.grey[200],
//                     valueColor: const AlwaysStoppedAnimation(AppColors.error),
//                   ),
//                 ),
//               ],
//             ),
//             trailing: TextButton(
//               onPressed: () {
//                 // Navigate to quiz for this topic
//               },
//               child: const Text('راجع الآن'),
//             ),
//             contentPadding: const EdgeInsets.all(12),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildRecommendations() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.lightbulb, color: AppColors.warning),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'توصيات ذكية',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             ...controller.recommendations.map((rec) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(
//                       Icons.check_circle_outline,
//                       size: 20,
//                       color: AppColors.primary,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         rec,
//                         style: const TextStyle(fontSize: 14, height: 1.5),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: AppColors.textPrimary,
//       ),
//     );
//   }
// }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإحصائيات والتحليلات'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return TabBarView(
          controller: controller.tabController,
          children: [_buildAnalyticsTab(), _buildHistoryTab()],
        );
      }),
    );
  }

  // تاب الإحصائيات
  Widget _buildAnalyticsTab() {
    return RefreshIndicator(
      onRefresh: controller.fetchAnalytics,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallStatsCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('أدائك عبر الوقت'),
            const SizedBox(height: 12),
            _buildPerformanceChart(),
            const SizedBox(height: 24),
            _buildSectionTitle('الأداء حسب المادة'),
            const SizedBox(height: 12),
            _buildSubjectPerformance(),
            const SizedBox(height: 24),
            _buildSectionTitle('مستويات الإتقان'),
            const SizedBox(height: 12),
            _buildMasteryLevels(),
            const SizedBox(height: 24),
            _buildSectionTitle('المواضيع التي تحتاج تركيز'),
            const SizedBox(height: 12),
            _buildWeakTopics(),
            const SizedBox(height: 24),
            _buildSectionTitle('توصيات للمراجعة'),
            const SizedBox(height: 12),
            _buildRecommendations(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // تاب السجل
  Widget _buildHistoryTab() {
    // استدعاء History View كـ Widget
    return const Center(
      child: Text(
        'سيتم عرض سجل الاختبارات هنا',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildOverallStatsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'الأداء الإجمالي',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.quiz,
                  label: 'الاختبارات',
                  value: controller.totalQuizzes.value.toString(),
                ),
                _buildStatItem(
                  icon: Icons.trending_up,
                  label: 'المعدل',
                  value: '${controller.averageScore.value.toStringAsFixed(1)}%',
                ),
                _buildStatItem(
                  icon: Icons.local_fire_department,
                  label: 'أيام متتالية',
                  value: controller.streakDays.value.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPerformanceChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}%',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >=
                          controller.performanceHistory.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        controller.performanceHistory[value.toInt()]['day']
                            .toString()
                            .substring(0, 2),
                        style: const TextStyle(fontSize: 10),
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
                  spots: controller.performanceHistory
                      .asMap()
                      .entries
                      .map(
                        (e) => FlSpot(
                          e.key.toDouble(),
                          (e.value['score'] as double),
                        ),
                      )
                      .toList(),
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectPerformance() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: controller.subjectPerformance.map((subject) {
            final name = subject['name'] as String;
            final score = subject['score'] as double;
            final quizzes = subject['quizzes'] as int;
            final color = Color(int.parse(subject['color'] as String));

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${score.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Helpers.getScoreColor(score),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: score / 100,
                      minHeight: 10,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$quizzes اختبار',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMasteryLevels() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: controller.masteryLevels.map((mastery) {
        final skill = mastery['skill'] as String;
        final percentage = mastery['percentage'] as double;

        return SizedBox(
          width: (Get.width - 48) / 2,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: percentage / 100,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(
                            Helpers.getScoreColor(percentage),
                          ),
                        ),
                      ),
                      Text(
                        '${percentage.round()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Helpers.getScoreColor(percentage),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    skill,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeakTopics() {
    if (controller.weakTopics.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.emoji_events, size: 64, color: AppColors.success),
              const SizedBox(height: 16),
              Text(
                'رائع! لا توجد مواضيع ضعيفة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: controller.weakTopics.map((topic) {
        final name = topic['name'] as String;
        final rate = topic['rate'] as double;
        final subject = topic['subject'] as String;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.error,
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
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$subject • معدل النجاح: ${rate.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: rate / 100,
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation(AppColors.error),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => controller.explainWeakTopic(topic),
                    icon: const Icon(Icons.school, size: 18),
                    label: const Text('راجع الآن'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.info,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecommendations() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: AppColors.warning),
                const SizedBox(width: 8),
                const Text(
                  'توصيات ذكية',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...controller.recommendations.map((rec) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        rec,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}
