import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final String message;
  final Color colorcard;

  const AlertCard({super.key, required this.message, required this.colorcard});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorcard,
      margin: const EdgeInsets.all(12),
      child: Text(message, style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }
}