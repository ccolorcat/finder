import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../finder.dart' hide ProgressListener;
import 'uri_loader.dart';

typedef ErrorBuilder = Widget Function(BuildContext context, Object error);
typedef LoadingBuilder = Widget Function(BuildContext context);

class UriImage extends StatelessWidget {
  static ErrorBuilder defaultErrorBuilder;
  static LoadingBuilder defaultLoadingBuilder;

  const UriImage(
    this.uri, {
    Key key,
    this.scale = 1.0,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.filterQuality = FilterQuality.low,
    this.isAntiAlias = false,
    this.headers,
    this.cacheWidth,
    this.cacheHeight,
    this.listener,
  }) : super(key: key);

  final Uri uri;
  final double scale;
  final ImageFrameBuilder frameBuilder;
  final LoadingBuilder loadingBuilder;
  final ErrorBuilder errorBuilder;
  final String semanticLabel;
  final bool excludeFromSemantics;
  final double width;
  final double height;
  final Color color;
  final BlendMode colorBlendMode;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Rect centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final FilterQuality filterQuality;
  final bool isAntiAlias;
  final Map<String, String> headers;
  final int cacheWidth;
  final int cacheHeight;
  final ProgressListener listener;

  Widget get _emptyWidget => const SizedBox.shrink();

  Widget _buildErrorWidget(BuildContext context, Object error) {
    final builder = errorBuilder ?? defaultErrorBuilder;
    return builder?.call(context, error) ?? _emptyWidget;
  }

  Widget _buildLoadingWidget(BuildContext context) {
    final builder = loadingBuilder ?? defaultLoadingBuilder;
    return builder?.call(context) ?? _emptyWidget;
  }

  Widget _buildImageFile(BuildContext context, File data) {
    return Image.file(
      data,
      key: ValueKey<String>(data.path),
      scale: scale,
      frameBuilder: frameBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      key: ValueKey<Uri>(uri),
      future: Finder().getFile(
        uri,
        headers: headers,
        listener: listener,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildImageFile(context, snapshot.data);
        }
        if (snapshot.hasError) {
          return _buildErrorWidget(context, snapshot.error);
        }
        return _buildLoadingWidget(context);
      },
    );
  }
}
