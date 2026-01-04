import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final String level;
  final String title;
  final String message;
  final List<dynamic> factors;

  const AlertCard({
    super.key,
    required this.level,
    required this.title,
    required this.message,
    required this.factors,
  });

  Color getColor() {
    switch (level) {
      case "HIGH":
        return Colors.red.shade400;
      case "MEDIUM":
        return Colors.orange.shade400;
      default:
        return Colors.green.shade400;
    }
  }

  IconData getIcon() {
    switch (level) {
      case "HIGH":
        return Icons.warning_rounded;
      case "MEDIUM":
        return Icons.error_outline;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: getColor().withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: getColor(), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(getIcon(), color: getColor()),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: getColor(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            message,
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: factors.map((f) {
              return Chip(
                label: Text(
                  f.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: getColor().withOpacity(0.15),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
