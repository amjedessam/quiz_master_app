// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quiz_master_app/app/data/models/notification_model.dart';
// import '../../core/theme/app_colors.dart';
// import 'notifications_controller.dart';

// /// مزيج من تصميم [AssignedExamsView] (بطاقات + تدرج) والهوية الأصلية للإشعارات.
// class NotificationsView extends GetView<NotificationsController> {
//   const NotificationsView({super.key});

//   static const Color _pageBg = Color(0xFFF5F7FA);
//   static const Color _onSurface = Color(0xFF1A1D2E);
//   static const Color _muted = Color(0xFF6B7280);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _pageBg,
//       appBar: AppBar(
//         title: const Text('الإشعارات'),
//         backgroundColor: Colors.white,
//         foregroundColor: _onSurface,
//         elevation: 0,
//         actions: [
//           Obx(() {
//             if (controller.unreadCount.value > 0) {
//               return TextButton.icon(
//                 onPressed: controller.markAllAsRead,
//                 icon: const Icon(Icons.done_all_rounded, size: 18),
//                 label: const Text('تحديد الكل'),
//                 style: TextButton.styleFrom(
//                   foregroundColor: AppColors.primary,
//                 ),
//               );
//             }
//             return const SizedBox.shrink();
//           }),
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: controller.loadNotifications,
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value && controller.notifications.isEmpty) {
//           return const Center(
//             child: CircularProgressIndicator(color: AppColors.primary),
//           );
//         }

//         if (controller.notifications.isEmpty) {
//           return _buildEmptyState();
//         }

//         return RefreshIndicator(
//           onRefresh: controller.refresh,
//           color: AppColors.primary,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: controller.notifications.length,
//             itemBuilder: (context, index) {
//               final n = controller.notifications[index];
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 16),
//                 child: _NotificationCardBlended(
//                   notification: n,
//                   onTap: () => controller.handleNotificationTap(n),
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 100,
//             height: 100,
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: Icon(
//               Icons.notifications_none_rounded,
//               size: 48,
//               color: AppColors.primary.withOpacity(0.9),
//             ),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'لا توجد إشعارات',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: _onSurface,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'ستظهر هنا تنبيهات المعلم والاختبارات والمواعيد',
//             style: TextStyle(fontSize: 14, color: _muted.withOpacity(0.95)),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _NotificationCardBlended extends GetView<NotificationsController> {
//   final NotificationModel notification;
//   final VoidCallback onTap;

//   const _NotificationCardBlended({
//     required this.notification,
//     required this.onTap,
//   });

//   static const _gradient = LinearGradient(
//     colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
//   );

//   @override
//   Widget build(BuildContext context) {
//     final isUnread = !notification.isRead;
//     final emoji = controller.getNotificationIcon(notification.type);
//     final timeLabel = controller.getRelativeTime(notification.createdAt);
//     final isExam = notification.type == 'exam_published';

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.06),
//                 blurRadius: 12,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // رأس بتدرج مثل AssignedExamsView
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: const BoxDecoration(
//                   gradient: _gradient,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 44,
//                       height: 44,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Center(
//                         child: Text(emoji, style: const TextStyle(fontSize: 22)),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             notification.title,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 2),
//                           Text(
//                             notification.subjectName ??
//                                 notification.assignmentTitle ??
//                                 _typeLabel(notification.type),
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.88),
//                               fontSize: 13,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (isUnread)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.25),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: const Text(
//                           'جديد',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),

//               // جسم أبيض — نص + تفاصيل (أسلوب المزيج مع الأصلي)
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       notification.body,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Color(0xFF4B5563),
//                         height: 1.5,
//                       ),
//                     ),

//                     if (notification.teacherName != null) ...[
//                       const SizedBox(height: 10),
//                       _inlineRow(
//                         Icons.person_outline_rounded,
//                         'المعلم: ${notification.teacherName}',
//                         const Color(0xFF6366F1),
//                       ),
//                     ],

//                     if (notification.dueDate != null) ...[
//                       const SizedBox(height: 6),
//                       _inlineRow(
//                         Icons.event_rounded,
//                         'ينتهي: ${_formatDue(notification.dueDate!)}',
//                         const Color(0xFFEF4444),
//                       ),
//                     ],

