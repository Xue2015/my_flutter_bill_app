import 'package:flutter/material.dart';
import 'package:flutter_bill_app/core/hi_state.dart';
import 'package:flutter_bill_app/http/core/hi_error.dart';
import 'package:flutter_bill_app/http/dao/home_dao.dart';
import 'package:flutter_bill_app/model/home_mo.dart';
import 'package:flutter_bill_app/model/video_model.dart';
import 'package:flutter_bill_app/page/home_tab_page.dart';
import 'package:flutter_bill_app/util/color.dart';
import 'package:flutter_bill_app/util/toast.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  // final ValueChanged<VideoModel> onJumpToDetail;
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;

  TabController? _controller;

  // var tabs = ["推荐", "热门", "追播", "影视", "搞笑", "日常", "综合", "手机游戏", "短片·手书·配音"];
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: _tabBar(),
          ),
          Flexible(
              child: TabBarView(
            controller: _controller,
            children: categoryList.map((tab) {
              return HomeTabPage(
                name: tab.name!,
                bannerList: tab.name == '推荐' ? bannerList : null,
              );
            }).toList(),
          ))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: categoryList.length, vsync: this);

    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      print('home:current:${current.page}');
      print('home:pre:${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('打开了首页:onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页:onPause');
      }
    });

    loadData();
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    _controller!.dispose();
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _tabBar() {
    return TabBar(
        controller: _controller,
        isScrollable: true,
        labelColor: Colors.black,
        indicator: UnderlineIndicator(
            strokeCap: StrokeCap.round,
            borderSide: BorderSide(color: primary, width: 3),
            insets: EdgeInsets.only(left: 15, right: 15)),
        tabs: categoryList.map<Tab>((tab) {
          return Tab(
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text(
                tab.name!,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }).toList());
  }

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get('推荐');
      print('loadData(): $result');
      if (result.categoryList != null) {
        _controller =
            TabController(length: result.categoryList!.length, vsync: this);
      }

      setState(() {
        categoryList = result.categoryList!;
        bannerList = result.bannerList!;
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
