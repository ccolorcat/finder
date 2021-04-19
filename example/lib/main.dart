import 'package:finder/finder.dart';
import 'package:finder_example/image_page.dart';
import 'package:finder_example/res.dart';
import 'package:flutter/material.dart';

import 'download_page.dart';

const weChat =
    'https://dldir1.qq.com/weixin/android/weixin801android1840_arm64.apk';
const panda =
    'http://www.ghost64.com/qqtupian/zixunImg/local/2018/11/14/15421855672417.jpeg';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('download demo'),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  void _jumpTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildButton(BuildContext context, String text, Widget nextPage) {
    return FlatButton(
      onPressed: () => _jumpTo(context, nextPage),
      color: Theme.of(context).accentColor,
      child: Text(text),
      colorBrightness: Brightness.dark,
      minWidth: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(
            context,
            'asset image demo',
            ImagePage(
              withAsset(assetName: Res.ic_avatar),
              title: 'asset image demo',
            ),
          ),
          _buildButton(
            context,
            'remote image demo',
            ImagePage(
              Uri.parse(panda),
              title: 'remote image demo',
            ),
          ),
          _buildButton(
            context,
            'download demo',
            DownloadPage(
              Uri.parse(weChat),
              title: 'download demo',
            ),
          ),
        ],
      ),
    );
  }
}
