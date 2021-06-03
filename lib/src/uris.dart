// Author: cxx
// GitHub: https://github.com/ccolorcat

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'uri_loader.dart';

const kScheme = 'finder';
const _host = 'asset';
const _path = 'packages';

const _package = 'package';
const _name = 'name';

Uri withAsset({
  required String assetName,
  String? packageName,
}) {
  return Uri(
    scheme: kScheme,
    host: _host,
    path: _path,
    queryParameters: {_package: packageName, _name: assetName},
  );
}

FutureOr<File> resolveAsset(Uri uri, Directory root) async {
  _checkAsset(uri);
  final queries = uri.queryParameters;
  final package = queries[_package];
  final asset = queries[_name]!;

  var fileName = package?.isNotEmpty == true ? '$package/$asset' : asset;
  fileName = fileName.replaceAll('/', '_');
  return File('${root.path}/$fileName');
}

Future<File> loadAsset(
  Uri uri,
  File save, {
  Map<String, Object>? headers,
  ProgressListener? listener,
}) async {
  _checkAsset(uri);
  final queries = uri.queryParameters;
  final package = queries[_package];
  final asset = queries[_name]!;

  final keyName =
      package?.isNotEmpty == true ? 'packages/$package/$asset' : asset;
  final byteData = await rootBundle.load(keyName);
  await save.writeAsBytes(
    byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    ),
    flush: true,
  );
  return save;
}

void _checkAsset(Uri uri) {
  if (kScheme != uri.scheme) {
    throw ArgumentError('the scheme is not $kScheme: $uri');
  }
  if (_host != uri.host) {
    throw ArgumentError('the host is not $_host: $uri');
  }
}
