import 'package:flutter/material.dart';

class BarrageTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final ValueChanged onComplete;

  const BarrageTransition(
      {Key? key,
      required this.child,
      required this.duration,
      required this.onComplete})
      : super(key: key);

  @override
  State<BarrageTransition> createState() => BarrageTransitionState();
}

class BarrageTransitionState extends State<BarrageTransition>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<Offset>? _animation;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation!,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: widget.duration, vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.onComplete('');
            }
          });

    var begin = Offset(1.0, 0);
    var end = Offset(-1.0, 0);
    _animation = Tween(begin: begin, end: end).animate(_animationController!);
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}
