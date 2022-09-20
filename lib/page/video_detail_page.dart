import 'dart:io';

import 'package:flutter/material.dart' hide NavigationBar;
import 'package:flutter_bill_app/model/home_mo.dart';
import 'package:flutter_bill_app/util/view_util.dart';
import 'package:flutter_bill_app/widget/appbar.dart';
import 'package:flutter_bill_app/widget/navigation_bar.dart';
import 'package:flutter_bill_app/widget/video_view.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoMo? videoModel;

  const VideoDetailPage({Key? key, this.videoModel}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          removeTop: Platform.isIOS,
          context: context,
          child: Column(
            children: [
              HiNavigationBar(
                color: Colors.black,
                statusStyle: StatusStyle.LIGHT_CONTENT,
                height: Platform.isAndroid ? 0 : 46,
              ),
              _videoView(),
              Text('视频详情页，vid：${widget.videoModel!.vid}'),
              Text('视频详情页，title：${widget.videoModel!.title}'),
            ],
          )),
    );
  }

  _videoView() {
    var model = widget.videoModel;
    return VideoView(
      model!.url!,
      cover: model.cover!,
      overlayUI: videoAppBar(),
    );
  }

  @override
  void initState() {
    super.initState();
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
  }
}