//                     const SizedBox(height: 12),
//                     const Divider(height: 1),
//                     const SizedBox(height: 12),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.schedule,
//                               size: 14,
//                               color: Color(0xFF6B7280),
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               timeLabel,
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xFF6B7280),
//                               ),
//                             ),
//                           ],
//                         ),
//                         if (!isUnread)
//                           Text(
//                             'مقروء',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.grey.shade500,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                       ],
//                     ),

//                     if (isExam && notification.assignmentId != null) ...[
//                       const SizedBox(height: 16),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 48,
//                         child: ElevatedButton.icon(
//                           onPressed: onTap,
//                           icon: const Icon(Icons.play_arrow_rounded, size: 22),
//                           label: const Text(
//                             'فتح الاختبار',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15,
//                             ),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF6C63FF),
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _typeLabel(String type) {
//     switch (type) {
//       case 'exam_published':
//         return 'اختبار من المعلم';
//       case 'exam_result':
//         return 'نتيجة اختبار';
//       case 'attendance_absent':
//         return 'غياب';
//       default:
//         return 'إشعار';
//     }
//   }

//   String _formatDue(DateTime dueDate) {
//     final now = DateTime.now();
//     final difference = dueDate.difference(now);
//     if (difference.isNegative) return 'منتهي';
//     if (difference.inDays > 0) {
//       return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
//     }
//     if (difference.inHours > 0) {
//       return '${difference.inHours} ساعة متبقية';
//     }
//     return 'أقل من ساعة';
//   }

//   Widget _inlineRow(IconData icon, String text, Color color) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 16, color: color),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: color,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_master_app/app/data/models/notification_model.dart';
import '../../core/theme/app_colors.dart';
import 'notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  static const Color _pageBg = Color(0xFFF0F2F8);
  static const Color _onSurface = Color(0xFF1A1D2E);
  static const Color _muted = Color(0xFF6B7280);
  static const Color _purple = Color(0xFF6C63FF);
  static const Color _purpleEnd = Color(0xFF9B59F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,

      // ── AppBar ثابت نظيف بدون أي تعقيد ──────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'الإشعارات',
          style: TextStyle(
            color: _onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _onSurface,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: _onSurface,
              size: 22,
            ),
            onPressed: controller.loadNotifications,
            tooltip: 'تحديث',
          ),
          Obx(() {
            if (controller.unreadCount.value > 0) {
              return TextButton(
                onPressed: controller.markAllAsRead,
                child: const Text(
                  'تحديد الكل',
                  style: TextStyle(
                    color: _purple,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(width: 4),
        ],
      ),

      // ── Body ─────────────────────────────────────────────
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: _purple));
        }

        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          color: _purple,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            // index 0 → banner header يتحرك مع القائمة
            itemCount: controller.notifications.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _buildHeaderBanner();

              final n = controller.notifications[index - 1];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _NotificationCard(
                  notification: n,
                  onTap: () => controller.handleNotificationTap(n),
                  index: index,
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // ── Header Banner — يتحرك مع القائمة ─────────────────────
  Widget _buildHeaderBanner() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_purple, _purpleEnd],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    ' الإشعارات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Obx(() {
                    final count = controller.unreadCount.value;
                    return Text(
                      count > 0
                          ? '$count إشعار غير مقروء'
                          : 'كل الإشعارات مقروءة ✓',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.82),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                ],
              ),
            ),
            // عداد دائري
            Obx(() {
              final count = controller.unreadCount.value;
              if (count == 0) return const SizedBox.shrink();
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _purple.withOpacity(0.12),
                  _purpleEnd.withOpacity(0.06),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 52,
              color: _purple,
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'ستظهر هنا تنبيهات المعلم\nوالاختبارات والمواعيد',
            style: TextStyle(
              fontSize: 14,
              color: _muted.withOpacity(0.8),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Notification Card
// ══════════════════════════════════════════════════════════
class _NotificationCard extends GetView<NotificationsController> {
  final NotificationModel notification;
  final VoidCallback onTap;
  final int index;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.index,
  });

  static Map<String, _TypeConfig> get _typeConfig => {
    'exam_published': _TypeConfig(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6C63FF), Color(0xFF9B59F5)],
      ),
      accentColor: const Color(0xFF6C63FF),
      icon: Icons.quiz_rounded,
    ),
    'exam_result': _TypeConfig(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF059669), Color(0xFF10B981)],
      ),
      accentColor: const Color(0xFF059669),
      icon: Icons.workspace_premium_rounded,
    ),
    'attendance_absent': _TypeConfig(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
      ),
      accentColor: const Color(0xFFDC2626),
      icon: Icons.event_busy_rounded,
    ),
  };

  _TypeConfig get _config =>
      _typeConfig[notification.type] ??
      const _TypeConfig(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF9B59F5)],
        ),
        accentColor: Color(0xFF6C63FF),
        icon: Icons.notifications_rounded,
      );

  bool get _isUnread => !notification.isRead;
  bool get _isExam =>
      notification.type == 'exam_published' &&
      notification.assignmentId != null;

  @override
  Widget build(BuildContext context) {
    final cfg = _config;
    final timeLabel = controller.getRelativeTime(notification.createdAt);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: cfg.accentColor.withOpacity(0.08),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: _isUnread
                ? Border.all(
                    color: cfg.accentColor.withOpacity(0.3),
                    width: 1.5,
                  )
                : Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: _isUnread
                    ? cfg.accentColor.withOpacity(0.12)
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isUnread ? 16 : 10,
                spreadRadius: _isUnread ? 1 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_buildHeader(cfg), _buildBody(cfg, timeLabel)],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(_TypeConfig cfg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: cfg.gradient,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1,
              ),
            ),
            child: Icon(cfg.icon, color: Colors.white, size: 23),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.label_rounded,
                      size: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        notification.subjectName ??
                            notification.assignmentTitle ??
                            _typeLabel(notification.type),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _StatusBadge(
            label: _isUnread ? 'جديد' : 'مقروء',
            outlined: !_isUnread,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(_TypeConfig cfg, String timeLabel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.body,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF4B5563),
              height: 1.6,
            ),
          ),
          if (notification.teacherName != null) ...[
            const SizedBox(height: 12),
            _InfoChip(
              icon: Icons.person_rounded,
              label: 'المعلم: ${notification.teacherName}',
              color: cfg.accentColor,
            ),
          ],
          if (notification.dueDate != null) ...[
            const SizedBox(height: 8),
            _InfoChip(
              icon: Icons.event_rounded,
              label: 'ينتهي: ${_formatDue(notification.dueDate!)}',
              color: const Color(0xFFEF4444),
            ),
          ],
          const SizedBox(height: 14),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 5),
              Text(
                timeLabel,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (_isUnread)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: cfg.accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          if (_isExam) ...[
            const SizedBox(height: 16),
            _ExamButton(
              onTap: onTap,
              gradient: cfg.gradient,
              accentColor: cfg.accentColor,
            ),
          ],
        ],
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'exam_published':
        return 'اختبار من المعلم';
      case 'exam_result':
        return 'نتيجة اختبار';
      case 'attendance_absent':
        return 'غياب';
      default:
        return 'إشعار';
    }
  }

  String _formatDue(DateTime dueDate) {
    final diff = dueDate.difference(DateTime.now());
    if (diff.isNegative) return 'منتهي';
    if (diff.inDays > 0) {
      return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
    }
    if (diff.inHours > 0) return '${diff.inHours} ساعة متبقية';
    return 'أقل من ساعة';
  }
}

// ══════════════════════════════════════════════════════════
// Sub-widgets
// ══════════════════════════════════════════════════════════

class _StatusBadge extends StatelessWidget {
  final String label;
  final bool outlined;

  const _StatusBadge({required this.label, this.outlined = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(20),
        border: outlined
            ? Border.all(color: Colors.white.withOpacity(0.55), width: 1)
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: outlined ? Colors.white.withOpacity(0.75) : Colors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamButton extends StatelessWidget {
  final VoidCallback onTap;
  final LinearGradient gradient;
  final Color accentColor;

  const _ExamButton({
    required this.onTap,
    required this.gradient,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'فتح الاختبار',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Type Config ───────────────────────────────────────────
class _TypeConfig {
  final LinearGradient gradient;
  final Color accentColor;
  final IconData icon;

  const _TypeConfig({
    required this.gradient,
    required this.accentColor,
    required this.icon,
  });
}
