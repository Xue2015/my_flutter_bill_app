import 'package:flutter/material.dart';
import 'package:flutter_bill_app/model/video_model.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel? videoModel;
  const VideoDetailPage({Key? key,  this.videoModel}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text('视频详情页，vid：${widget.videoModel!.vid}'),
      ),
    );
  }
}
