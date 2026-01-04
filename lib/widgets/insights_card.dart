import 'package:flutter/material.dart';


class InsightsCard extends StatelessWidget {
  final String insightTitle;
  final String insightMessage;
  final String insightType;
  const InsightsCard({super.key, required this.insightTitle, required this.insightMessage, required this.insightType});

  @override
  Widget build(BuildContext context) {
    return Card(
          color: insightType == 'positive'
              ? Colors.green.shade200
              : insightType == 'warning'
                  ? Colors.orange.shade200
                  : insightType == 'danger'
                      ? Colors.red.shade200
                      : Colors.grey.shade500,
          margin:  const EdgeInsets.all(16),
          child:  Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insightTitle,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(insightMessage),
              ],
            ),
          ),
        )
        ;
  }
}