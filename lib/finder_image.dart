// Author: cxx
// GitHub: https://github.com/ccolorcat

import 'dart:ffi';
import 'dart:ui' as ui show Codec;

import 'package:finder/finder.dart';
import 'package:finder/uri_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class FinderImage extends ImageProvider<FinderImage> {
  const FinderImage(
    this.uri, {
    this.scale = 1.0,
    this.headers,
    this.listener,
  })  : assert(uri != null),
        assert(scale != null);

  FinderImage.withAsset({
    @required String assetName,
    String packageName,
    this.scale = 1.0,
  })  : uri = withAsset(assetName: assetName, packageName: packageName),
        headers = null,
        listener = null;

  final Uri uri;
  final double scale;
  final Map<String, Object> headers;
  final ProgressListener listener;

  @override
  Future<FinderImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<FinderImage>(this);
  }

  @override
  ImageStreamCompleter load(FinderImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: key.uri.toString(),
      informationCollector: () sync* {
        yield ErrorDescription('uri: $uri');
      },
    );
  }

  Future<ui.Codec> _loadAsync(FinderImage key, DecoderCallback decode) async {
    assert(key == this);
    final bytes = await Finder().getData(
      key.uri,
      headers: headers,
      listener: listener,
    );
    if (bytes.lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance.imageCache.evict(key);
      throw StateError('$uri cannot be loaded as an image.');
    }
    return await decode(bytes);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinderImage &&
          runtimeType == other.runtimeType &&
          uri == other.uri &&
          scale == other.scale;

  @override
  int get hashCode => hashValues(uri, scale);

  @override
  String toString() {
    return 'FinderImage{uri: $uri, scale: $scale, headers: $headers, listener: $listener}';
  }
}
