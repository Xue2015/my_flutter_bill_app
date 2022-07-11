import 'package:flutter/material.dart';
import 'package:flutter_bill_app/page/home_page.dart';
import 'package:flutter_bill_app/page/login_page.dart';
import 'package:flutter_bill_app/page/registration_page.dart';
import 'package:flutter_bill_app/page/video_detail_page.dart';

pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}


enum RouteStatus {login, registration, home, detail, unknown}

RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

class RouteStatusInfo{
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }

  return -1;
}

class HiNavigator extends _RouteJumpListener{
  static HiNavigator? _instance;

  RouteJumpListener? _routeJump;

  HiNavigator._();

  static HiNavigator getInstance() {
    if (_instance == null) {
      _instance = HiNavigator._();
    }

    return _instance!;
  }

  void registerRouteJump(RouteJumpListener routeJumpListener) {
    this._routeJump = routeJumpListener;
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump!.onJumpTo!(routeStatus, args: args!);
  }
}

abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map args});

class RouteJumpListener {
  final OnJumpTo? onJumpTo;

  RouteJumpListener({this.onJumpTo});

}