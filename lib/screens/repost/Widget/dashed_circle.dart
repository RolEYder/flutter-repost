// @dart=2.0
import 'package:flutter/material.dart';
import 'package:dashed_circle/dashed_circle.dart';

class DashedStoryCircle extends StatefulWidget {
  @override
  _DashedStoryCircleState createState() => _DashedStoryCircleState();
}

class _DashedStoryCircleState extends State<DashedStoryCircle> with SingleTickerProviderStateMixin {
  /// Variables
  Animation gap;
  Animation base;
  Animation reverse;
  AnimationController controller;

  /// Init
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);
    gap = Tween<double>(begin: 3.0, end: 0.0).animate(base)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  /// Dispose
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: RotationTransition(
          turns: base,
          child: DashedCircle(
            gapSize: gap.value,
            dashes: 40,
            color: Color(0XFFED4634),
            child: RotationTransition(
              turns: reverse,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1564564295391-7f24f26f568b"
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}