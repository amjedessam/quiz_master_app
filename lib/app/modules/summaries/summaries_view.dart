// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:quiz_master_app/app/core/theme/app_colors.dart';
// import 'summaries_controller.dart';

// class SummariesView extends GetView<SummariesController> {
//   // const SummariesView({super.key});
//   final int initialTab; // 0 = إنشاء جديد، 1 = السجل
//   final bool showTips; // إظهار نصائح
//   final bool showAppBar;
//     const SummariesView({
//     super.key,
//     this.initialTab = 0,
//     this.showTips = true,
//     this.showAppBar = true,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('الملخصات والشروحات'),
//         centerTitle: true,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child: Obx(
//             () => Container(
//               color: Colors.white,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: InkWell(
//                       onTap: () => controller.changeTab(0),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(
//                               color: controller.selectedTab.value == 0
//                                   ? AppColors.primary
//                                   : Colors.transparent,
//                               width: 3,
//                             ),
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             'إنشاء جديد',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: controller.selectedTab.value == 0
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                               color: controller.selectedTab.value == 0
//                                   ? AppColors.primary
//                                   : AppColors.textSecondary,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: InkWell(
//                       onTap: () => controller.changeTab(1),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(
//                               color: controller.selectedTab.value == 1
//                                   ? AppColors.primary
//                                   : Colors.transparent,
//                               width: 3,
//                             ),
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             'السجل',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: controller.selectedTab.value == 1
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                               color: controller.selectedTab.value == 1
//                                   ? AppColors.primary
//                                   : AppColors.textSecondary,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.selectedTab.value == 0) {
//           return _buildCreateNewTab();
//         } else {
//           return _buildHistoryTab();
//         }
//       }),
//     );
//   }

//   // تاب إنشاء جديد
//   Widget _buildCreateNewTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // بطاقة إنشاء ملخص
//           Card(
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: InkWell(
//               onTap: controller.createSummary,
//               borderRadius: BorderRadius.circular(16),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: AppColors.primary.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.summarize,
//                         size: 50,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'إنشاء ملخص',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'احصل على ملخص شامل لأي فصل أو موضوع',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.primary,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             'ابدأ الآن',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Icon(
//                             Icons.arrow_forward,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           const SizedBox(height: 16),

//           // بطاقة طلب شرح
//           Card(
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: InkWell(
//               onTap: controller.requestExplanation,
//               borderRadius: BorderRadius.circular(16),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: AppColors.info.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.school,
//                         size: 50,
//                         color: AppColors.info,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'طلب شرح',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'اطلب شرح مفصل لأي موضوع لم تفهمه',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.info,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             'اطلب شرح',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Icon(
//                             Icons.arrow_forward,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           const SizedBox(height: 24),

//           // معلومات إضافية
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppColors.warning.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: AppColors.warning.withOpacity(0.3)),
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.lightbulb_outline, color: AppColors.warning),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     'نصيحة: يمكنك الحصول على شرح تلقائي بعد الاختبارات الضعيفة',
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // تاب السجل
//   Widget _buildHistoryTab() {
//     return Obx(() {
//       if (controller.summariesHistory.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.auto_stories, size: 80, color: Colors.grey[300]),
//               const SizedBox(height: 16),
//               Text(
//                 'لا توجد ملخصات أو شروحات بعد',
//                 style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'ابدأ بإنشاء ملخص أو طلب شرح',
//                 style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//               ),
//             ],
//           ),
//         );
//       }
//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: controller.summariesHistory.length,
//         itemBuilder: (context, index) {
//           final item = controller.summariesHistory[index];
//           return _buildHistoryCard(item);
//         },
//       );
//     });
//   }

//   Widget _buildHistoryCard(Map<String, dynamic> item) {
//     final type = item['type'] as String;
//     final title = item['title'] as String;
//     final subject = item['subject'] as String;
//     final date = item['date'] as DateTime;

//     final isSummary = type == 'summary';
//     final icon = isSummary ? Icons.summarize : Icons.school;
//     final color = isSummary ? AppColors.primary : AppColors.info;

//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: () => controller.viewSummaryDetail(item),
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: color, size: 28),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       subject,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.calendar_today,
//                           size: 12,
//                           color: Colors.grey[600],
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           DateFormat('dd/MM/yyyy').format(date),
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.arrow_forward_ios),
//                 iconSize: 16,
//                 color: AppColors.textSecondary,
//                 onPressed: () => controller.viewSummaryDetail(item),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quiz_master_app/app/core/theme/app_colors.dart';
import 'summaries_controller.dart';

class SummariesView extends GetView<SummariesController> {
  final bool showAppBar; // <-- للتحكم بإظهار AppBar

  const SummariesView({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: const Text('الملخصات والشروحات'),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Obx(
                  () => Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => controller.changeTab(0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: controller.selectedTab.value == 0
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'إنشاء جديد',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        controller.selectedTab.value == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: controller.selectedTab.value == 0
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => controller.changeTab(1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: controller.selectedTab.value == 1
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'السجل',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        controller.selectedTab.value == 1
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: controller.selectedTab.value == 1
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: Obx(() {
        if (controller.selectedTab.value == 0) {
          return _buildCreateNewTab();
        } else {
          return _buildHistoryTab();
        }
      }),
    );
  }

  // ======================================
  // تبويب "إنشاء جديد"
  Widget _buildCreateNewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // بطاقة إنشاء ملخص
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: controller.createSummary,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.summarize,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'إنشاء ملخص',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'احصل على ملخص شامل لأي فصل أو موضوع',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ابدأ الآن',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // بطاقة طلب شرح
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: controller.requestExplanation,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school,
                        size: 50,
                        color: AppColors.info,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'طلب شرح',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'اطلب شرح مفصل لأي موضوع لم تفهمه',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.info,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'اطلب شرح',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ملاحظة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: AppColors.warning),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'نصيحة: يمكنك الوصول على شرح تلخيصي بعد الاختبارات الضخيفة',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
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

  // ======================================
  // تبويب "السجل"
  Widget _buildHistoryTab() {
    return Obx(() {
      if (controller.summariesHistory.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_stories, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'لا توجد ملخصات أو شروحات بعد',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'ابدأ بإنشاء ملخص أو طلب شرح',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.summariesHistory.length,
        itemBuilder: (context, index) {
          final item = controller.summariesHistory[index];
          return _buildHistoryCard(item);
        },
      );
    });
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    final type = item['type'] as String;
    final title = item['title'] as String;
    final subject = item['subject'] as String;
    final date = item['date'] as DateTime;

    final isSummary = type == 'summary';
    final icon = isSummary ? Icons.summarize : Icons.school;
    final color = isSummary ? AppColors.primary : AppColors.info;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.viewSummaryDetail(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd/MM/yyyy').format(date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                iconSize: 16,
                color: AppColors.textSecondary,
                onPressed: () => controller.viewSummaryDetail(item),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
