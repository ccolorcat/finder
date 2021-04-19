// Author: cxx
// Date: 2021-02-02
// GitHub: https://github.com/ccolorcat

library finder;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:finder/loader_task.dart';
import 'package:finder/log.dart';
import 'package:finder/lru_cache.dart';
import 'package:finder/path_resolver.dart';
import 'package:finder/uri_loader.dart';
import 'package:finder/uris.dart';
import 'package:path_provider/path_provider.dart';

export 'package:finder/finder_image.dart';
export 'package:finder/path_resolver.dart';
export 'package:finder/uri_image.dart';
export 'package:finder/uri_loader.dart';
export 'package:finder/uris.dart' show withAsset;

part '_core_finder.dart';

abstract class Finder {
  static Finder _singleton = _CoreFinder();

  static bool loggable = true;

  PathResolver defaultResolver = defaultResolve;

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
