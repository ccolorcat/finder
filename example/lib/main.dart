import 'package:finder/finder.dart';
import 'package:finder_example/image_page.dart';
import 'package:finder_example/res.dart';
import 'package:flutter/material.dart';

import 'download_page.dart';

const weChat =
    'https://dldir1.qq.com/weixin/android/weixin801android1840_arm64.apk';
const image =
    'https://pic4.zhimg.com/v2-43f8f1ab2ad7ae1848c4ae21ef0cadc4_r.jpg?source=1940ef5c';

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
  HomePage({Key? key}) : super(key: key);

  void _jumpTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildButton(BuildContext context, String text, Widget nextPage) {
    return MaterialButton(
      onPressed: () => _jumpTo(context, nextPage),
      child: Text(text),
      color: Theme.of(context).buttonColor,
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
              Uri.parse(image),
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
