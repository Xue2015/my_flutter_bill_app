import 'package:flutter/material.dart';
import 'package:flutter_bill_app/core/hi_base_tab_state.dart';
import 'package:flutter_bill_app/http/core/hi_error.dart';
import 'package:flutter_bill_app/http/dao/home_dao.dart';
import 'package:flutter_bill_app/model/home_mo.dart';
import 'package:flutter_bill_app/model/video_model.dart';
import 'package:flutter_bill_app/util/color.dart';
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

class _HomeTabPageState extends HiBaseTabState<HomeMo, VideoModel, HomeTabPage> {

  @override
  void initState() {
    super.initState();
    print(widget.categoryName);
    print(widget.bannerList);
  }



  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 1, right: 1),
      child: HiBanner(widget.bannerList),
    );
  }



  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  // TODO: implement contentChild
  get contentChild => StaggeredGridView.countBuilder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      crossAxisCount: 2,
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        if (widget.bannerList != null && index == 0) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: _banner(),
          );
        } else {
          return VideoCard(
            videoMo: dataList[index],
          );
        }
      },
      staggeredTileBuilder: (index) {
        if (widget.bannerList != null && index == 0) {
          return StaggeredTile.fit(2);
        } else {
          return StaggeredTile.fit(1);
        }
      });

  @override
  Future<HomeMo> getData(int pageIndex) async {
    HomeMo result = await HomeDao.get(widget.categoryName, pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(HomeMo result) {
    return result.videoList!;
  }
}
