// Author: cxx
// GitHub: https://github.com/ccolorcat

import 'package:finder/finder.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  ImagePage(
    this.uri, {
    this.title = 'image demo',
    Key? key,
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
