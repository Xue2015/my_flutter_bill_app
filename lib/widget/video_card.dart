import 'package:flutter/material.dart';
import 'package:flutter_bill_app/model/home_mo.dart';

class VideoCard extends StatelessWidget {
  final VideoMo videoMo;
  const VideoCard({Key? key, required this.videoMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(videoMo.url);
      },
      child: Image.network(videoMo.cover!),
    );
  }
}
