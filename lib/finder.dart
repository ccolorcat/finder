// Author: cxx
// Date: 2021-02-02
// GitHub: https://github.com/ccolorcat

library finder;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'lru_cache.dart';

part '_core_finder.dart';

part '_loader_task.dart';

part '_utils.dart';

part 'path_resolver.dart';

part 'uri_loader.dart';

abstract class Finder {
  static const MethodChannel _channel = const MethodChannel('finder');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Finder _singleton = _CoreFinder();

  static bool loggable = true;

  PathResolver defaultResolver = _defaultResolve;

  UriLoader defaultLoader;

  factory Finder() => _singleton;

  Finder._internal();

  void registerUriLoader(String scheme, UriLoader loader);

  void unregisterUriLoader(String scheme);

  void registerPathResolver(String scheme, PathResolver resolver);

  void unregisterPathResolver(String scheme);

  Future<Uint8List> getData(
    Uri uri, {
    Map<String, Object> headers,
    ProgressListener listener,
  });

  Future<File> getFile(
    Uri uri, {
    Map<String, Object> headers,
    ProgressListener listener,
  });

  Future<File> onlyRemote(
    Uri uri, {
    Map<String, Object> headers,
    ProgressListener listener,
  });

  Future<File> onlyStorage(Uri uri);

  Uint8List onlyMemory(Uri uri);
}
