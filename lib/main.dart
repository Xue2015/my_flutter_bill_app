import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bill_app/http/core/hi_error.dart';
import 'package:flutter_bill_app/http/core/hi_net.dart';
import 'package:flutter_bill_app/http/dao/login_dao.dart';
import 'package:flutter_bill_app/http/request/test_request.dart';
import 'package:flutter_bill_app/model/video_model.dart';
import 'package:flutter_bill_app/navigator/hi_navigator.dart';
import 'package:flutter_bill_app/page/home_page.dart';
import 'package:flutter_bill_app/page/login_page.dart';
import 'package:flutter_bill_app/page/registration_page.dart';
import 'package:flutter_bill_app/page/video_detail_page.dart';
import 'package:flutter_bill_app/util/color.dart';
import 'package:flutter_bill_app/util/toast.dart';

import 'db/hi_cache.dart';
import 'model/owner.dart';

void main() {
  runApp(BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({Key? key}) : super(key: key);

  @override
  State<BiliApp> createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(
                  routerDelegate: _routeDelegate,
                )
              : Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );

          return MaterialApp(
            home: widget,
            theme: ThemeData(primarySwatch: white),
          );
        });
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    HiNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        this.videoModel = args!['videoMo'];
      }
      notifyListeners();
    }));
  }

  RouteStatus _routeStatus = RouteStatus.home;

  List<MaterialPage> pages = [];
  VideoModel? videoModel;

  bool get hasLogin => LoginDao.getBoardingPass() != null;

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      tempPages = tempPages.sublist(0, index);
    }

    var page;
    if (routeStatus == RouteStatus.home) {
      pages.clear();
      page = pageWrap(HomePage());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel: videoModel));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage(
        onJumpToLogin: () {
          _routeStatus = RouteStatus.login;
          notifyListeners();
        },
      ));
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage(
        onSuccess: () {
          _routeStatus = RouteStatus.home;
          notifyListeners();
        },
        onJumpRegistration: () {
          _routeStatus = RouteStatus.registration;
          notifyListeners();
        },
      ));
    }

    tempPages = [...tempPages, page];
    pages = tempPages;

    return WillPopScope(
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            if (route.settings is MaterialPage) {
              if ((route.settings as MaterialPage).child is LoginPage) {
                if (!hasLogin) {
                  showWarnToast("请先登录");
                  return false;
                }
              }
            }

            if (!route.didPop(result)) {
              return false;
            }

            pages.removeLast();
            return true;
          },
        ),
        onWillPop: () async => !await navigatorKey.currentState!.maybePop());
  }

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath configuration) async {}
}

class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = "/";

  BiliRoutePath.detail() : location = "/detail";
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    HiCache.preInit();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: white,
      ),
      // home: LoginPage(),
      home: RegistrationPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _incrementCounter() async {
    // TestRequest request = TestRequest();
    // request.add('add', 'test').add("requestPrams", "kkkk");
    // try {
    //   var result = await HiNet.getInstance()!.fire(request);
    //   print(result);
    // } on NeedLogin catch (e) {
    //   print(e);
    // } on NeedAuth catch (e) {
    //   print(e);
    // } on HiNetError catch (e) {
    //   print(e);
    // }
    // test();
    // test1();
    // test2();
    testLogin();
  }

  void test2() {
    HiCache.getInstance().setString('aa', "1234");
    var value = HiCache.getInstance().get("aa");
    print('value:$value');
  }

  @override
  void initState() {
    super.initState();
    HiCache.preInit();
  }

  void test() {
    const jsonString =
        "{\"name\":\"flutter\",\"url\":\"https://coding.imooc.com/class/487.html\"}";
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    print('name:${jsonMap['name']}');
    print('url:${jsonMap['url']}');

    String json = jsonEncode(jsonMap);
    print('json:$json');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void test1() {
    var ownerMap = {"name": "111", "face": "http:///", "fans": 0};

    Owner owner = Owner.fromJson(ownerMap);
    print('name:${owner.name}');
  }

  void testLogin() async {
    var result = await LoginDao.registration("111", "222", "123445", "5566");
    print(result);
  }
}
