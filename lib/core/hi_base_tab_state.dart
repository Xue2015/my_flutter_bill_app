import 'package:flutter/material.dart';
import 'package:flutter_bill_app/core/hi_state.dart';
import 'package:flutter_bill_app/http/core/hi_error.dart';
import 'package:flutter_bill_app/util/color.dart';
import 'package:flutter_bill_app/util/toast.dart';

abstract class HiBaseTabState<M, L,T extends StatefulWidget> extends HiState<T>
    with AutomaticKeepAliveClientMixin {
  List<L> dataList = [];
  int pageIndex = 1;
  bool loading = false;
  ScrollController scrollController = ScrollController();
  get contentChild;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      var dis = scrollController.position.maxScrollExtent -
          scrollController.position.pixels;
      print('dis:$dis');

      if (dis < 300 && !loading && scrollController.position.maxScrollExtent!=0) {
        loadData(loadMore: true);
      }
    });
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: contentChild),
      onRefresh: loadData,
      color: primary,
    );
  }

  Future<M> getData(int pageIndex);

  List<L> parseList(M result);

  Future<void> loadData({loadMore = false}) async {
    if (loading) {
      print('上次加载还没完成...');
      return;
    }

    loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }

    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    print('loading:currentIndex:$currentIndex');

    try {
      var result = await getData(currentIndex);
      print('loadData(): $result');

      setState(() {
        if (loadMore) {

          dataList = [...dataList, ...parseList(result)];
          if (parseList(result).length != 0) {
            pageIndex++;
          }

        } else {
          dataList = parseList(result);
        }
      });

      Future.delayed(Duration(milliseconds: 1000), () {
        loading = false;
      });
    } on NeedAuth catch (e) {
      loading = false;
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      loading = false;
      print(e);
      showWarnToast(e.message);
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}