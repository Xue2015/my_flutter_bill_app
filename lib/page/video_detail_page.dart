import 'package:flutter/material.dart';
import 'package:flutter_bill_app/model/home_mo.dart';
import 'package:flutter_bill_app/widget/video_view.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoMo? videoModel;

  const VideoDetailPage({Key? key, this.videoModel}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('视频详情页，vid：${widget.videoModel!.vid}'),
          Text('视频详情页，title：${widget.videoModel!.title}'),
          _videoView()
        ],
      ),
    );
  }

  _videoView() {
    var model = widget.videoModel;
    return VideoView(model!.url!, cover: model.cover!);
  }
}
