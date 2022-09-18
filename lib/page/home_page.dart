import 'package:flutter/material.dart';
import 'package:flutter_bill_app/model/video_model.dart';

import '../navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  // final ValueChanged<VideoModel> onJumpToDetail;
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  var listener;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text('首页'),
            MaterialButton(
              onPressed: () {
                HiNavigator.getInstance().onJumpTo(RouteStatus.detail,
                    args: {'videoMo': VideoModel(1001)});
              },
              child: Text('详情'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {

    super.initState();
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      print('home:current:${current.page}');
      print('home:pre:${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('打开了首页:onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页:onPause');
      }
    });
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    super.dispose();

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
