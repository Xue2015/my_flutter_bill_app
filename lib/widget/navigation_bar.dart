import 'package:flutter/material.dart';
import 'package:flutter_bill_app/provider/theme_provider.dart';
import 'package:flutter_bill_app/util/color.dart';
import 'package:flutter_bill_app/util/view_util.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:provider/provider.dart';

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
  var _statusStyle;
  var _color;

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    if (themeProvider.isDark()) {
      _color = HiColor.dark_bg;
      _statusStyle = StatusStyle.LIGHT_CONTENT;
    } else {
      _color = widget.color;
      _statusStyle = widget.statusStyle;
    }

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
      decoration: BoxDecoration(color: _color),
    );
  }

  void _statusBarInit() {
    changeStatusBar(color: _color, statusStyle: _statusStyle);
  }

}