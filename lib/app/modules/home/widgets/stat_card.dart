import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  // ✅ إضافات الـ streak فقط — التصميم الأصلي محفوظ
  final bool isWarning;
  final bool isFrozen;
  final String? warningText;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.isWarning = false,
    this.isFrozen = false,
    this.warningText,
  });

  @override
  Widget build(BuildContext context) {
    // اللون يتغير فقط لو warning أو frozen
    final effectiveColor = isFrozen
        ? Colors.grey
        : isWarning
        ? Colors.orange
        : color;

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── أيقونة (نفس التصميم + badge صغير لو warning/frozen) ──
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: effectiveColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: effectiveColor, size: 28),
                ),
                if (isWarning || isFrozen)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isFrozen ? Colors.grey : Colors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Icon(
                        isFrozen ? Icons.close_rounded : Icons.warning_rounded,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // ── القيمة (نفس التصميم) ──
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: effectiveColor,
              ),
            ),

            const SizedBox(height: 4),

            // ── العنوان (نفس التصميم) ──
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            // ── نص التحذير (يظهر فقط لو warning/frozen) ──
            if (warningText != null) ...[
              const SizedBox(height: 4),
              Text(
                warningText!,
                style: TextStyle(
                  fontSize: 10,
                  color: isFrozen ? Colors.grey : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
