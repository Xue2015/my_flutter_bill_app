import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bill_app/barrage/barrage_item.dart';
import 'package:flutter_bill_app/barrage/barrage_view_util.dart';
import 'package:flutter_bill_app/barrage/hi_socket.dart';
import 'package:flutter_bill_app/barrage/ibarrage.dart';
import 'package:flutter_bill_app/model/barrage_model.dart';

enum BarrageStatus { play, pause }

class HiBarrage extends StatefulWidget {
  final int lineCount;
  final String vid;
  final int speed;
  final double top;
  final bool autoPlay;

  const HiBarrage(
      {Key? key,
      this.lineCount = 4,
      required this.vid,
      this.speed = 800,
      this.top = 0,
      this.autoPlay = false})
      : super(key: key);

  @override
  State<HiBarrage> createState() => HiBarrageState();
}

class HiBarrageState extends State<HiBarrage> implements IBarrage {
  HiSocket? _hiSocket;
  double? _height;
  double? _width;
  List<BarrageItem> _barrageItemList = [];
  List<BarrageModel> _barrageModelList = [];
  int _barrageIndex = 0;
  Random _random = Random();
  BarrageStatus? _barrageStatus;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: _width,
        height: _height,
        child: Stack(
          children: [Container()]..addAll(_barrageItemList),
        ));
  }

  @override
  void initState() {
    super.initState();
    _hiSocket = HiSocket();
    _hiSocket!.open(widget.vid).listen((value) {
      _handleMessage(value);
    });
  }

  @override
  void dispose() {
    if (_hiSocket != null) {
      _hiSocket!.close();
    }

    if (_timer != null) {
      _timer!.cancel();
    }

    super.dispose();
  }

  void _handleMessage(List<BarrageModel> modelList, {bool instant = false}) {
    if (instant) {
      _barrageModelList.insertAll(0, modelList);
    } else {
      _barrageModelList.addAll(modelList);
    }

    if (_barrageStatus == BarrageStatus.play) {
      play();
      return;
    }

    if (widget.autoPlay && _barrageStatus != BarrageStatus.pause) {
      play();
    }
  }

  @override
  void play() {
    _barrageStatus = BarrageStatus.play;
    print('action:play');
    if (_timer != null && _timer!.isActive) {
      return;
    }

    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (_barrageModelList.isNotEmpty) {
        var temp = _barrageModelList.removeAt(0);
        addBarrage(temp);
        print('start:${temp.content}');
      } else {
        print('All barrage are sent');
        _timer!.cancel();
      }
    });
  }

  void addBarrage(BarrageModel model) {
    double perRowHeight = 30;
    var line = _barrageIndex % widget.lineCount;
    _barrageIndex++;
    var top = line * perRowHeight + widget.top;

    String id = '${_random.nextInt(10000)}:${model.content}';
    var item = BarrageItem(
      id: id,
      top: top,
      child: BarrageViewUtil.barrageView(model),
      onComplete: _onComplete,
    );

    _barrageItemList.add(item);
    setState((){});
  }

  @override
  void pause() {
    _barrageStatus = BarrageStatus.pause;
    _barrageItemList.clear();
    setState(() {});
    print('action:pause');
    _timer!.cancel();
  }

  @override
  void send(String message) {
    if (message == null) {
      return;
    }

    _hiSocket!.send(message);
    _handleMessage(
        [BarrageModel(content: message, vid: '-1', priority: 1, type: 1)]);
  }

  void _onComplete(id) {
    print('Done:${id}');
    _barrageItemList.removeWhere((element) => element.id == id);
  }
}
