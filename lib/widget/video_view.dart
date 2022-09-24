

import 'package:chewie/chewie.dart' hide MaterialControls;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bill_app/util/color.dart';
import 'package:flutter_bill_app/util/view_util.dart';
import 'package:flutter_bill_app/widget/hi_video_controls.dart';
import 'package:orientation/orientation.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String url;
  final String cover;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;
  final Widget overlayUI;
  final Widget barrageUI;

  const VideoView(this.url,
      {Key? key,
      required this.cover,
      this.autoPlay = false,
      this.looping = false,
      this.aspectRatio = 16 / 9, required this.overlayUI,
        required this.barrageUI})
      : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  get _placeholder => FractionallySizedBox(
    widthFactor: 1,
    child: cachedImage(widget.cover),
  );

  get _progressColors => ChewieProgressColors(
    playedColor: primary,
    handleColor: primary,
    backgroundColor: Colors.grey,
    bufferedColor: primary[50]!
  );

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: widget.aspectRatio,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      allowMuting: false,
      placeholder: _placeholder,
      allowPlaybackSpeedChanging: false,
      customControls: MaterialControls(
        showLoadingOnInitialize: false,
        showBigPlayIcon: false,
        bottomGradient: blackLinearGradient(),
        overlayUI: widget.overlayUI,
        barrageUI: widget.barrageUI,
      ),
      materialProgressColors: _progressColors
    );
    _chewieController!.addListener(_fullScreenListener);
  }

  @override
  void dispose() {
    _chewieController!.removeListener(_fullScreenListener);
    _videoPlayerController!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth / widget.aspectRatio;
    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController!,
      ),
    );
  }

  void _fullScreenListener() {
    Size size = MediaQuery.of(context).size;
    if (size.width > size.height) {
      OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    }
  }
}
