import 'package:flutter/material.dart';

class MEIGauge extends StatefulWidget {
  final int value;
  
  const MEIGauge({super.key, required this.value});

  @override
  State<MEIGauge> createState() => _MEIGaugeState();
}

class _MEIGaugeState extends State<MEIGauge> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<int> animation;

  @override
  void initState(){
    super.initState();
    controller=AnimationController(vsync: this, duration: Duration(milliseconds: 2500));
  
     
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Color gaugeColor(int mei_value){
    if (mei_value<=40) {
      return Colors.red;
    }
    if (mei_value<=60) {
      return Colors.amber;
    }
    else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    animation=IntTween(begin: 0, end: widget.value).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    controller.reset();
    controller.forward();   

    return  Center(
      child: AnimatedBuilder(
        animation: animation,
        builder:(context, child) {
          return Container(
            width: 180,
            height: 180,
            child: Center(child: Text("${animation.value}%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: gaugeColor(animation.value),
                width: 12,                                  
              ),
            ),
          );
        }
      ),
    );
    
  }
}