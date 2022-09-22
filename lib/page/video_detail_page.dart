import 'dart:io';

import 'package:flutter/material.dart' hide NavigationBar;
import 'package:flutter_bill_app/http/core/hi_error.dart';
import 'package:flutter_bill_app/http/dao/favorite_dao.dart';
import 'package:flutter_bill_app/http/dao/video_detail_dao.dart';
import 'package:flutter_bill_app/model/home_mo.dart';
import 'package:flutter_bill_app/model/video_detail_mo.dart';
import 'package:flutter_bill_app/model/video_model.dart';
import 'package:flutter_bill_app/util/toast.dart';
import 'package:flutter_bill_app/util/view_util.dart';
import 'package:flutter_bill_app/widget/appbar.dart';
import 'package:flutter_bill_app/widget/expandable_content.dart';
import 'package:flutter_bill_app/widget/hi_tab.dart';
import 'package:flutter_bill_app/widget/navigation_bar.dart';
import 'package:flutter_bill_app/widget/video_header.dart';
import 'package:flutter_bill_app/widget/video_toolbar.dart';
import 'package:flutter_bill_app/widget/video_view.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel? videoModel;

  const VideoDetailPage({Key? key, this.videoModel}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  TabController? _controller;
  List tabs = ['简介', '评论288'];
  VideoDetailMo? videoDetailMo;
  VideoModel? videoModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          removeTop: Platform.isIOS,
          context: context,
          child: videoModel!.url != null ? Column(
            children: [
              HiNavigationBar(
                color: Colors.black,
                statusStyle: StatusStyle.LIGHT_CONTENT,
                height: Platform.isAndroid ? 0 : 46,
              ),
              _buildVideoView(),
              _buildTabNavigation(),
              Flexible(
                  child: TabBarView(
                    controller: _controller,
                    children: [
                      _builDetailList(),
                      Container(
                        child: Text('敬请期待...'),
                      )
                    ],
                  ))
            ],
          ) : Container()),
    );
  }

  _buildVideoView() {
    var model = videoModel;
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
    _controller = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;
    _loadDetail();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.live_tv_rounded,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  _tabBar() {
    return HiTab(
        tabs.map<Tab>((name) {
          return Tab(
            text: name,
          );
        }).toList(),
        controller: _controller!);
  }

  _builDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [
        ...buildContents(),
        Container(
          height: 500,
          margin: EdgeInsets.only(top: 10),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(color: Colors.lightBlueAccent),
          child: Text('展开列表'),
        )
      ],
    );
  }

  buildContents() {
    return [
      VideoHeader(
        owner: videoModel!.owner!,
      ),
      ExpandableContent(
        mo: videoModel!,
      ),
      VideoToolBar(
        detailMo: videoDetailMo,
        videoModel: videoModel,
        onLike: _doLike,
        onUnLike: _onUnLike,
        onFavorite: _onFavorite,
      )
    ];
  }

  void _loadDetail() async {
    try {
      VideoDetailMo result = await VideoDetailDao.get(videoModel!.vid!);
      print(result);
      setState(() {
        videoDetailMo = result;
        videoModel = result.videoInfo;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  void _doLike() {}

  void _onFavorite() async {
    try {
      var result = await FavoriteDao.favorite(
          videoModel!.vid!, !videoDetailMo!.isFavorite!);
      print(result);
      videoDetailMo!.isFavorite = !videoDetailMo!.isFavorite!;
      if (videoDetailMo!.isFavorite!) {
        videoModel!.favorite = videoModel!.favorite! + 1;
      } else {
        videoModel!.favorite = videoModel!.favorite! - 1;
      }

      setState((){
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch(e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch(e) {
      print(e);
    }
  }

  void _onUnLike() {
  }
}
