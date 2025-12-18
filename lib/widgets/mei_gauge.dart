import 'package:flutter/material.dart';

class MEIGauge extends StatelessWidget {
  final int value;
  const MEIGauge({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
          width: 180,
          height: 180,
          child: Center(child: Text("$value%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue,
              width: 12,                                  
            ),
          ),
        ),
    );
    
  }
}