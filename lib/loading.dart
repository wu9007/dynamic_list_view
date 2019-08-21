import 'package:flutter/material.dart';
import 'dart:math' as math;

class Loading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoadingState();
}

class LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    final CurvedAnimation curve = CurvedAnimation(parent: controller, curve: Curves.easeInOutBack);
    animation = Tween(begin: 0.0, end: 2 * math.pi).animate(curve)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          controller.forward();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Transform.rotate(
        angle: animation.value,
        child: Icon(
          Icons.donut_large,
          color: Theme.of(context).primaryColor,
          size: 30,
        ),
      ),
    );
  }
}
