// Author: cxx
// Date: 2021-03-08
// GitHub: https://github.com/ccolorcat
import 'dart:io';

import 'package:finder/finder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const panda =
    'http://www.ghost64.com/qqtupian/zixunImg/local/2018/11/14/15421855672417.jpeg';
const weChat =
    'https://dldir1.qq.com/weixin/android/weixin801android1840_arm64.apk';

class ExamplePage extends StatefulWidget {
  final uri = Uri.parse(weChat);

  ExamplePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  File _file;
  int _percent = 0;

  Future<void> _handlerClick() async {
    _file = await Finder().getFile(
      widget.uri,
      listener: (total, cached, percent) {
        _percent = percent;
        setState(() {});
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: FinderImage(Uri.parse(panda))),
          _file != null ? Text(_file.path) : const SizedBox.shrink(),
          TextButton(
            onPressed: _handlerClick,
            child: Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  value: _percent / 100.0,
                  backgroundColor: Colors.orange,
                  minHeight: 48.0,
                ),
                Text(
                  _percent == 0 ? 'download' : '$_percent%',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
