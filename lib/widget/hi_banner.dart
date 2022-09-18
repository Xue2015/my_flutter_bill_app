import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bill_app/model/home_mo.dart';

class HiBanner extends StatelessWidget {
  final List<BannerMo>? bannerList;
  final double bannerHeight;
  final EdgeInsetsGeometry? padding;

  const HiBanner(this.bannerList,
      {Key? key, this.bannerHeight = 160, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bannerHeight,
      child: _banner(),
    );
  }

  _banner() {
    var right = 10 + (padding?.horizontal ?? 0) / 2;
    return Swiper(
      itemCount: bannerList!.length,
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        return _image(bannerList![index]);
      },
    );
  }

  _image(BannerMo bannerMo) {
    return InkWell(
      onTap: () {
        print(bannerMo.title);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: Image.network(
          bannerMo.cover!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
