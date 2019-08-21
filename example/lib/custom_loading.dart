import 'package:flutter/material.dart';

class CustomLoading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CustomLoadingState();
}

class CustomLoadingState extends State<CustomLoading> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 370));
    final CurvedAnimation curve = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    animation = Tween(begin: 22.0, end: 30.0).animate(curve)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
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
      height: 40,
      child: SizedBox(
        width: animation.value,
        height: animation.value,
        child: Image.asset('assets/images/loading.png'),
      ),
    );
  }
}
