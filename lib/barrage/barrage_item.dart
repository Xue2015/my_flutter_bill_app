import 'package:flutter/material.dart';
import 'package:flutter_bill_app/barrage/barrage_transition.dart';

class BarrageItem extends StatelessWidget {
  final String id;
  final double top;
  final Widget child;
  final ValueChanged? onComplete;
  final Duration duration;

  BarrageItem(
      {super.key,
      required this.id,
      required this.top,
      this.onComplete,
      this.duration = const Duration(milliseconds: 9000),
      required this.child});

  var _key = GlobalKey<BarrageTransitionState>();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: top,
        child: BarrageTransition(
      key: _key,
      child: child,
      onComplete: (v) {
        onComplete!(id);
      },
      duration: duration,
    ));
  }
}
