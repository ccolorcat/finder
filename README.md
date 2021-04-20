# finder

A cache manager for flutter, flexible and easy-to-use.

## Quick Start

```dart
import 'package:finder/finder.dart';

demo(Uri uri) async {
  final file = await Finder().getFile(uri);
}
```

## Sample

***FinderImage***

```dart
import 'package:finder/finder.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  ImagePage(
    this.uri, {
    this.title = 'image demo',
    Key key,
  }) : super(key: key);

  final String title;
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Align(
          alignment: Alignment.center,
          child: Image(
            image: FinderImage(uri),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
```

***download***

```dart
import 'dart:io';

import 'package:finder/finder.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  DownloadPage(
    this.uri, {
    Key key,
    this.title = 'download demo',
  }) : super(key: key);

  final Uri uri;
  final String title;

  @override
  State<StatefulWidget> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_file?.path ?? ''),
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
      ),
    );
  }
}
```

