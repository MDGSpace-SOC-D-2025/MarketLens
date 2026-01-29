import 'package:flutter/material.dart';

class InsightsCard extends StatelessWidget {
  final String insightTitle;
  final String insightMessage;
  final String insightType;
  final String severity;
  final Map<String, dynamic>? metrics;

  const InsightsCard({
    super.key,
    required this.insightTitle,
    required this.insightMessage,
    required this.insightType,
    required this.severity,
    this.metrics,
  });

  Color _severityColor() {
    switch (severity) {
      case "high":
        return Colors.redAccent;
      case "medium":
        return Colors.orangeAccent;
      case "low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _severityIcon() {
    switch (severity) {
      case "high":
        return Icons.warning_rounded;
      case "medium":
        return Icons.info_rounded;
      case "low":
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Icon(_severityIcon(), color: _severityColor()),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    insightTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// MESSAGE
            Text(
              insightMessage,
              style: const TextStyle(fontSize: 14),
            ),

            /// METRIC CHIPS
            if (metrics != null && metrics!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: metrics!.entries.map((entry) {
                  return Chip(
                    label: Text(
                      "${entry.key}: ${entry.value}",  //momentum:strong
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor:
                        _severityColor().withOpacity(0.12),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
