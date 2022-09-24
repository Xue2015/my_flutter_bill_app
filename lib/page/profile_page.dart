import 'package:flutter/material.dart';
import 'package:flutter_bill_app/http/core/hi_error.dart';
import 'package:flutter_bill_app/http/dao/ProfileDao.dart';
import 'package:flutter_bill_app/model/profile_mo.dart';
import 'package:flutter_bill_app/util/toast.dart';
import 'package:flutter_bill_app/util/view_util.dart';
import 'package:flutter_bill_app/widget/hi_blur.dart';
import 'package:flutter_bill_app/widget/hi_flexible_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileMo? _profileMo;
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 160,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                titlePadding: EdgeInsets.only(left: 0),
                title: _buildHead(),
                background: Stack(
                  children: [
                    Positioned.fill(
                        child: cachedImage(
                            'https://img1.baidu.com/it/u=587620844,3094454201&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800')),
                    Positioned.fill(
                        child: HiBlur(
                      sigma: 20,
                    ))
                  ],
                ),
              ),
            )
          ];
        },
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('标题$index'),
            );
          },
          itemCount: 20,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      ProfileMo result = await ProfileDao.get();
      print(result);
      setState(() {
        _profileMo = result;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildHead() {
    if (_profileMo == null) {
      return Container();
    }

    return HiFlexibleHeader(
        name: _profileMo!.name!,
        face: _profileMo!.face!,
        controller: _controller);
  }
}
