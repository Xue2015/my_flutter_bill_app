import 'package:flutter/material.dart';
import 'package:flutter_bill_app/util/view_util.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

class HiNavigationBar extends StatefulWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget? child;

  const HiNavigationBar({Key? key,
    this.statusStyle = StatusStyle.DARK_CONTENT,
    this.color = Colors.white,
    this.height = 46,
    this.child})
      : super(key: key);

  @override
  State<HiNavigationBar> createState() => _HiNavigationBarState();
}

class _HiNavigationBarState extends State<HiNavigationBar> {

  @override
  Widget build(BuildContext context) {
    _statusBarInit();
    var top = MediaQuery
        .of(context)
        .padding
        .top;
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: top + widget.height,
      child: widget.child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: widget.color),
    );
  }

  void _statusBarInit() {
    changeStatusBar(color: widget.color, statusStyle: widget.statusStyle);
  }

  @override
  void initState() {
    super.initState();
    _statusBarInit();
  }
}