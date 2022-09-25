import 'package:flutter/material.dart';
import 'package:flutter_bill_app/core/hi_state.dart';
import 'package:flutter_bill_app/http/core/hi_error.dart';
import 'package:flutter_bill_app/http/dao/home_dao.dart';
import 'package:flutter_bill_app/model/home_mo.dart';
import 'package:flutter_bill_app/page/home_tab_page.dart';
import 'package:flutter_bill_app/page/profile_page.dart';
import 'package:flutter_bill_app/page/video_detail_page.dart';
import 'package:flutter_bill_app/provider/theme_provider.dart';
import 'package:flutter_bill_app/util/color.dart';
import 'package:flutter_bill_app/util/toast.dart';
import 'package:flutter_bill_app/util/view_util.dart';
import 'package:flutter_bill_app/widget/hi_tab.dart';
import 'package:flutter_bill_app/widget/loading_container.dart';
import 'package:flutter_bill_app/widget/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  // final ValueChanged<VideoModel> onJumpToDetail;
  final ValueChanged<int>? onJumpTo;
  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin, WidgetsBindingObserver {
  var listener;

  TabController? _controller;

  // var tabs = ["推荐", "热门", "追播", "影视", "搞笑", "日常", "综合", "手机游戏", "短片·手书·配音"];
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  bool _isLoading = true;
  Widget? _currentPage;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('didChangeAppLifecycleState:$state');
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        if (!(_currentPage is VideoDetailPage)) {
          changeStatusBar(
              color: Colors.white, statusStyle: StatusStyle.DARK_CONTENT, context: context);
        }
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void didChangePlatformBrightness() {
    context.read<ThemeProvider>().darkModeChange();
    super.didChangePlatformBrightness();

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: LoadingContainer(
        cover: true,
        isLoading: _isLoading,
        child: Column(
          children: [
            HiNavigationBar(height: 50,
              child: _appBar(),
              color: Colors.white,
              statusStyle: StatusStyle.DARK_CONTENT,
            ),
            Container(
              decoration: bottomBoxShadow(context),
              child: _tabBar(),
            ),
            Flexible(
                child: TabBarView(
                  controller: _controller,
                  children: categoryList.map((tab) {
                    return HomeTabPage(
                      categoryName: tab.name!,
                      bannerList: tab.name == '推荐' ? bannerList : null,
                    );
                  }).toList(),
                ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _controller = TabController(length: categoryList.length, vsync: this);

    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      this._currentPage = current.page;
      print('home:current:${current.page}');
      print('home:pre:${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('打开了首页:onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页:onPause');
      }

      if (pre?.page is VideoDetailPage && !(current.page is ProfilePage)) {
        var statusStyle = StatusStyle.DARK_CONTENT;
        changeStatusBar(color: Colors.white, statusStyle: statusStyle);
      }
    });

    loadData();
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    _controller!.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _tabBar() {
    return HiTab(
        categoryList.map<Tab>((tab) {
          return Tab(
            text: tab.name,
          );
        }).toList(),
        controller: _controller!,
        fontSize: 16,
        borderWidth: 3,
        insets: 13,
        unselectedLabelColor: Colors.black54);
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
        _isLoading = false;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
      setState(() { _isLoading = false;});
    }
  }

  _appBar() {
    return Padding(padding: EdgeInsets.only(left: 15, right: 15),
    child: Row(
      children: [
        InkWell(
          onTap: (){
            if(widget.onJumpTo != null) {
              widget.onJumpTo!(3);
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: Image(
              height: 46,
              width: 46,
              image: AssetImage('images/avatar.png'),
            ),
          ),
        ),
        Expanded(child: Padding(padding: EdgeInsets.only(left: 15, right: 15),child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(padding: EdgeInsets.only(left: 10),
          height: 32,
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          decoration: BoxDecoration(color: Colors.grey[100]),
          ),
        ),)),
        Icon(
          Icons.explore_off_outlined,
          color: Colors.grey,
        ),
        Padding(padding: EdgeInsets.only(left: 12),
        child: Icon(
          Icons.mail_outline,
          color: Colors.grey,
        ),)
      ],
    ),
    );
  }
}
