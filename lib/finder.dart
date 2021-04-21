// Author: cxx
// Date: 2021-02-02
// GitHub: https://github.com/ccolorcat

library finder;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import 'src/uri_loader.dart';
import 'src/loader_task.dart';
import 'src/log.dart';
import 'src/lru_cache.dart';
import 'src/path_resolver.dart';
import 'src/uris.dart';

export 'src/uri_loader.dart';
export 'src/finder_image.dart';
export 'src/path_resolver.dart';
export 'src/uri_image.dart';
export 'src/uris.dart' show withAsset;

part 'src/_core_finder.dart';

abstract class Finder {
  static Finder _singleton = _CoreFinder();

  static bool loggable = false;

  PathResolver defaultResolver = defaultResolve;

  /// If no [UriLoader] for specified [Uri]，this will be used.
  UriLoader defaultLoader;

  factory Finder() => _singleton;

  Finder._internal();

  /// Register a [UriLoader] for specified [scheme]
  /// scheme: http, https, file etc.
  /// http, https, file and [KScheme] provided by default.
  void registerUriLoader(String scheme, UriLoader loader);

  void unregisterUriLoader(String scheme);

  /// Register a [PathResolver] for specified [scheme]
  /// scheme: http, https, file etc.
  /// [KScheme] and globale [defaultResolver] provided by default.
  void registerPathResolver(String scheme, PathResolver resolver);

  void unregisterPathResolver(String scheme);

  /// This will be cached to disk and memory.
  /// [headers] will be used for http/https [Uri]
  Future<Uint8List> getData(
    Uri uri, {
    Map<String, Object> headers,
    ProgressListener listener,
  });

  /// This will be cached to disk.
  /// [headers] will be used for http/https [Uri]
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

  void memoryCachePolicy(
    int maxSize, {
    SizeOf<Uri, Uint8List> sizeOf = defaultSizeOf,
  });
}
