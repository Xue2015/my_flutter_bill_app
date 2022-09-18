import 'package:flutter/material.dart';
import 'package:flutter_bill_app/model/home_mo.dart';
import 'package:flutter_bill_app/widget/hi_banner.dart';

class HomeTabPage extends StatefulWidget {
  final String name;
  final List<BannerMo>? bannerList;

  const HomeTabPage({Key? key, required this.name, this.bannerList})
      : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(children: [if (widget.bannerList != null) _banner()],),
    );
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: HiBanner(widget.bannerList),);
  }
}