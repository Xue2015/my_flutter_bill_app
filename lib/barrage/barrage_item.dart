import 'package:flutter/material.dart';

class BarrageItem extends StatelessWidget {
  final String id;
  final double top;
  final Widget child;
  final ValueChanged? onComplete;
  final Duration duration;

  const BarrageItem(
      {super.key,
      required this.id,
      required this.top,
      this.onComplete,
      this.duration = const Duration(milliseconds: 9000),
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: top),
        child: Container(
          child: child,
        ));
  }
}
