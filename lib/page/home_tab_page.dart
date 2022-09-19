import 'package:flutter/material.dart';
import 'package:flutter_bill_app/http/core/hi_error.dart';
import 'package:flutter_bill_app/http/dao/home_dao.dart';
import 'package:flutter_bill_app/model/home_mo.dart';
import 'package:flutter_bill_app/util/toast.dart';
import 'package:flutter_bill_app/widget/hi_banner.dart';
import 'package:flutter_bill_app/widget/video_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;

  const HomeTabPage({Key? key, required this.categoryName, this.bannerList})
      : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<VideoMo> videoList = [];
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              crossAxisCount: 2,
              itemCount: videoList.length,
              itemBuilder: (BuildContext context, int index) {
                if (widget.bannerList != null && index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: _banner(),
                  );
                } else {
                  return VideoCard(
                    videoMo: videoList[index],
                  );
                }
              },
              staggeredTileBuilder: (index) {
                if (widget.bannerList != null && index == 0) {
                  return StaggeredTile.fit(2);
                } else {
                  return StaggeredTile.fit(1);
                }
              })),
    );
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 1, right: 1),
      child: HiBanner(widget.bannerList),
    );
  }

  void _loadData({loadMore = false}) async {
    if (!loadMore) {
      pageIndex = 1;
    }

    var currentIndex = pageIndex + (loadMore ? 1 : 0);

    try {
      HomeMo result = await HomeDao.get(widget.categoryName,
          pageIndex: currentIndex, pageSize: 50);
      print('loadData(): $result');

      setState(() {
        if (loadMore) {
          if (result.videoList!.isNotEmpty) {
            videoList = [...videoList, ...result.videoList!];
            pageIndex++;
          }
        } else {
          videoList = result.videoList!;
        }
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }
}
